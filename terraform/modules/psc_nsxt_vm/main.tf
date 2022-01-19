# This resource will destroy (potentially immediately) after null_resource.next
resource "null_resource" "previous" {}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [null_resource.previous]
  create_duration = "30s"
}

resource "nsxt_policy_segment" "segment" {
  display_name        = "${var.nsxt_segment["name"]}"
  description         = "${var.nsxt_segment["description"]}"
  transport_zone_path = "${data.nsxt_policy_transport_zone.overlay_tz.path}"
  connectivity_path   = "${var.connectivity_path}"
  depends_on          = [var.depends]

  subnet {
    cidr        = "${var.nsxt_segment["cidr"]}"
    dhcp_ranges = [var.nsxt_segment["dhcp_ranges"]]

    dhcp_v4_config {
      dns_servers = "${var.dns_servers}"
    }
  }
  tag {
    scope = "${var.nsxt_tag_scope}"
    tag   = "${var.nsxt_tag}"
  }
  tag {
    scope = "${var.tag_scope}"
    tag   = "${var.tag}"
  }
}

resource "vsphere_tag_category" "category" {
  name        = "${var.tag_scope}"
  cardinality = "SINGLE"
  description = "Managed by Terraform"

  associable_types = [
    "VirtualMachine",
    "Datastore",
  ]
}

resource "vsphere_tag" "tag" {
  name        = "${var.tag}"
  category_id = "${vsphere_tag_category.category.id}"
  description = "Managed by Terraform"
}

# This part creates the Virtual Machines in Vsphere that are needed for the App
resource "vsphere_virtual_machine" "vm" {
  count = "${var.vm_count}"
  name = "${var.vm_name}0${count.index + 1}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id = "${data.vsphere_datastore.datastore.id}"
  num_cpus = "${data.vsphere_virtual_machine.vm_template.num_cpus}"
  memory = "${data.vsphere_virtual_machine.vm_template.memory}"
  guest_id = "${data.vsphere_virtual_machine.vm_template.guest_id}"
  # ...
  # Attach the VM to the network data source that refers to the newly created Segments
  network_interface {
    network_id = "${data.vsphere_network.segment.id}"
    adapter_type = "${data.vsphere_virtual_machine.vm_template.network_interface_types[0]}"
  }
  disk {
    label = "${var.vm_name}"
    size = "${data.vsphere_virtual_machine.vm_template.disks.0.size}"
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.vm_template.id}"
    linked_clone = true

    customize {
      linux_options {
        host_name = "${var.vm_name}0${count.index + 1}"
        domain = "localdomain"
      }
      network_interface {}
      timeout = 45
    }
  }
  tags = ["${vsphere_tag.tag.id}"]
}

## Assign the right tags to the VMs so that they get included in the
## dynamic groups created above
resource "nsxt_policy_vm_tags" "vm_tag" {
  count = "${var.vm_count}"
  instance_id = "${vsphere_virtual_machine.vm[count.index].id}"
  depends_on = [
    vsphere_virtual_machine.vm
  ]
  tag {
    scope = "${var.nsxt_tag_scope}"
    tag   = "${var.nsxt_tag}"
  }
  tag {
    scope = "${var.tag_scope}"
    tag   = "${var.tag}"
  }
}

# All Virtual machines with specific tag and scope
resource "nsxt_policy_group" "nsxt_group" {
  display_name = "${var.tag}"
  description = "Autogenerate Group for VMs with the defined tag"
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator    = "CONTAINS"
      key         = "Tag"
      value       = "${var.tag}"

    }
  }
  tag {
    scope = "${var.nsxt_tag_scope}"
    tag   = "${var.nsxt_tag}"
  }
}
