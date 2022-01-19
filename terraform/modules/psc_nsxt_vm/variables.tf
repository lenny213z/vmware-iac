
variable "nsxt_segment" {
  type = map(any)
  default = {
    name = ""
    description = ""
    cidr = ""
    dhcp_ranges = ""
  }
}

variable "tag_scope" {
  type = string
  default = ""
}

variable "tag" {
  type = string
  default = ""
}

variable "connectivity_path" {
  type = string
  description = "Selects the Tier GW to connect to"
  default = ""
}

variable "depends" {
  type = list(string)
  description = "Define dependancies if needed"
  default = []
}

variable "dns_servers" {
  type = list(string)
  default = ["10.128.10.201","10.128.10.202"]
}

variable "nsxt_group" {
  type = map(any)
  default = {
    name = ""
    description = ""
  }
}

variable "vm_count" {
  type = string
  default = "1"
}

variable "vm_name" {
  type = string
}

variable "dc" {
  type = string
}

variable "datastore" {
  type = string
}

variable "cluster" {
  type = string
}

variable "vm_template" {
  type = string
}

variable "nsxt_tag_scope" {
  type = string
  default = "project"
}

variable "nsxt_tag" {
  type = string
  default = "terraform"
}
