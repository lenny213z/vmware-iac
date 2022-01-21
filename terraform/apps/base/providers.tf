terraform {
  required_providers {
    nsxt = {
      source = "vmware/nsxt"
    }
    akeyless = {
      source = "akeyless-community/akeyless"
    }
  }
}

provider "nsxt" {
  host                  = "${data.akeyless_secret.nsxtsrv.value}"
  username              = "${data.akeyless_secret.nsxtuser.value}"
  password              = "${data.akeyless_secret.nsxtsecret.value}"
  # If you have a self-signed cert
  allow_unverified_ssl  = true
  max_retries           = 10
  retry_min_delay       = 500
  retry_max_delay       = 5000
  retry_on_status_codes = [429]
}

provider "vsphere" {
  vsphere_server = "${data.akeyless_secret.vcsrv.value}"
  user           = "${data.akeyless_secret.vcuser.value}"
  password       = "${data.akeyless_secret.vcsecret.value}"
  # If you have a self-signed cert
  allow_unverified_ssl = true
}

provider "akeyless" {
  api_gateway_address = "https://api.akeyless.io"
    api_key_login {
      access_id  = "${var.AKEYLESS_ACCESS_ID}"
      access_key = "${var.AKEYLESS_ACCESS_KEY}"
  }
}