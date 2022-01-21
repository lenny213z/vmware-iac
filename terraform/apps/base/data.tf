#
data "nsxt_policy_edge_cluster" "edge_cluster" {
  display_name = "psc-nsx-edgecl01"
}

data "nsxt_policy_tier0_gateway" "t0_gw" {
  display_name = "psc-nsx-t0-gw"
}

data "nsxt_policy_dhcp_server" "dhcp" {
  display_name = "global-nsx-dhcp-service"
}
#
data "akeyless_secret" "vcsrv" {
    path        = "/personal-keys/ribarski/nsxtpoc/vcsrv"
}

data "akeyless_secret" "vcuser" {
    path        = "/personal-keys/ribarski/nsxtpoc/vcuser"
}

data "akeyless_secret" "vcsecret" {
    path        = "/personal-keys/ribarski/nsxtpoc/vcsecret"
}

data "akeyless_secret" "nsxtsrv" {
    path        = "/personal-keys/ribarski/nsxtpoc/nsxtsrv"
}

data "akeyless_secret" "nsxtuser" {
    path        = "/personal-keys/ribarski/nsxtpoc/nsxtuser"
}

data "akeyless_secret" "nsxtsecret" {
    path        = "/personal-keys/ribarski/nsxtpoc/nsxtsecret"
}
#