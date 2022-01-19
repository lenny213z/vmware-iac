variable "vm_name" {
  type = string
}

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