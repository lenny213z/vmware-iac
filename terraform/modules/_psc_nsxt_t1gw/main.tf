
resource "nsxt_policy_tier1_gateway" "t1_gw" {
  display_name              = "${var.nsx_t1gw["name"]}"
  description               = "${var.nsx_t1gw["description"]}"
#  nsx_id                    = "nsx_id"
  edge_cluster_path         = "${data.nsxt_policy_edge_cluster.edge_cluster.path}"
  dhcp_config_path          = "${data.nsxt_policy_dhcp_server.dhcp.path}"
  failover_mode             = "PREEMPTIVE"
  default_rule_logging      = "false"
  enable_firewall           = "true"
  enable_standby_relocation = "false"
  tier0_path                = "${data.nsxt_policy_tier0_gateway.t0_gw.path}"
  route_advertisement_types = ["TIER1_STATIC_ROUTES", "TIER1_CONNECTED"]
  pool_allocation           = "ROUTING"

  tag {
    scope = var.nsxt_tag_scope
    tag   = var.nsxt_tag
  }
}