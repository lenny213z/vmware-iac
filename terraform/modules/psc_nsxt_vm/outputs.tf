
output "vm_ip_addr" {
  value = vsphere_virtual_machine.vm.*.default_ip_address
}

output "group" {
  value = nsxt_policy_group.nsxt_group.path
}