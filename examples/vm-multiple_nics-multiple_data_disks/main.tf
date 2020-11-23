locals {
  location            = "NorthEurope"
  resource_group_name = "multiplenic-multipledatadisk-rg"
  local_user_name     = "localadmin"
  boot_diagnostics_sa = "https://<storage-account>.blob.core.windows.net"
  key_vault_id        = "<vault-id>"
  app_subnet_id       = "<app-subnet-id>"
  db_subnet_id        = "<db-subnet-id>"
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
# Create a windows VM in an Availability Zone, with two vNICs, two public IPs, two Data disks and bootdiagnostics
#################################################################################################################################

module "linux-vm01" {
  source               = "../../"
  name                 = "linux-vm01"
  location             = local.location
  resource_group_name  = azurerm_resource_group.default.name
  local_admin_name     = local.local_user_name
  local_admin_password = data.azurerm_key_vault_secret.localpwd.value
  subnet_id            = [local.app_subnet_id, local.db_subnet_id]
  public_ip            = true
  os_type              = "linux"
  image_publisher      = "OpenLogic"
  image_offer          = "CentOS"
  image_sku            = "8_2"
  boot_diagnostics_sa  = local.boot_diagnostics_sa
  boot_disk_type       = "StandardSSD_LRS"
  data_disks = [
    {
      name                      = "data01"
      caching                   = "ReadOnly"
      disk_size_gb              = "10"
      managed_disk_type         = "Standard_LRS"
      lunid                     = 0
      write_accelerator_enabled = false
    },
    {
      name                      = "log01"
      caching                   = "none"
      disk_size_gb              = "10"
      managed_disk_type         = "Standard_LRS"
      lunid                     = 1
      write_accelerator_enabled = false
    }
  ]
}

output "linux-vm01-output" {
  value = module.linux-vm01
}