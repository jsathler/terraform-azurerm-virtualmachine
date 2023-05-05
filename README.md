# AzureRM Virtual Machine Terraform module

Terraform module which creates Virtual Machine resources on Azure.

These types of resources are supported:

* [Public IP](https://docs.microsoft.com/en-us/azure/virtual-network/public-ip-addresses)
* [Virtual Network Interface](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-network-interface)
* [Windows Virtual Machines](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/)
* [Linux Virtual Machines](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/)
* [Azure managed disks](https://docs.microsoft.com/en-us/azure/virtual-machines/managed-disks-overview)
* [Azure virtual machine extensions (AD Join and custom script)](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/overview)

## Terraform versions

Terraform 1.3.0 and newer.

## Usage

```hcl
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
```

More samples in examples folder