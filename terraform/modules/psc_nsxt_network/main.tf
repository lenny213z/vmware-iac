
resource "nsxt_policy_segment" "segment" {
  display_name        = var.nsxt_segment["name"]
  description         = var.nsxt_segment["description"]
  transport_zone_path = data.nsxt_policy_transport_zone.overlay_tz.path
  connectivity_path   = var.connectivity_path

  subnet {
    cidr        = var.nsxt_segment["cidr"]
    dhcp_ranges = [var.nsxt_segment["dhcp_ranges"]]

    dhcp_v4_config {
      dns_servers = var.dns_servers
    }
  }
  tag {
    scope = var.nsxt_tag_scope
    tag   = var.nsxt_tag
  }
}
