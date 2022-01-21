#
output "segment" {
    value = nsxt_policy_segment.segment.*.path
}

output "group" {
    value = nsxt_policy_group.nsxt_group.*.path
}

output "name" {
    value = nsxt_policy_segment.segment.*.display_name
}