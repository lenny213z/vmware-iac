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