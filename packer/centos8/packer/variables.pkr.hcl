# Delcared variables. 

variable "vsphere_template_name" {
  type    = string
}

variable "vsphere_folder" {
  type    = string
}

variable "cpu_num" {
  type    = number
}

variable "disk_size" {
  type    = number
}

variable "mem_size" {
  type    = number
}

variable "ssh_username" {
  type    = string
  default = "root"
}

variable "ssh_password" {
  type    = string
}

variable "ssh_key" {
  type    = string
}

variable "guest_os_type" {
  type    = string
}

variable "vsphere_dc_name" {
  type    = string
}

variable "vsphere_compute_cluster" {
  type    = string
}

variable "vsphere_host" {
  type    = string
}

variable "vsphere_datastore" {
  type    = string
}

variable "vsphere_portgroup_name" {
  type    = string
}

variable "os_iso_path" {
  type    = string
}

variable "builder_ipv4"{
  type = string
  description = "This variable is used to manually assign the IPv4 address to serve the HTTP directory. Use this to override Packer if it utilising the wrong interface."
  default = "${env("PACKER_HTTP_BUILDER_IPV4")}"
}
