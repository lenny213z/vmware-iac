################################################################################

locals {
  dc        = "TP-CorpIT"
  datastore = "MAR-VRA-DS02"
  cluster   = "NSX-POC"
}
#
resource "vsphere_tag" "tag" {
  name        = "Web"
  category_id = data.terraform_remote_state.base.outputs.vm_category
  description = "Managed by Terraform"
}
#
module "web" {
  source      = "../../modules/psc_nsxt_vm"
  dc          = local.dc
  datastore   = local.datastore
  cluster     = local.cluster
  vm_name     = var.vm["name"]
  vm_count    = var.vm["count"]
  vm_template = var.vm_template
  network_id  = data.vsphere_network.segment.id
  tag_scope   = "Tier"
  tag         = "Web"
}
#
module "web-lb" {
  source            = "../../modules/psc_nsxt_lb"
  connectivity_path = data.terraform_remote_state.base.outputs.t1_path
  lb = {
    name        = "web-lb"
    size        = "SMALL"
    description = "Web LB"
  }
  vip = {
    name        = var.vip["name"]
    description = var.vip["description"]
    ipaddrv4    = var.vip["ipaddrv4"]
  }
  vip_ports = ["80", "443"]
  pool = {
    name        = "WebPool"
    description = "Web Servers Pool"
    algorithm   = "ROUND_ROBIN"
  }
  members_group = data.terraform_remote_state.base.outputs.group["Web"][0]
  tag_scope     = "Tier"
  tag           = "Web"
}

module "web-fw" {
  source = "../../modules/psc_nsxt_security_policies"
  dfw = {
    name        = "Web"
    description = "Distributed Firewall for Web Group"
  }
  rules = [{
    name   = "Microsegment"
    action = "DROP"
    dst    = [data.terraform_remote_state.base.outputs.group["Web"][0]]
    src    = [data.terraform_remote_state.base.outputs.group["Web"][0]]
  }]
  tag_scope = "Tier"
  tag       = "Web"
}