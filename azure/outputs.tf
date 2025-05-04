output "homelab_name" {
    description = "Name of the created resource group"
    value = azurerm_resource_group.homelab.name
}

output "big_net_name" {
    description = "Name of the created virtual network"
    value = azurerm_virtual_network.big_net.name
}

output "homelab_vm_net_name" {
    description = "Name of the created virtual network"
    value = azurerm_virtual_network.big_net.name
}
