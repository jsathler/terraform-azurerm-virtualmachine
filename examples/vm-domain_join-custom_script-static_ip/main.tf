locals {
  location            = "NorthEurope"
  resource_group_name = "domainjoin-customscript-vm-rg"
  local_user_name     = "localadmin"
  domain_fqdn         = "<domain-fqdn>"
  domain_ou           = "<OU-DN-to-create-machine-account>"
  domain_user_name    = "domainuser"
  key_vault_id        = "<vault-id>"
  app_subnet_id       = "<app-subnet-id>"
  tags = {
    Environment = "PRD"
    Application = "App01"
  }
}
provider "azurerm" {
  features {}
}

data "azurerm_key_vault_secret" "localpwd" {
  name         = local.local_user_name
  key_vault_id = local.key_vault_id
}

data "azurerm_key_vault_secret" "domainpwd" {
  name         = local.domain_user_name
  key_vault_id = local.key_vault_id
}

resource "azurerm_resource_group" "default" {
  location = local.location
  name     = local.resource_group_name
  tags     = local.tags
}

#################################################################################################################
# Create a VM with static IP, join it to domain, runs a post-deploy script and enable Accelerated Networking
# Parameters post_deploy_sa_name and post_deploy_sa_key are required if a storage account is not public available
#################################################################################################################

module "windows-vm01" {
  source                        = "../../"
  name                          = "windows-vm01"
  location                      = local.location
  resource_group_name           = azurerm_resource_group.default.name
  local_admin_name              = local.local_user_name
  local_admin_password          = data.azurerm_key_vault_secret.localpwd.value
  domain_fqdn                   = local.domain_fqdn
  domain_ou                     = local.domain_ou
  domain_user_name              = local.domain_user_name
  domain_user_password          = data.azurerm_key_vault_secret.domainpwd.value
  post_deploy_uri               = "https://<storage-account>.blob.core.windows.net/customscript/post-deploy.ps1"
  post_deploy_command           = "powershell -ExecutionPolicy Unrestricted -File post-deploy.ps1"
  subnet_id                     = [local.app_subnet_id]
  private_ip_address            = ["10.0.2.50"]
  enable_accelerated_networking = true
  vm_size                       = "Standard_d4s_v3"
  os_type                       = "windows"
  image_publisher               = "MicrosoftWindowsServer"
  image_offer                   = "WindowsServer"
  image_sku                     = "2019-Datacenter"
  tags                          = local.tags
}

#################################################################################################################
# Create a Linux VM with data disk and run a post-deploy script
#################################################################################################################

module "linux-vm01" {
  source               = "../../"
  name                 = "linux-vm01"
  location             = local.location
  resource_group_name  = azurerm_resource_group.default.name
  local_admin_name     = local.local_user_name
  local_admin_password = data.azurerm_key_vault_secret.localpwd.value
  post_deploy_uri      = "https://<storage-account>.blob.core.windows.net/customscript/post-deploy.sh"
  post_deploy_command  = "sh post-deploy.sh"
  subnet_id            = [local.app_subnet_id]
  os_type              = "linux"
  image_publisher      = "OpenLogic"
  image_offer          = "CentOS"
  image_sku            = "8_2"
  tags                 = local.tags
}

output "windows-vm01-output" {
  value = module.windows-vm01
}

output "linux-vm01-output" {
  value = module.linux-vm01
}