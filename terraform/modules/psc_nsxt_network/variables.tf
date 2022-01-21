variable "nsx_t1gw" {
  type = map(any)
  default = {
    name        = ""
    description = ""
  }
}

variable "nsxt_tag_scope" {
  type    = string
  default = "project"
}

variable "nsxt_tag" {
  type    = string
  default = "terraform"
}

variable "tag_scope" {
  type    = string
  default = ""
}

variable "tag" {
  type    = string
  default = ""
}

variable "nsxt_segment" {
  type = map(any)
  default = {
    name        = ""
    description = ""
    cidr        = ""
    dhcp_ranges = ""
  }
}

variable "dns_servers" {
  type    = list(string)
  default = ["10.128.10.201", "10.128.10.202"]
}

variable "connectivity_path" {
  type        = string
  description = "Selects the Tier GW to connect to"
  default     = ""
}