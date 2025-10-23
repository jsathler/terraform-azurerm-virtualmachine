locals {
  location            = "NorthEurope"
  resource_group_name = "simplevmfor-example-rg"
  local_user_name     = "localadmin"
  available_azs       = [1, 2]
  app_vm_names        = ["linux-vm-for01", "linux-vm-for02", "linux-vm-for03"]
}

#In version 4.0 of the Azure Provider, it's now required to specify the Azure Subscription ID when configuring a provider instance in your configuration. This can be done by specifying the subscription_id provider property, or by exporting the ARM_SUBSCRIPTION_ID environment variable
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  location = local.location
  name     = local.resource_group_name
}

resource "azurerm_virtual_network" "default" {
  name                = "azvm-example-vnet"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "default" {
  name                 = "default-snet"
  virtual_network_name = azurerm_virtual_network.default.name
  resource_group_name  = azurerm_resource_group.default.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "random_password" "default" {
  length = 16
}

#################################################################################################################################
# Create multiple Linux VM(s) with minimal (required) parameters using for_each
# Variable app_vm_names will define how many instances will be created
# VMs will be distributed (round-robin) into availability zones defined in available_azs variable
#################################################################################################################################

module "linux-vm-for" {
  for_each             = toset(local.app_vm_names)
  source               = "../../"
  name                 = each.key
  location             = local.location
  resource_group_name  = azurerm_resource_group.default.name
  availability_zone    = element(local.available_azs, index(local.app_vm_names, each.key) % length(local.available_azs))
  local_admin_name     = local.local_user_name
  local_admin_password = random_password.default.result
  subnet_id            = [azurerm_subnet.default.id]
  image_publisher      = "canonical"
  image_offer          = "0001-com-ubuntu-server-jammy"
  image_sku            = "22_04-lts-gen2"
}

output "linux-vm-for-output" {
  value = module.linux-vm-for
}

output "password" {
  description = "Password generated:"
  value       = random_password.default.result
  sensitive   = true
}
