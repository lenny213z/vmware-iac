
data "vsphere_datacenter" "datacenter" {
  name = var.dc
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "vm_template" {
  name          = var.vm_template
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

