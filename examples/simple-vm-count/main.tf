locals {
  location            = "NorthEurope"
  resource_group_name = "simple-vm-count-rg"
  local_user_name     = "localadmin"
  key_vault_id        = "<vault-id>"
  app_subnet_id       = "<app-subnet-id>"
  available_azs       = [1, 2]
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
# Create multiple Linux VM(s) with minimal (required) parameters using count
# VMs will be distributed (round-robin) into availability zones defined in available_azs variable
#################################################################################################################################

module "linux-vm-count" {
  count                = 4
  source               = "../../"
  name                 = "linux-vm-count${format("%02d", count.index + 1)}"
  location             = local.location
  resource_group_name  = azurerm_resource_group.default.name
  availability_zone    = element(local.available_azs, count.index % length(local.available_azs))
  local_admin_name     = local.local_user_name
  local_admin_password = data.azurerm_key_vault_secret.localpwd.value
  subnet_id            = [local.app_subnet_id]
  vm_size              = "Standard_B1s"
  os_type              = "linux"
  image_publisher      = "OpenLogic"
  image_offer          = "CentOS"
  image_sku            = "8_2"
}

output "linux-vm-count-output" {
  value = module.linux-vm-count
}