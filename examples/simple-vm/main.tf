locals {
  location            = "NorthEurope"
  resource_group_name = "simplevm-example-rg"
  local_user_name     = "localadmin"
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

resource "azurerm_application_security_group" "default" {
  name                = "default-asg"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
}

resource "random_password" "default" {
  length = 16
}

#################################################################################################################################
# Create a Linux VM with minimal (required) parameters
#################################################################################################################################

module "linux-vm01" {
  source                        = "../../"
  name                          = "linux-vm01"
  location                      = local.location
  resource_group_name           = azurerm_resource_group.default.name
  local_admin_name              = local.local_user_name
  local_admin_password          = random_password.default.result
  subnet_id                     = [azurerm_subnet.default.id]
  application_security_group_id = [azurerm_application_security_group.default.id]
  image_publisher               = "canonical"
  image_offer                   = "0001-com-ubuntu-server-jammy"
  image_sku                     = "22_04-lts-gen2"
}

#################################################################################################################
# Create a Windows VM with minimal required parameters but with WinRM enabled
#################################################################################################################

module "windows-vm01" {
  source               = "../../"
  name                 = "windows-vm01"
  location             = local.location
  resource_group_name  = azurerm_resource_group.default.name
  local_admin_name     = local.local_user_name
  local_admin_password = random_password.default.result
  subnet_id            = [azurerm_subnet.default.id]
  os_type              = "windows"
  image_publisher      = "MicrosoftWindowsServer"
  image_offer          = "WindowsServer"
  image_sku            = "2022-datacenter-azure-edition"
  winrm_protocol       = "Http"
}

output "linux-vm-output" {
  description = "VM outputs:"
  value       = module.linux-vm01
}

output "windows-vm-output" {
  description = "VM outputs:"
  value       = module.windows-vm01
}

output "password" {
  description = "Password generated:"
  value       = random_password.default.result
  sensitive   = true
}
