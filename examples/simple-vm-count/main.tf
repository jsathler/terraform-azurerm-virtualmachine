locals {
  location            = "NorthEurope"
  resource_group_name = "simplevmcount-example-rg"
  local_user_name     = "localadmin"
  available_azs       = [1, 2]
  number_vms          = 3
}

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
# Create multiple Linux VM(s) with minimal (required) parameters using count
# VMs will be distributed (round-robin) into availability zones defined in available_azs variable
#################################################################################################################################

module "linux-vm-count" {
  count                = local.number_vms
  source               = "../../"
  name                 = "linux-vm-count${format("%02d", count.index + 1)}"
  location             = local.location
  resource_group_name  = azurerm_resource_group.default.name
  availability_zone    = element(local.available_azs, count.index % length(local.available_azs))
  local_admin_name     = local.local_user_name
  local_admin_password = random_password.default.result
  subnet_id            = [azurerm_subnet.default.id]
  image_publisher      = "canonical"
  image_offer          = "0001-com-ubuntu-server-jammy"
  image_sku            = "22_04-lts-gen2"
}

output "linux-vm-count-output" {
  value = module.linux-vm-count
}

output "password" {
  description = "Password generated:"
  value       = random_password.default.result
  sensitive   = true
}
