resource "proxmox_virtual_environment_vm" "vyos_vxlan_vtep" {
  name        = var.host_node.hostname
  description = "managed by opentofu"
  tags        = ["opentofu", "debian", "vyos", "vxlan"]
  started = true
  keyboard_layout         = "en-us"
  migrate                 = false
  on_boot                 = true
  reboot                  = false
  stop_on_destroy         = true


  node_name = "${var.host_node.host_node}"
  vm_id     = local.vm_id

  agent {
    enabled = true
  }

  boot_order = [
    "virtio0",
  ]

  disk {
    datastore_id = "ceph_rbd"
    #file_format  = "raw"
    interface    = "virtio0"
    iothread    = true
    size         = 7
  }
  clone {
    node_name = "venom"
    vm_id = 917099
    full = false
    retries = 3
  }
  #  efi_disk{
  #    datastore_id = "ceph-rep-min-1"
  #    type = "2m"
  #    pre_enrolled_keys = false
  #    file_format = "raw"
  #  }

  initialization {
    interface = "scsi0"
    user_data_file_id = "vmbackups:snippets/vyos_api.yml"
    datastore_id = "ceph_rbd"
    #dns {
    #  domain = "lylat.space"
    #  servers = [
    #    "10.8.6.9",
    #  ]
    #}
    ip_config {
      ipv4 {
        address = local.vxlan_mgmt_ip_sub
      }
    }
  }

  network_device {
    disconnected = false
    bridge = "vmbr1"
    model = "virtio"
    vlan_id = "20"
  }

dynamic "network_device" {
  for_each = [for i in range(var.spines) : i]  # Use index directly
  content {
    disconnected = false
    bridge       = "vmbr${tostring(4001 + network_device.value)}"  # Start at 4001
    model        = "virtio"
    mtu          = 1
  }
}

  network_device {
    disconnected = false
    bridge = "vmbr4000"
    model = "virtio"
    mtu   = 1
  }
  network_device {
    disconnected = true
    bridge = "vmbr4000"
    model = "virtio"
  }

  serial_device {}

  cpu {
    #  architecture = "x86_64"
    cores        = 4
    flags        = []
    hotplugged   = 0
    limit        = 0
    numa         = false
    sockets      = 1
    type         = "x86-64-v2-AES"
    units        = 1024
  }

  memory {
    dedicated      = 4096
    floating       = 0
    keep_hugepages = false
    shared         = 0
  }

  operating_system {
    type = "l26"
  }

  vga {
    #enabled = false
    memory  = 16
    type    = "std"
  }
  timeout_clone           = 1800
  timeout_create          = 1800
  timeout_migrate         = 1800
  timeout_reboot          = 1800
  timeout_shutdown_vm     = 1800
  timeout_start_vm        = 1800
  timeout_stop_vm         = 300


  lifecycle {
    ignore_changes = [
      #network_device[6].disconnected,
      initialization[0].user_account,  # This ignores changes to the user_account block within initialization
      #vga[0].enabled,  # This ignores changes to the user_account block within initialization
    ]
  }
}
