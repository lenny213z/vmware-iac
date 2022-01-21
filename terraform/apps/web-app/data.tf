data "akeyless_secret" "vcsrv" {
  path = "/personal-keys/ribarski/nsxtpoc/vcsrv"
}

data "akeyless_secret" "vcuser" {
  path = "/personal-keys/ribarski/nsxtpoc/vcuser"
}

data "akeyless_secret" "vcsecret" {
  path = "/personal-keys/ribarski/nsxtpoc/vcsecret"
}

data "akeyless_secret" "nsxtsrv" {
  path = "/personal-keys/ribarski/nsxtpoc/nsxtsrv"
}

data "akeyless_secret" "nsxtuser" {
  path = "/personal-keys/ribarski/nsxtpoc/nsxtuser"
}

data "akeyless_secret" "nsxtsecret" {
  path = "/personal-keys/ribarski/nsxtpoc/nsxtsecret"
}

data "vsphere_datacenter" "datacenter" {
  name = "TP-CorpIT"
}

data "vsphere_network" "segment" {
  name          = data.terraform_remote_state.base.outputs.name["Web"][0]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}