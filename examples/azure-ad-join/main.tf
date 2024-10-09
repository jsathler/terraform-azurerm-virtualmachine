locals {
  location            = "NorthEurope"
  resource_group_name = "azureadjoin-example-rg"
  local_user_name     = "localadmin"
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

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "azurerm_network_security_group" "default" {
  name                = "default-nsg"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

resource "azurerm_network_security_rule" "default" {
  name                        = "mypublicip-in-allow-nsgsr"
  resource_group_name         = azurerm_resource_group.default.name
  network_security_group_name = azurerm_network_security_group.default.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["22", "3389"]
  source_address_prefix       = chomp(data.http.myip.response_body)
  destination_address_prefix  = "VirtualNetwork"
}

resource "azurerm_subnet_network_security_group_association" "default" {
  network_security_group_id = azurerm_network_security_group.default.id
  subnet_id                 = azurerm_subnet.default.id
}

resource "random_password" "default" {
  length = 16
}

#################################################################################################################################
# Create a Linux VM with SystemAssigned managed identity and joined to Azure AD
#################################################################################################################################

module "lnxvm" {
  source               = "../../"
  name                 = "lnxvm"
  location             = local.location
  resource_group_name  = azurerm_resource_group.default.name
  local_admin_name     = local.local_user_name
  local_admin_password = random_password.default.result
  subnet_id            = [azurerm_subnet.default.id]
  public_ip            = true
  azuread_join         = true
  identity_type        = "SystemAssigned"
  image_publisher      = "canonical"
  image_offer          = "0001-com-ubuntu-server-jammy"
  image_sku            = "22_04-lts-gen2"
}

#################################################################################################################
# Create a Windows VM with SystemAssigned managed identity and joined to Azure AD
#################################################################################################################

module "winvm" {
  source               = "../../"
  name                 = "winvm"
  location             = local.location
  resource_group_name  = azurerm_resource_group.default.name
  local_admin_name     = local.local_user_name
  local_admin_password = random_password.default.result
  subnet_id            = [azurerm_subnet.default.id]
  public_ip            = true
  azuread_join         = true
  identity_type        = "SystemAssigned"
  os_type              = "windows"
  image_publisher      = "MicrosoftWindowsServer"
  image_offer          = "WindowsServer"
  image_sku            = "2022-datacenter-azure-edition"
}

#################################################################################################################
# Add required RBAC permissions to log in to the VMs with administrator privileges
#
# https://learn.microsoft.com/en-us/azure/active-directory/devices/howto-vm-sign-in-azure-ad-linux
# https://learn.microsoft.com/en-us/azure/active-directory/devices/howto-vm-sign-in-azure-ad-windows
#
# IP address cannot be used when Use a web account to sign in to the remote computer option is used. 
# The name must match the hostname of the remote device in Microsoft Entra ID and be network addressable, resolving to the IP address of the remote device.
#################################################################################################################

data "azurerm_client_config" "default" {}

resource "azurerm_role_assignment" "default" {
  scope                = azurerm_resource_group.default.id
  role_definition_name = "Virtual Machine Administrator Login"
  principal_id         = data.azurerm_client_config.default.object_id
}

output "lnxvm-output" {
  description = "VM outputs:"
  value       = module.lnxvm
}

output "win-vm-output" {
  description = "VM outputs:"
  value       = module.winvm
}

output "password" {
  description = "Password generated:"
  value       = random_password.default.result
  sensitive   = true
}
