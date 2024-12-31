# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2025-2030 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-proxmox-mod
# License: Check the LICENSE file or the repository for the license of the module.

// full config example
lxc = {
  "example-lxc" : {
    cpu_cores    = 2,
    storage_name = "local-zfs",
    template     = "local:vztmpl/rockylinux-9-default_20221109_amd64.tar.xz",
    hdd_size     = "20G",
    memory       = 2048,
    net = {
      device  = "eth0",
      macaddr = "aa:01:d2:50:51:03",
      name    = "vmbr1",
      tag     = 0
      gateway = "10.0.0.1"
      ip      = "10.0.0.39/16"
    },
    onboot     = true,
    privileged = false,
    root_pass  = "admin123",
    state      = true,
    swap       = 1024,
    target     = "pve",
    vmid       = 12345
  }
}

// example of partial config
// to be merged with defaults

lxc = {
  "partial-example-lxc" : {
    cpu_cores    = 2,
    hdd_size     = "20G",
    memory       = 2048,
    net = {
      device  = "eth0",
      macaddr = "aa:01:d2:50:51:03",
      name    = "vmbr1",
      tag     = 50
      gateway = "10.0.0.1"
      ip      = "10.0.0.39/16"
    },
    vmid       = 12345
    swap       = 512
  }
}

proxmox_ssh = "root@pve.example.com"