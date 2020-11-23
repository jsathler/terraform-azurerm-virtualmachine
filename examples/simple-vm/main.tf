locals {
  location            = "NorthEurope"
  resource_group_name = "simple-vm-rg"
  local_user_name     = "localadmin"
  key_vault_id        = "<vault-id>"
  app_subnet_id       = "<app-subnet-id>"
}

provider "azurerm" {
  features {}
}

data "azurerm_key_vault_secret" "localpwd" {
  name         = local.local_user_name
  key_vault_id = local.key_vault_id
}

resource "azurerm_resource_group" "default" {
  location = local.location
  name     = local.resource_group_name
}

#################################################################################################################################
# Create a Linux VM with minimal (required) parameters
#################################################################################################################################

module "linux-vm01" {
  source               = "../../"
  name                 = "linux-vm01"
  location             = local.location
  resource_group_name  = azurerm_resource_group.default.name
  local_admin_name     = local.local_user_name
  local_admin_password = data.azurerm_key_vault_secret.localpwd.value
  subnet_id            = [local.app_subnet_id]
  os_type              = "linux"
  image_publisher      = "OpenLogic"
  image_offer          = "CentOS"
  image_sku            = "8_2"
}

output "linux-vm-output" {
  value = module.linux-vm01
}