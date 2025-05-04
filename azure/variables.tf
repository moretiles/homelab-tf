variable "resource_group_location" {
  type = string
  default = "eastus"
  description = "Location of the resource group"
}

variable "resource_group_name_prefix" {
  type = string
  default = "rg"
  description = "Prefix of the resource group's name that is combined with a random ID so you name is unique among all Azure subscriptions."
}

variable "big_net_address_space" {
  type = string
  default = "0.0.0.0/16"
  description = "We need a big network"
}

variable "homelab_vm_net_address_space" {
  type = string
  default = "0.0.0.0/16"
  description = "Kind of arbitrary but it works"
}

