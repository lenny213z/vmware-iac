
data "nsxt_policy_transport_zone" "overlay_tz" {
  display_name = "nsx-overlay-transportzone"
}

data "nsxt_policy_security_policy" "default_l3" {
  is_default = true
  category   = "Application"
}