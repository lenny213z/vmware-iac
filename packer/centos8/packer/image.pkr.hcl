# Builder configuration, responsible for VM provisioning.

locals {
    vsphere_user = vault("/secret/data/personal-keys/ribarski/nsxtpoc/vcuser", "personal-keys/ribarski/nsxtpoc/vcuser")
    vsphere_password = vault("/secret/data/personal-keys/ribarski/nsxtpoc/vcsecret", "personal-keys/ribarski/nsxtpoc/vcsecret")
    vsphere_server = vault("/secret/data/personal-keys/ribarski/nsxtpoc/vcsrv", "personal-keys/ribarski/nsxtpoc/vcsrv")
}

source "vsphere-iso" "centos" {

  # vCenter parameters
  insecure_connection   = "true"
  username              = "${local.vsphere_user}"
  password              = "${local.vsphere_password}"
  vcenter_server        = "${local.vsphere_server}"
  cluster               = "${var.vsphere_compute_cluster}"
  datacenter            = "${var.vsphere_dc_name}"
  host                  = "${var.vsphere_host}"
  datastore             = "${var.vsphere_datastore}"
  folder                = "${var.vsphere_folder}"
  vm_name               = "${var.vsphere_template_name}"
  convert_to_template   = true

  # VM resource parameters 
  guest_os_type         = "${var.guest_os_type}"
  CPUs                  = "${var.cpu_num}"
  CPU_hot_plug          = true
  RAM                   = "${var.mem_size}"
  RAM_hot_plug          = true
  RAM_reserve_all       = false
  
  network_adapters {
      network           = "${var.vsphere_portgroup_name}"
      network_card      = "vmxnet3"
  }

  disk_controller_type  = ["pvscsi"]
  storage {
      disk_thin_provisioned = "true"
      disk_size             = var.disk_size
  }

  iso_paths = [
    "${var.os_iso_path}"
  ]

  # CentOS OS parameters
  boot_order            = "disk,cdrom,floppy"
  boot_wait             = "10s"
  ssh_password          = "${var.ssh_password}"
  ssh_username          = "${var.ssh_username}"

  http_ip = "${var.builder_ipv4}"
  http_directory    = "scripts"
  boot_command      = [
    "<up><wait><tab><wait> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"
  ]
}
