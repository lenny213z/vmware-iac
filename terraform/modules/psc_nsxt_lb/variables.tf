variable "connectivity_path" {
  type        = string
  description = "Selects the Tier GW to connect to"
  default     = ""
}

variable "lb" {
  type = map(any)
  default = {
    name        = ""
    size        = ""
    description = ""
  }
}

variable "vip" {
  type = map(any)
  default = {
    name        = ""
    description = ""
    ipaddrv4    = ""
  }
}

variable "vip_ports" {
  type    = list(string)
  default = ["80", "443"]
}

variable "pool" {
  type = map(any)
  default = {
    name        = ""
    description = ""
    algorithm   = ""
  }
}

variable "members_group" {
  type        = string
  default     = ""
  description = "The NSXT Group that includes the VMs for Pool Members"
}

variable "tag_scope" {
  type    = string
  default = ""
}

variable "tag" {
  type    = string
  default = ""
}

variable "nsxt_tag_scope" {
  type    = string
  default = "project"
}

variable "nsxt_tag" {
  type    = string
  default = "terraform"
}