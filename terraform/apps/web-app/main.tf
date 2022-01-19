################################################################################

locals {
  dc        = "TP-CorpIT"
  datastore = "MAR-VRA-DS02"
  cluster   = "NSX-POC"
}
#
module "t1gw" {
  source              = "../../modules/psc_nsxt_t1gw"
  nsx_t1gw  = {
    name        = "grib-t1-gw"
    description = "Terraform Deployed T1 GW"
  }
}
#
module "web" {
  source              = "../../modules/psc_nsxt_vm"
  connectivity_path   = module.t1gw.path
  depends             = ["module.t1gw"]
  dc                  = local.dc
  datastore           = local.datastore
  cluster             = local.cluster
  vm_name             = "${var.vm_name}"
  vm_count            = "2"
  vm_template         = "centos8_packer_template"
  nsxt_segment        = {
    name              = "web"
    description       = "Web Segment"
    cidr              = "10.65.52.1/25"
    dhcp_ranges       = "10.65.52.10-10.65.52.120"
  }
  tag_scope           = "Tier"
  tag                 = "Web"
}
#
module "web-lb" {
  source              = "../../modules/psc_nsxt_lb"
  connectivity_path   = module.t1gw.path
  lb = {
    name              = "web-lb"
    size              = "SMALL"
    description       = "Web LB"
  }
  vip = {
    name              = "web-vip"
    description       = "Web VIP"
    ipaddrv4          = "10.65.52.5"
  }
  vip_ports           = ["80", "443"]
  pool = {
    name              = "WebPool"
    description       = "Web Servers Pool"
    algorithm         = "ROUND_ROBIN"
  }
  members_group       = module.web.group_path
  tag_scope           = "Tier"
  tag                 = "Web"
}

module "web-fw" {
  source              = "../../modules/psc_nsxt_security_policies"
  dfw                 = {
    name              = "Web"
    description       = "Distributed Firewall for Web Group"
  }
  rules               = [ {
    name = "Microsegment"
    action = "DROP"
    dst = [module.web.group_path]
    src = [module.web.group_path]
  } ]
  tag_scope           = "Tier"
  tag                 = "Web"
}