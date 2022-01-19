#!/bin/bash
set -e

# Setup sudo to allow no-password sudo for "wheel" group and adding "ansible" user
useradd -m -s /bin/bash ansible
usermod -a -G wheel ansible
cp /etc/sudoers /etc/sudoers.orig
echo "Defaults:ansible "'!'"requiretty" | sudo tee /etc/sudoers.d/ansible
echo "%wheel ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/ansible

# Installing SSH key
mkdir -p /home/ansible/.ssh
chmod 700 /home/ansible/.ssh
cp /tmp/ansible.pub /home/ansible/.ssh/authorized_keys
chmod 600 /home/ansible/.ssh/authorized_keys
chown -R ansible /home/ansible/.ssh
usermod --shell /bin/bash ansible

# Disable Password Login and Root Login
sed -i "/^[^#]*PasswordAuthentication[[:space:]]yes/c\PasswordAuthentication no" /etc/ssh/sshd_config
sed -i "/^[^#]*PermitRootLogin[[:space:]]yes/c\PermitRootLogin no" /etc/ssh/sshd_config
