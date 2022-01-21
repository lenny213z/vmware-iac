output "name" {
  value = {
    for key, name in module.segment : key => name.name
  }
}

output "group" {
  value = {
    for group_key, group in module.segment : group_key => group.group
  }
}

output "t1_path" {
  value = nsxt_policy_tier1_gateway.t1_gw.path
}

output "vm_category" {
  value = vsphere_tag_category.category.id
}