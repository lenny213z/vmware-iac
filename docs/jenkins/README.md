# Jenkins Setup 

**Steps that I have taken to configure Jenkins Srv.**

- used from vmware template
- local user added with sudo rights
- installed packages
    - development tools
    - python39
    - terraform
    - ansible
    - packer
    - chef-workstation
- jenkins installed based on https://www.jenkins.io/doc/book/installing/linux/#red-hat-centos
- jenkins setup admin for different user
- enabled plugins (on top of defaults)
    - hashicorp vault
    - hashicorp vault pipeline
- configured a global vault for akeyless

