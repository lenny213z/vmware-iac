

variable "dfw" {
  type = map(any)
  default = {
    name        = ""
    description = ""
  }
}

variable "microsegmentation" {
  type    = bool
  default = true
}

variable "nsxt_group" {
  type    = list(string)
  default = ["any"]
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

variable "rules" {
  type = list(object({
    name     = string
    action   = string
    src      = list(string)
    dst      = list(string)
    services = list(string)
  }))
  default = [{
    name     = ""
    action   = "DROP"
    src      = ["any"]
    dst      = ["any"]
    services = ["any"]
  }]
}
