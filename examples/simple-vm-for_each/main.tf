locals {
  location            = "NorthEurope"
  resource_group_name = "simple-vm-for-rg"
  local_user_name     = "localadmin"
  key_vault_id        = "<vault-id>"
  app_subnet_id       = "<app-subnet-id>"
  available_azs       = [1, 2]
  app_vm_names        = ["linux-vm-for01", "linux-vm-for02", "linux-vm-for03", "linux-vm-for04"]
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
  local_admin_password = data.azurerm_key_vault_secret.localpwd.value
  subnet_id            = [local.app_subnet_id]
  vm_size              = "Standard_B1s"
  os_type              = "linux"
  image_publisher      = "OpenLogic"
  image_offer          = "CentOS"
  image_sku            = "8_2"
}

output "linux-vm-for-output" {
  value = module.linux-vm-for
}