variable "pve_endpoint" {
  type = string
}

variable "pve_token" {
  type      = string
  sensitive = true
}

variable "pve_node" {
  type = string
}

variable "template_vm_id" {
  type = number
}

variable "storage" {
  type    = string
  default = "local-lvm"
}

variable "vms" {
  type = map(object({
    ip     = string
    cores  = number
    memory = number
    disk   = number
  }))
}

variable "gateway" {
  type = string
}

variable "ssh_public_key" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}