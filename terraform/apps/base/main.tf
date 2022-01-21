#
resource "nsxt_policy_tier1_gateway" "t1_gw" {
  display_name = var.nsx_t1gw["name"]
  description  = var.nsx_t1gw["description"]
  #  nsx_id                    = "nsx_id"
  edge_cluster_path         = data.nsxt_policy_edge_cluster.edge_cluster.path
  dhcp_config_path          = data.nsxt_policy_dhcp_server.dhcp.path
  failover_mode             = "PREEMPTIVE"
  default_rule_logging      = "false"
  enable_firewall           = "true"
  enable_standby_relocation = "false"
  tier0_path                = data.nsxt_policy_tier0_gateway.t0_gw.path
  route_advertisement_types = ["TIER1_STATIC_ROUTES", "TIER1_CONNECTED"]
  pool_allocation           = "ROUTING"
}
#
resource "vsphere_tag_category" "category" {
  name        = "Tier"
  cardinality = "SINGLE"
  description = "Managed by Terraform"

  associable_types = [
    "VirtualMachine",
    "Datastore",
  ]
}
#
module "segment" {
  source   = "../../modules/psc_nsxt_network"
  for_each = { for segment in var.nsxt_segment : segment.name => segment }
  nsxt_segment = {
    name        = each.value.name
    description = each.value.description
    cidr        = each.value.cidr
    dhcp_ranges = each.value.dhcp_ranges
  }

  tag_scope         = "Tier"
  connectivity_path = nsxt_policy_tier1_gateway.t1_gw.path
}
#