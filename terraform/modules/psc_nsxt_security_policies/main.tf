
# In this section, we have example to create Firewall sections and rules
# All rules in this section will be applied to VMs that are part of the
# Gropus we created earlier
#
resource "nsxt_policy_security_policy" "firewall_section" {
  display_name = var.dfw["name"]
  description  = var.dfw["description"]
  category     = "Application"
  locked       = "false"
  stateful     = "true"
  tag {
    scope = var.nsxt_tag_scope
    tag   = var.nsxt_tag
  }
  tag {
    scope = var.tag_scope
    tag   = var.tag
  }

  dynamic "rule" {
    for_each = var.rules
    content {
      display_name       = rule.value.name
      action             = rule.value.action
      source_groups      = rule.value.src
      destination_groups = rule.value.dst
    }
  }
  # Allow all other communications 
  rule {
    display_name = "External"
    description  = "Allow all traffic to and from external networks"
    action       = "ALLOW"
    logged       = "false"
  }
}