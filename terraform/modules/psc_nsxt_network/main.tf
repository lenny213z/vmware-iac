
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
  tag {
    scope = var.tag_scope
    tag   = var.nsxt_segment["name"]
  }
}

# All Virtual machines with specific tag and scope
resource "nsxt_policy_group" "nsxt_group" {
  display_name = var.nsxt_segment["name"]
  description  = "Autogenerate Group for VMs with the defined tag"
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator    = "CONTAINS"
      key         = "Tag"
      value       = var.nsxt_segment["name"]

    }
  }
  tag {
    scope = var.nsxt_tag_scope
    tag   = var.nsxt_tag
  }
}
