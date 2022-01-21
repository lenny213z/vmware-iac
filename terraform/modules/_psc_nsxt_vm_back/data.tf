
data "nsxt_policy_transport_zone" "overlay_tz" {
  display_name = "nsx-overlay-transportzone"
}

data "vsphere_datacenter" "datacenter" {
  name = "${var.dc}"
}

data "vsphere_datastore" "datastore" {
  name = "${var.datastore}"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "${var.cluster}"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

data "vsphere_virtual_machine" "vm_template" {
  name = "${var.vm_template}"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

data "vsphere_network" "segment" {
  depends_on = [
    time_sleep.wait_30_seconds
  ]
  name          = "${var.nsxt_segment["name"]}"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}
