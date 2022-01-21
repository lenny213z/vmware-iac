
#resource "nsxt_policy_tier1_gateway" "t1_gw" {
#  display_name              = "${var.nsx_t1gw["name"]}"
#  description               = "${var.nsx_t1gw["description"]}"
##  nsx_id                    = "nsx_id"
#  edge_cluster_path         = "${data.nsxt_policy_edge_cluster.edge_cluster.path}"
#  dhcp_config_path          = "${data.nsxt_policy_dhcp_server.dhcp.path}"
#  failover_mode             = "PREEMPTIVE"
#  default_rule_logging      = "false"
#  enable_firewall           = "true"
#  enable_standby_relocation = "false"
#  tier0_path                = "${data.nsxt_policy_tier0_gateway.t0_gw.path}"
#  route_advertisement_types = ["TIER1_STATIC_ROUTES", "TIER1_CONNECTED"]
#  pool_allocation           = "ROUTING"
#
#  tag {
#    scope = var.nsxt_tag_scope
#    tag   = var.nsxt_tag
#  }
#}

resource "nsxt_policy_segment" "segment" {
  display_name        = "${var.nsxt_segment["name"]}"
  description         = "${var.nsxt_segment["description"]}"
  transport_zone_path = "${data.nsxt_policy_transport_zone.overlay_tz.path}"
  connectivity_path   = "${var.connectivity_path}"

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
    tag   = "${var.nsxt_segment["name"]}"
  }
}

# All Virtual machines with specific tag and scope
resource "nsxt_policy_group" "nsxt_group" {
  display_name = "${var.nsxt_segment["name"]}"
  description = "Autogenerate Group for VMs with the defined tag"
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator    = "CONTAINS"
      key         = "Tag"
      value       = "${var.nsxt_segment["name"]}"

    }
  }
  tag {
    scope = "${var.nsxt_tag_scope}"
    tag   = "${var.nsxt_tag}"
  }
}
