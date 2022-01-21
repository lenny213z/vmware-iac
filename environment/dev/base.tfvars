#
nsx_t1gw = {
  name        = "t1_gw"
  description = "T1 Router"
}
#
nsxt_segment = [
  {
    name        = "Web"
    description = "Web Segment"
    cidr        = "10.65.52.1/25"
    dhcp_ranges = "10.65.52.10-10.65.52.120"
  },
  {
    name        = "DB"
    description = "DB Segment"
    cidr        = "10.65.52.129/25"
    dhcp_ranges = "10.65.52.140-10.65.52.220"
  }

]
#