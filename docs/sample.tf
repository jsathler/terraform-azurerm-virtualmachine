module "linux-vm01" {
  source               = "jsathler/virtualmachine/azurerm"
  name                 = "linux-vm01"
  location             = "northeurope"
  resource_group_name  = "sample-rg"
  local_admin_name     = "localadminuser"
  local_admin_password = "C0mp3lP@$$w0rd"
  subnet_id            = [<subnet-id>]
  image_publisher      = "canonical"
  image_offer          = "0001-com-ubuntu-server-focal"
  image_sku            = "20_04-lts-gen2"
}