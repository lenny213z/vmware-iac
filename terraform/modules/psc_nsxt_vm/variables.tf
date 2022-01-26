
variable "tag" {
  type    = string
  default = ""
}

variable "network_id" {
  type = string
}

variable "vm_count" {
  type    = string
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
  type    = string
  default = "project"
}

variable "nsxt_tag" {
  type    = string
  default = "terraform"
}
