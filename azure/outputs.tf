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

# # ip address output must be from the vm because dynamic ips are only assigned when attached
# output "azure_bastion_public_ip" {
#   value = azurerm_linux_virtual_machine.azure_bastion.public_ip_address
# }
# 
# # ip address output must be from the vm because dynamic ips are only assigned when attached
# output "azure_bastion_private_ip" {
#   value = azurerm_linux_virtual_machine.azure_bastion.private_ip_address
# }
