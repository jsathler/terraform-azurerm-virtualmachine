locals {
  location            = "NorthEurope"
  resource_group_name = "multiplenicanddatadisk-example-vm-rg"
  local_user_name     = "localadmin"

  tags = {
    Environment = "PRD"
    Application = "App01"
  }

}

#In version 4.0 of the Azure Provider, it's now required to specify the Azure Subscription ID when configuring a provider instance in your configuration. This can be done by specifying the subscription_id provider property, or by exporting the ARM_SUBSCRIPTION_ID environment variable
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  location = local.location
  name     = local.resource_group_name
  tags     = local.tags
}

resource "azurerm_virtual_network" "default" {
  name                = "azvm-example-vnet"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.0.0.0/16"]
  tags                = local.tags
}

resource "azurerm_subnet" "app" {
  name                 = "app-snet"
  virtual_network_name = azurerm_virtual_network.default.name
  resource_group_name  = azurerm_resource_group.default.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "management" {
  name                 = "management-snet"
  virtual_network_name = azurerm_virtual_network.default.name
  resource_group_name  = azurerm_resource_group.default.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "random_password" "default" {
  length = 16
}

#####################################################################################################################################################
# Create a windows VM in an Availability Zone, with two vNICs, one public IP (attached to the first NIC which will be attached to the first subnet), 
#  two Data disks, bootdiagnostics in managed Storage Account and Identity
#####################################################################################################################################################

module "linux-vm01" {
  source               = "../../"
  name                 = "linux-vm01"
  location             = local.location
  resource_group_name  = azurerm_resource_group.default.name
  local_admin_name     = local.local_user_name
  local_admin_password = random_password.default.result
  subnet_id            = [azurerm_subnet.app.id, azurerm_subnet.management.id]
  public_ip            = true
  image_publisher      = "canonical"
  image_offer          = "0001-com-ubuntu-server-jammy"
  image_sku            = "22_04-lts-gen2"
  boot_disk_type       = "Standard_LRS"
  identity_type        = "SystemAssigned"
  data_disks = {
    data01 = {
      caching                   = "ReadOnly"
      disk_size_gb              = 32
      managed_disk_type         = "Standard_LRS"
      lunid                     = 0
      write_accelerator_enabled = false
    },
    log01 = {
      #caching                   = "None" #defaults to None
      disk_size_gb = 8
      #managed_disk_type         = "StandardSSD_LRS" #defaults to StandardSSD_LRS
      lunid = 1
      #write_accelerator_enabled = false #defaults to false
    }
  }
  tags = local.tags
}

output "linux-vm01-output" {
  value = module.linux-vm01
}

output "password" {
  description = "Password generated:"
  value       = random_password.default.result
  sensitive   = true
}
