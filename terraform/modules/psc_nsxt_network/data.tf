data "nsxt_policy_edge_cluster" "edge_cluster" {
  display_name = "psc-nsx-edgecl01"
}

data "nsxt_policy_tier0_gateway" "t0_gw" {
  display_name = "psc-nsx-t0-gw"
}

data "nsxt_policy_dhcp_server" "dhcp" {
  display_name = "global-nsx-dhcp-service"
}

data "nsxt_policy_transport_zone" "overlay_tz" {
  display_name = "nsx-overlay-transportzone"
}
