#
variable "AKEYLESS_ACCESS_ID" {
  type = string
  description = "Define Environment Variable TF_VAR_AKEYLESS_ID"
  default = ""
}

variable "AKEYLESS_ACCESS_KEY" {
  type = string
  description = "Define Local Environment Variable TF_VAR_AKEYLESS_KEY"
  default = ""
}

variable "nsxt_segment" {
  type = list(object({
    name        = string
    description = string
    cidr        = string
    dhcp_ranges = string
  }))
}

variable "nsx_t1gw" {
  type = map(any)
  default = {
    name = ""
    description = ""
  }  
}
