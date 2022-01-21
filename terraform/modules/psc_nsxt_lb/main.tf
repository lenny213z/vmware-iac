# This Resources create and configure a Load Balancer Service in NSXT
resource "nsxt_policy_lb_service" "lb" {
  display_name      = "${var.lb["name"]}}"
  description       = var.lb["description"]
  size              = var.lb["size"]
  error_log_level   = "ERROR"
  enabled           = true
  connectivity_path = var.connectivity_path

  tag {
    scope = var.tag_scope
    tag   = var.tag
  }
  tag {
    scope = var.nsxt_tag_scope
    tag   = var.nsxt_tag
  }
}
# This Resource creates and configures a LB server pool if needed
resource "nsxt_policy_lb_pool" "pool" {
  display_name        = var.pool["name"]
  description         = var.pool["description"]
  algorithm           = var.pool["algorithm"]
  min_active_members  = 1
  active_monitor_path = "/infra/lb-monitor-profiles/default-icmp-lb-monitor"
  member_group {
    group_path = var.members_group
  }
  snat {
    type = "AUTOMAP"
  }

  tag {
    scope = var.tag_scope
    tag   = var.tag
  }
  tag {
    scope = var.nsxt_tag_scope
    tag   = var.nsxt_tag
  }
}
#This Resource creates and configures a VIP for the LB if needed
resource "nsxt_policy_lb_virtual_server" "vip" {
  display_name             = var.vip["name"]
  description              = var.vip["description"]
  access_log_enabled       = true
  application_profile_path = data.nsxt_policy_lb_app_profile.tcp.path
  enabled                  = true
  ip_address               = var.vip["ipaddrv4"]
  ports                    = var.vip_ports
  service_path             = nsxt_policy_lb_service.lb.path
  pool_path                = nsxt_policy_lb_pool.pool.path

  tag {
    scope = var.tag_scope
    tag   = var.tag
  }
  tag {
    scope = var.nsxt_tag_scope
    tag   = var.nsxt_tag
  }
}
