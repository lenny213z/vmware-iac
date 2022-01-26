#
nsx_t1gw = {
  name        = "t1_gw"
  description = "T1 Router"
}
#
nsxt_segment = [
  {
    name        = "default"
    description = "Default Segment"
    cidr        = "10.65.53.1/24"
    dhcp_ranges = "10.65.53.20-10.65.53.220"
  }
]
#