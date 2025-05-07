terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.77.1"
    }
    vyos = {
      source = "registry.terraform.io/thomasfinstad/vyos-rolling"
      version = "20.0.202502190"
    }
  }
}
