# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2025-2030 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-proxmox-mod
# License: Check the LICENSE file or the repository for the license of the module.

terraform {
  required_version = ">= 0.0.1"

  required_providers {
    proxmox = {
      source = "MaartendeKruijf/proxmox"
      version = "0.0.1"
    }
    local-exec = {
      source = "hashicorp/local"
      version = ">= 2.5"
    }
    null = {
      source = "hashicorp/null"
      version = ">= 3.2"
    }
  }
}

# Create a Proxmox LXC container
resource "proxmox_lxc" "pve_lxc" {
  target_node  = var.target
  hostname     = var.ct_name
  ostemplate   = var.template
  unprivileged = !var.privileged
  onboot       = var.onboot
  protection   = var.protected

  cores  = var.cpu_cores
  memory = var.memory
  swap   = var.swap
  vmid   = var.vmid
  start  = var.state

  hagroup = var.hagroup
  hastate = var.hastate

  ssh_public_keys = var.ssh_keys
  password        = var.root_pass

  tags = var.tags

  features {
    nesting = true
    keyctl  = true

    # these 2 options are only available when logging
    # with root creds, not token
    # fuse    = true
    # mount   = "nfs;cifs"
  }

  // Terraform will crash without rootfs defined
  rootfs {
    storage = var.storage_name
    size    = var.hdd_size
  }

  network {
    name   = var.net.device
    bridge = var.net.name
    hwaddr = var.net.macaddr
    ip     = var.net.ip
    ip6    = "dhcp"
    tag    = var.net.tag
    gw     = var.net.ip != "dhcp" ? var.net.gateway : null
  }

  lifecycle {
    ignore_changes = [
     tags,
     ssh_public_keys,
     password,
     target_node,
    ]
  }
}

// This is required as most LXC templates do not have SSH installed
// and we need to install it to be able to run Ansible for further configuration
resource "null_resource" "install_ssh" {
  count      = var.install_ssh ? 1 : 0
  depends_on = [proxmox_lxc.pve_lxc]

  provisioner "local-exec" {
    command = <<-EOT
      # Wait for container to be up
      sleep 10

      # Detect OS type
      OS_TYPE=$(ssh ${var.proxmox_ssh} \
        "pct exec ${proxmox_lxc.pve_lxc.vmid} -- test -f /etc/debian_version && echo 'debian' || echo 'redhat'")

      if [ "$OS_TYPE" == "debian" ]; then
        ssh ${var.proxmox_ssh} \
          "pct exec ${proxmox_lxc.pve_lxc.vmid} -- /bin/bash -c '\
            apt-get update && \
            DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server && \
            systemctl enable ssh && \
            systemctl start ssh \
          '"
      else
        ssh ${var.proxmox_ssh} \
          "pct exec ${proxmox_lxc.pve_lxc.vmid} -- /bin/bash -c '\
            dnf install -y openssh-server && \
            systemctl enable sshd && \
            systemctl start sshd \
          '"
      fi
    EOT
  }

  triggers = {
    container_id = proxmox_lxc.pve_lxc.vmid
  }
}
