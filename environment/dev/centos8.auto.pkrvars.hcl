# Assign values to override their default values (default values are found in the vsphere_centos8.pkr.hcl file).
# All values are automatically used and persist through the entire Packer process.

ssh_username = "root"
ssh_password = "secure_Enough4me"
ssh_key      = "../../secrets/ssh-keys/ansible.pub"

vsphere_template_name = "centos8_packer_template"
vsphere_folder        = "templates"

cpu_num                 = 2
mem_size                = 8192
disk_size               = 32000
guest_os_type           = "centos7_64Guest"
vsphere_dc_name         = "TP-CorpIT"
vsphere_compute_cluster = "Marlboro (TierPoint)"
vsphere_host            = "vsmarhost14.bedford.progress.com"
vsphere_datastore       = "MAR-N1-DS02"
vsphere_portgroup_name  = "Virtual Machine Network"

os_iso_path = "[MAR-N1-DS02] _iso/CentOS-Stream-8-x86_64-latest-dvd1.iso"

# Needed if you have more than one interface on the packer src endpoint
#builder_ipv4 = "10.248.64.57"