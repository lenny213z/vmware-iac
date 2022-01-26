################################################################################

locals {
  dc        = "TP-CorpIT"
  datastore = "MAR-VRA-DS02"
  cluster   = "NSX-POC"
}
#
resource "vsphere_tag_category" "category" {
  name        = var.project
  cardinality = "SINGLE"
  description = "Managed by Terraform"

  associable_types = [
    "VirtualMachine",
    "Datastore",
  ]
}
#
resource "vsphere_tag" "tag" {
  name        = var.tag
  category_id = vsphere_tag_category.category.id
  description = "Managed by Terraform"
}
#
module "web" {
  source         = "../../modules/psc_nsxt_vm"
  dc             = local.dc
  datastore      = local.datastore
  cluster        = local.cluster
  vm_name        = "${var.project}-${var.vm["name"]}"
  vm_count       = var.vm["count"]
  vm_template    = var.vm_template
  network_id     = data.vsphere_network.segment.id
  nsxt_tag_scope = var.project
  tag            = var.tag
}
#
module "web-lb" {
  source            = "../../modules/psc_nsxt_lb"
  connectivity_path = data.terraform_remote_state.base.outputs.t1_path
  lb = {
    name        = "${var.project}-lb"
    size        = "SMALL"
    description = "LB"
  }
  vip = {
    name        = "${var.project}-vip"
    description = "${var.project}-desc"
    ipaddrv4    = var.vip["ipaddrv4"]
  }
  vip_ports = ["80", "443"]
  pool = {
    name        = "${var.project}-pool"
    description = "${var.project}-pool"
    algorithm   = "ROUND_ROBIN"
  }
  members_group  = module.web.group
  nsxt_tag_scope = var.project
  tag            = var.tag
}
#
#module "web-fw" {
#  source = "../../modules/psc_nsxt_security_policies"
#  dfw = {
#    name        = "Web"
#    description = "Distributed Firewall for Web Group"
#  }
#  rules = [{
#    name   = "Microsegment"
#    action = "DROP"
#    src    = [data.terraform_remote_state.base.outputs.group["Web"][0]]
#    dst    = [data.terraform_remote_state.base.outputs.group["Web"][0]]
#    services = ["any"]
#  }]
#  tag_scope = "Tier"
#  tag       = "Web"
#}