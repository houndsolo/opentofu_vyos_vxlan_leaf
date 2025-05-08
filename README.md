# OpenTofu VXLAN Homelab

A sophisticated network automation project using OpenTofu 1.9 to deploy a VXLAN network in a homelab environment, combining physical and virtual devices.

## 🌟 Features


## 🏗️ Architecture

### Hardware Components
- **Spine Layer**
  - 2 x Cisco Catalyst 9300 switches
  - Running IOS-XE 17.16.01

- **Leaf Layer**
  - 2 x Cisco Catalyst 9300 switches
  - 7 x Virtual VyOS routers (on Proxmox)
  - Running VyOS 1.5-rolling-202402060022


### Addressing Scheme
- **Underlay Network**
  - Point-to-point links: `10.240.[leaf][spine].0/31`
  - OSPF for routing

- **Overlay Network**
  - iBGP Loopback interfaces: `10.240.[254-255].[id]`
  - MSDP peering: `10.240.253.[id]`

## 📁 Project Structure

```
├── proxmox_vteps
│   ├── vars.tf
│   ├── versions.tf
│   └── create_vms.tf
├── vyos_vteps
│   ├── versions.tf
│   ├── vyos_bgp.tf
│   ├── vyos_init.tf
│   └── vyos_vxlan.tf
├── README.md
├── debug.log
├── main.tf
├── passwords.tf
├── providers.tf
├── vars.tf
├── versions.tf

```

## 🚀 Getting Started

### Prerequisites
- OpenTofu 1.9 or later
- VyOS 1.5-rolling-202402060022
- Proxmox VE for virtual routers

