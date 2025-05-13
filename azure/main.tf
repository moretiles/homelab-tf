resource "random_pet" "prefix" {
  prefix = var.resource_group_name_prefix
  length = 1
}

# Resource Group
resource "azurerm_resource_group" "homelab" {
  location = var.resource_group_location
  name = "${random_pet.prefix.id}-rg"
}

# Virtual Network
resource "azurerm_virtual_network" "big_net" {
  name = "${random_pet.prefix.id}-vnet"
  address_space = [ var.big_net_address_space ]
  location = azurerm_resource_group.homelab.location
  resource_group_name = azurerm_resource_group.homelab.name
}

# Subnet for vms
resource "azurerm_subnet" "homelab_vm_net" {
  name = "homelab_vm_net"
  resource_group_name = azurerm_resource_group.homelab.name
  virtual_network_name = azurerm_virtual_network.big_net.name
  address_prefixes = [ var.homelab_vm_net_address_space ]
}

resource "azurerm_network_security_group" "homelab" {
  name = "homelab-sg"
  location = azurerm_resource_group.homelab.location
  resource_group_name = azurerm_resource_group.homelab.name
}

# We have wireguard working, we can drop this
#
#resource "azurerm_network_security_rule" "allow_ssh" {
#  resource_group_name = azurerm_resource_group.homelab.name
#  network_security_group_name = azurerm_network_security_group.homelab.name
#  name = "SSH"
#  priority = 2001
#  direction = "Inbound"
#  access = "Allow"
#  protocol = "Tcp"
#  source_port_range = "*"
#  destination_port_range = "22"
#  source_address_prefix = "*"
#  destination_address_prefix = "*"
#}

resource "azurerm_network_security_rule" "allow_wireguard_in" {
  resource_group_name = azurerm_resource_group.homelab.name
  network_security_group_name = azurerm_network_security_group.homelab.name
  name = "Wireguard_in"
  priority = 1001
  direction = "Inbound"
  access = "Allow"
  protocol = "Udp"
  source_port_range = "*"
  destination_port_range = var.test_vm["wireguard_port"]
  source_address_prefix = "*"
  destination_address_prefix = "*"
}

# Assign dynamic public ipv4 address
# It's $0.004 per hour to lease a dynamic IPV4 address, in a year that's about $35
# Actually I think I'm going to be using a standard tier vm so it's free... will have to see

resource "azurerm_public_ip" "test_vm" {
  name = "test_vm_dip"
  location = azurerm_resource_group.homelab.location
  resource_group_name = azurerm_resource_group.homelab.name
  allocation_method = "Dynamic"
  sku = "Basic"
}

resource "azurerm_network_interface" "test_vm" {
  name = "test_vm-nic"
  location = azurerm_resource_group.homelab.location
  resource_group_name = azurerm_resource_group.homelab.name

  ip_configuration {
    name = "test_vm-nic-config"
    subnet_id = azurerm_subnet.homelab_vm_net.id
    public_ip_address_id = azurerm_public_ip.test_vm.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "test_vm" {
  network_interface_id = azurerm_network_interface.test_vm.id
  network_security_group_id = azurerm_network_security_group.homelab.id
}

resource "azurerm_linux_virtual_machine" "test_vm" {
  name = "test_vm"
  computer_name = "testvm"
  location = azurerm_resource_group.homelab.location
  resource_group_name = azurerm_resource_group.homelab.name
  # Standard_B2ats_v2 is x86_64, Standard_B2pts_v2 is aarch_64
  size = "Standard_B2pts_v2"
  admin_username = var.test_vm["username"]
  admin_password = var.test_vm["password"]

  # keep this on, even if it has already been set
  # better safe than sorry
  disable_password_authentication = true

  admin_ssh_key {
    username = var.test_vm["username"]
    public_key = var.test_vm["ssh_public_key"]
  }

  # custom_data must be in base64
  custom_data = base64encode(var.test_vm["cloud-init"])

  network_interface_ids = [
    azurerm_network_interface.test_vm.id,
  ]

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb = 64
  }

  source_image_reference {
    publisher = "Debian"
    offer = "debian-11"
    sku = "11-backports-arm64"
    version = "latest"
  }
}
