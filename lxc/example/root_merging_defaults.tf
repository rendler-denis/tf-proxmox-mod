# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2025-2030 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-proxmox-mod
# License: Check the LICENSE file or the repository for the license of the module.

module "pve_lxc" {
  source = "github.com/rendler-denis/tf-proxmox-mod//lxc?ref=1.0.0"

  for_each = { for name, config in var.lxc : name => merge(local.default_lxc, config) }

  ct_name      = each.key
  target       = each.value.target
  template     = each.value.template
  privileged   = each.value.privileged
  onboot       = each.value.onboot
  protected    = each.value.protected
  cpu_cores    = each.value.cpu_cores
  memory       = each.value.memory
  swap         = each.value.swap
  vmid         = each.value.vmid
  state        = each.value.state
  ssh_keys     = each.value.ssh_keys
  root_pass    = each.value.root_pass
  tags         = each.value.tags
  hdd_size     = each.value.hdd_size
  storage_name = each.value.storage_name
  net          = each.value.net

  proxmox_ssh = var.proxmox_ssh
}

locals {
  default_lxc = {
    storage_name = "local-zfs",
    template     = "local:vztmpl/rockylinux-9-default_20221109_amd64.tar.xz",
    onboot     = true,
    privileged = false,
    protected  = false,
    root_pass  = "admin123",
    state      = true,
    target     = "pvey"
    ssh_keys   = null,
    tags       = "linux,rockylinux,9"
  }
}
