# Provisioner configuration runs after the main source builder.

build {
  sources = ["source.vsphere-iso.centos"]

  provisioner "file" {
    source      = "${var.ssh_key}"    
    destination = "/tmp/ansible.pub"  
  }

  # Upload and execute scripts using Shell
  provisioner "shell" {
    execute_command = "echo '${var.ssh_password}' | {{.Vars}} sudo -S -E sh -eux '{{.Path}}'" # This runs the scripts with sudo
    scripts = [
        "./scripts/setup.sh",
        "./scripts/cleanup.sh"
    ]
  }
}
