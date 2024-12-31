# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2025-2030 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-proxmox-mod
# License: Check the LICENSE file or the repository for the license of the module.

variable "target" {
  type        = string
  description = "Target node where to place the container"
  default     = "pve"
  nullable    = false
}

variable "ct_name" {
  type        = string
  description = "Container host name"
  default     = "no-name"
  nullable    = false
}

variable "template" {
  type        = string
  description = "The template/image to be used for the container"
  default     = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  nullable    = false
}

variable "privileged" {
  type        = bool
  description = "Boolean to make the container run as priviledged or not "
  default     = false
  nullable    = false
}

variable "onboot" {
  type        = bool
  description = "A boolean that determines if the container will start on boot. Default is false"
  default     = false
  nullable    = false
}

variable "protected" {
  type        = bool
  description = "A boolean that enables the protection flag on this container. Stops the container and its disk from being removed/updated. Default is false."
  default     = false
  nullable    = false
}

variable "cpu_cores" {
  type        = number
  description = "A number to limit CPU usage by. Default is 1."
  default     = 1
  nullable    = false
}

variable "memory" {
  type        = number
  description = "A number containing the amount of RAM to assign to the container (in MB). Default 512"
  default     = 512
  nullable    = false
}

variable "swap" {
  type        = number
  description = "A number that sets the amount of swap memory available to the container. Default is 512"
  default     = 512
  nullable    = false
}

variable "vmid" {
  type        = number
  description = "An integer to be used as ID for the container (1 - 999999999) (0 = next ID available)"
  default     = 0
  nullable    = false
}

variable "state" {
  type        = bool
  description = "The state of the container after creation. True or false"
  default     = true
  nullable    = false
}

variable "ssh_keys" {
  type        = string
  description = "The SSH keys to be deployed to the container"
  default     = ""
  nullable    = false
}

variable "root_pass" {
  type        = string
  sensitive   = true
  description = "The root password of the container"
  nullable    = false
}

variable "tags" {
  type     = string
  default  = ""
  nullable = false
}

variable "hdd_size" {
  type        = string
  description = "The size of the volume to be created and attached to the container"
  nullable    = false
}

variable "net" {
  type = object({
    device  = string
    name    = string
    tag     = number
    macaddr = string
    ip      = string
    gateway = string
  })
  description = "The network configuration for the container"
  default = {
    device  = "eth0"
    name    = "vmbr1"
    tag     = 0
    macaddr = null
    ip      = "dhcp"
    gateway = null
  }
  nullable = false
}

variable "storage_name" {
  type        = string
  description = "The storage name to be used"
  default     = "local-lvm"
  nullable    = false
}

variable "proxmox_ssh" {
  type        = string
  description = "SSH connection string for Proxmox host (e.g., user@proxmox-host)"
}