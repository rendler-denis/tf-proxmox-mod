# Terraform/OpenTofu module to manage Proxmox Virtual Environment 7 and above

This module will create an LXC container based on the template mentioned.

- [x] create container
- [x] configure container
- [x] install ssh for SSH access

NOTE: unfortunately it seems that OpenTofu registry does not have the required
provider and thus it cannot install it. Either use Terraform or install the provide
manually.

## Requirements

The module uses the `MaartendeKruijf/proxmox` which at the time of last update it was the only
provider supporting Proxmox 8.

## Usage

```hcl
module "pve_lxc" {
  source = "github.com/rendler-denis/tf-proxmox-mod//lxc"

  for_each = var.lxc

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
  hagroup      = each.value.hagroup
  hastate      = each.value.hastate

  proxmox_ssh = var.proxmox_ssh
}
```

For further examples check the `example/` folder.

## LICENSE

Check the LICENSE.md
