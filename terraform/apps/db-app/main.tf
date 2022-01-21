################################################################################

locals {
  dc        = "TP-CorpIT"
  datastore = "MAR-VRA-DS02"
  cluster   = "NSX-POC"
}
#
resource "vsphere_tag" "tag" {
  name        = "DB"
  category_id = "${data.terraform_remote_state.base.outputs.vm_category}"
  description = "Managed by Terraform"
}
#
module "db" {
  source              = "../../modules/psc_nsxt_vm"
  dc                  = local.dc
  datastore           = local.datastore
  cluster             = local.cluster
  vm_name             = "${var.vm["name"]}"
  vm_count            = "${var.vm["count"]}"
  vm_template         = "centos8_packer_template"
  network_id          = "${data.vsphere_network.segment.id}"
  tag_scope           = "Tier"
  tag                 = "${vsphere_tag.tag.id}"
}
#
module "db-fw" {
  source              = "../../modules/psc_nsxt_security_policies"
  dfw                 = {
    name              = "DB"
    description       = "Distributed Firewall for Web Group"
  }
  rules               = [ {
    name = "Microsegment"
    action = "DROP"
    dst = [data.terraform_remote_state.base.outputs.group["DB"][0]]
    src = [data.terraform_remote_state.base.outputs.group["DB"][0]]
  } ]
  tag_scope           = "Tier"
  tag                 = "DB"
}