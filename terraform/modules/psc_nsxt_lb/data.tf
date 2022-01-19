
data "nsxt_policy_lb_app_profile" "tcp" {
  type         = "TCP"
  display_name = "default-tcp-lb-app-profile"
}