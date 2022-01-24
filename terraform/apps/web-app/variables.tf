variable "vm" {
  type = map(any)
  default = {
    "name"  = ""
    "count" = ""
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

variable "vm_template" {
  type = string
}

variable "AKEYLESS_ACCESS_ID" {
  type        = string
  description = "Define Environment Variable TF_VAR_AKEYLESS_ID"
  default     = ""
}

variable "AKEYLESS_ACCESS_KEY" {
  type        = string
  description = "Define Local Environment Variable TF_VAR_AKEYLESS_KEY"
  default     = ""
}