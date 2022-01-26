#
output "segment" {
  value = nsxt_policy_segment.segment.*.path
}

output "name" {
  value = nsxt_policy_segment.segment.*.display_name
}