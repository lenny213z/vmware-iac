output "name" {
  value = {
    for key, name in module.segment : key => name.name
  }
}

output "t1_path" {
  value = nsxt_policy_tier1_gateway.t1_gw.path
}
