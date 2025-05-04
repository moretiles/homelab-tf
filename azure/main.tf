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

resource "random_pet" "prefix" {
  prefix = var.resource_group_name_prefix
  length = 1
}
