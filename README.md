# OpenTofu VXLAN Homelab

A sophisticated network automation project using OpenTofu 1.9 to deploy a VXLAN network in a homelab environment, combining physical and virtual devices.

## 🌟 Features

- **Modern Data Center Architecture**
  - Spine-Leaf topology
  - VXLAN overlay with BGP-EVPN control plane
  - Multicast underlay for BUM traffic
  - Anycast RP for multicast redundancy

- **Hybrid Infrastructure**
  - Physical Cisco Catalyst 9300 switches
  - Virtual VyOS routers on Proxmox
  - Automated provisioning and configuration

- **Advanced Networking**
  - Jumbo frame support (MTU 9169 outer, 9119 inner)
  - OSPF underlay for optimal routing
  - iBGP-EVPN overlay for VXLAN control plane
  - Head-end replication for BUM traffic

## 🏗️ Architecture

### Hardware Components
- **Spine Layer**
  - 2 x Cisco Catalyst 9300 switches
  - Running IOS-XE 17.16.01

- **Leaf Layer**
  - 2 x Cisco Catalyst 9300 switches
  - 6 x Virtual VyOS routers (on Proxmox)
  - Running VyOS 1.5-rolling-202402060022

### Network Design
```
+----------------+     +----------------+
|  Cisco Spine 1 |-----|  Cisco Spine 2 |
+----------------+     +----------------+
        |                     |
        |                     |
+----------------+     +----------------+
|  Cisco Leaf 1  |     |  Cisco Leaf 2  |
+----------------+     +----------------+
        |                     |
        |                     |
+----------------+     +----------------+
|  VyOS Leaf 1   |     |  VyOS Leaf 2   |
+----------------+     +----------------+
```

### Addressing Scheme
- **Underlay Network**
  - Point-to-point links: `10.240.[leaf][spine].0/31`
  - OSPF for routing

- **Overlay Network**
  - Loopback interfaces: `10.240.[254-255].[id]/32`
  - iBGP-EVPN for control plane

## 📁 Project Structure

```
.
├── c9300_leaf_*          # Cisco leaf switch configurations
│   ├── init/            # Initial configuration
│   ├── underlay/        # OSPF underlay
│   ├── bgp/            # BGP configuration
│   └── vxlan/          # VXLAN configuration
├── c9300_spine_*        # Cisco spine switch configurations
│   ├── init/           # Initial configuration
│   ├── underlay/       # OSPF underlay
│   └── bgp/            # BGP configuration
├── vyos_*              # VyOS router configurations
│   ├── init/           # Initial configuration
│   ├── bgp/            # BGP configuration
│   └── vxlan/          # VXLAN configuration
├── multicast_underlay/  # PIM multicast configuration
├── vteps/              # VXLAN Tunnel Endpoints
├── main.tf             # Main configuration
├── vars.tf             # Variable definitions
├── providers.tf        # Provider configurations
└── versions.tf         # Version constraints
```

## 🚀 Getting Started

### Prerequisites
- OpenTofu 1.9 or later
- Cisco IOS-XE 17.16.01 (minimum 17.15)
- VyOS 1.5-rolling-202402060022
- Proxmox VE for virtual routers

### Installation
1. Clone the repository
2. Initialize OpenTofu:
   ```bash
   tofu init
   ```
3. Review and modify variables in `vars.tf`
4. Apply the configuration:
   ```bash
   tofu apply
   ```

### Configuration
The project uses several key configuration files:

- **vars.tf**: Define your network parameters
- **providers.tf**: Configure device connections
- **main.tf**: Main deployment configuration

## 🔧 Modules

### Cisco Switch Modules
- **c9300_leaf_init**: Initial switch configuration
- **c9300_leaf_underlay**: OSPF underlay setup
- **c9300_leaf_bgp**: BGP-EVPN configuration
- **c9300_leaf_vxlan**: VXLAN configuration

### VyOS Modules
- **vyos_init**: Initial router setup
- **vyos_bgp**: BGP-EVPN configuration
- **vyos_vxlan**: VXLAN configuration

### Multicast Module
- **multicast_underlay**: PIM configuration for both Cisco and VyOS

## 🔍 Validation and Testing

### Pre-deployment Checks
- Verify device connectivity
- Check software versions
- Validate IP addressing

### Post-deployment Verification
- Verify BGP adjacencies
- Check VXLAN tunnel status
- Validate multicast routing
- Test end-to-end connectivity

## 📝 Notes

- Jumbo frames are required for optimal performance
- Multicast is used for BUM traffic handling
- Anycast RP provides redundancy for multicast
- Head-end replication is used for VXLAN BUM traffic

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Cisco for IOS-XE
- VyOS team for their open-source router
- OpenTofu community
