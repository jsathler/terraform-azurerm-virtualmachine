<!-- BEGIN_TF_DOCS -->
# AzureRM Virtual Machine Terraform module

Terraform module which creates Virtual Machine resources on Azure.

Supported Azure services:

* [Public IP](https://docs.microsoft.com/en-us/azure/virtual-network/public-ip-addresses)
* [Virtual Network Interface](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-network-interface)
* [Windows Virtual Machines](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/)
* [Linux Virtual Machines](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/)
* [Azure managed disks](https://docs.microsoft.com/en-us/azure/virtual-machines/managed-disks-overview)
* [Azure virtual machine extensions (AD Join and custom script)](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/overview)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.49.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.49.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_managed_disk.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_application_security_group_association.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_security_group_association) | resource |
| [azurerm_public_ip.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_virtual_machine_data_disk_attachment.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_extension.AADLogin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.ADDomainExtension](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.CustomScriptExtension](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_windows_virtual_machine.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accelerated_networking_enabled"></a> [accelerated\_networking\_enabled](#input\_accelerated\_networking\_enabled) | Controls if 'Accelerated Networking' should be enabled on NIC. Defaults to true | `bool` | `true` | no |
| <a name="input_application_security_group_id"></a> [application\_security\_group\_id](#input\_application\_security\_group\_id) | The ID of the Application Security Group which this Network Interface which should be connected to. This parameter is optional | `list(string)` | `null` | no |
| <a name="input_automatic_updates_enabled"></a> [automatic\_updates\_enabled](#input\_automatic\_updates\_enabled) | Specifies if Automatic Updates are Enabled for the Windows Virtual Machine. Defaults to false. | `bool` | `false` | no |
| <a name="input_availability_set_id"></a> [availability\_set\_id](#input\_availability\_set\_id) | The ID of the Availability Set in which the Virtual Machine should exist. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | The availability zone where the VM will be deployed. Defaults to null. | `number` | `null` | no |
| <a name="input_azuread_join"></a> [azuread\_join](#input\_azuread\_join) | Specifies if you want to join this VM to Azure AD. Authenticating to Azure AD requires enabling System Managed Identity (identity\_type). Defaults to 'false' | `bool` | `false` | no |
| <a name="input_boot_diagnostics_sa"></a> [boot\_diagnostics\_sa](#input\_boot\_diagnostics\_sa) | Specifies the storage account to host boot diagnostics logs in format 'https://<storage-account-name>.blob.core.windows.net'. If you don't specify a storage account, a Managed Storage Account will be used to store Boot Diagnostics. | `string` | `null` | no |
| <a name="input_boot_disk_size_gb"></a> [boot\_disk\_size\_gb](#input\_boot\_disk\_size\_gb) | The size of the VM OS disk. This parameter is optional | `string` | `null` | no |
| <a name="input_boot_disk_type"></a> [boot\_disk\_type](#input\_boot\_disk\_type) | Specifies the type of managed disk to create for the OS disk. Valid values are Standard\_LRS, StandardSSD\_LRS or Premium\_LRS. Defaults to StandardSSD\_LRS. | `string` | `"StandardSSD_LRS"` | no |
| <a name="input_data_disks"></a> [data\_disks](#input\_data\_disks) | Data disks to be added to the VM. It is a MAP of object, which requires: caching, disk\_size\_gb, managed\_disk\_type, lun and write\_accelerator\_enabled. | <pre>map(<br/>    object({<br/>      caching                   = optional(string, "None"),<br/>      disk_size_gb              = number,<br/>      managed_disk_type         = optional(string, "StandardSSD_LRS"),<br/>      lunid                     = number,<br/>      write_accelerator_enabled = optional(bool, false)<br/>  }))</pre> | `{}` | no |
| <a name="input_domain_fqdn"></a> [domain\_fqdn](#input\_domain\_fqdn) | Specifies the domain FQDN to be used to join the computer. | `string` | `null` | no |
| <a name="input_domain_ou"></a> [domain\_ou](#input\_domain\_ou) | Specifies the domain OU to be used to join the computer in format 'OU=servers,DC=domain,DC=com''. | `string` | `null` | no |
| <a name="input_domain_user_name"></a> [domain\_user\_name](#input\_domain\_user\_name) | Specifies the domain username to be used to join the computer to domain. | `string` | `null` | no |
| <a name="input_domain_user_password"></a> [domain\_user\_password](#input\_domain\_user\_password) | Specifies the domain password. | `string` | `null` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | A list of User Managed Identity ID's which should be assigned to the Virtual Machine. Defaults to null | `list(string)` | `null` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | The type of Managed Identity which should be assigned to the Virtual Machine. Possible values are 'SystemAssigned', 'UserAssigned' or 'SystemAssigned, UserAssigned'. Defaults to null | `string` | `null` | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | The ID of the Operating System Image to be used as source. If not declared, you should declare image\_publisher, image\_offer and image\_sku. | `string` | `null` | no |
| <a name="input_image_offer"></a> [image\_offer](#input\_image\_offer) | Specifies the offer of the image used to create the virtual machine. | `string` | `null` | no |
| <a name="input_image_publisher"></a> [image\_publisher](#input\_image\_publisher) | Specifies the publisher of the image used to create the virtual machine. | `string` | `null` | no |
| <a name="input_image_sku"></a> [image\_sku](#input\_image\_sku) | Specifies the SKU of the image used to create the virtual machine. | `string` | `null` | no |
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | Specifies the version of the image used to create the virtual machine. Defaults to latest. | `string` | `"latest"` | no |
| <a name="input_ip_forwarding_enabled"></a> [ip\_forwarding\_enabled](#input\_ip\_forwarding\_enabled) | Define if IP Forwarding should be enabled. Defaults to false. | `bool` | `false` | no |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | Specifies the type of 'Azure Hybrid Use Benefit' should be used for this Virtual Machine. Possible values are 'Windows\_Client', 'Windows\_Server', 'RHEL\_BYOS' and 'SLES\_BYOS' | `string` | `null` | no |
| <a name="input_local_admin_key"></a> [local\_admin\_key](#input\_local\_admin\_key) | The Public Key which should be used for authentication, which needs to be at least 2048-bit and in ssh-rsa format. | `string` | `null` | no |
| <a name="input_local_admin_name"></a> [local\_admin\_name](#input\_local\_admin\_name) | Specifies the local admin username to be created. This parameter is required | `string` | n/a | yes |
| <a name="input_local_admin_password"></a> [local\_admin\_password](#input\_local\_admin\_password) | Specifies the local admin password. For linux VMs you can use this variable or local\_admin\_key. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The region where the VM will be created. This parameter is required | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Virtual machine's name. This parameter is required | `string` | n/a | yes |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | Specifies the Operating System. Valid values are 'windows' and 'linux'. Defaults to Linux. | `string` | `"linux"` | no |
| <a name="input_patch_mode"></a> [patch\_mode](#input\_patch\_mode) | Specifies the mode of in-guest patching to this Virtual Machine. Possible values are Manual, AutomaticByOS and AutomaticByPlatform. Defaults to Manual on Windows and to ImageDefault on Linux | `string` | `null` | no |
| <a name="input_post_deploy_command"></a> [post\_deploy\_command](#input\_post\_deploy\_command) | Specifies the post-deploy command to be executed. If you define post\_deploy\_command, you should not define post\_deploy\_script variable | `string` | `null` | no |
| <a name="input_post_deploy_identity"></a> [post\_deploy\_identity](#input\_post\_deploy\_identity) | Specifies the Managed Identity to be used to access the post-deploy script. Set it as "{}" to use system-assigned identity, "{ "clientId": "<ID>" } " or "{ "objectId": "<ID>" } ". It is required if the storage account doesn't allow anonymous access and it must not be used in conjunction with the post\_deploy\_sa\_name or post\_deploy\_sa\_key. | `string` | `null` | no |
| <a name="input_post_deploy_sa_key"></a> [post\_deploy\_sa\_key](#input\_post\_deploy\_sa\_key) | Specifies the storage account key where the post-deploy script is hosted. It is required if the storage account doesn't allow anonymous access and it must not be used in conjunction with the post\_deploy\_identity. | `string` | `null` | no |
| <a name="input_post_deploy_sa_name"></a> [post\_deploy\_sa\_name](#input\_post\_deploy\_sa\_name) | Specifies the storage account name where the post-deploy script is hosted. It is required if the storage account doesn't allow anonymous access and it must not be used in conjunction with the post\_deploy\_identity. | `string` | `null` | no |
| <a name="input_post_deploy_script"></a> [post\_deploy\_script](#input\_post\_deploy\_script) | A Base64-encoded and optionally gzip'ed script run by /bin/sh (linux only). If you define post\_deploy\_script, you should not define post\_deploy\_command variable | `string` | `null` | no |
| <a name="input_post_deploy_uri"></a> [post\_deploy\_uri](#input\_post\_deploy\_uri) | Specifies the URI to download the post-deploy script. | `string` | `null` | no |
| <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address) | List of private VM IP(s), if not specified a dynamic IP will be allocated. Defauts to null. | `list(string)` | `null` | no |
| <a name="input_proximity_placement_group_id"></a> [proximity\_placement\_group\_id](#input\_proximity\_placement\_group\_id) | The ID of the Proximity Placement Group to which this Virtual Machine should be assigned. | `string` | `null` | no |
| <a name="input_public_ip"></a> [public\_ip](#input\_public\_ip) | Controls if the VM should have a public IP associated. Defaults to false. | `bool` | `false` | no |
| <a name="input_public_ip_allocation_method"></a> [public\_ip\_allocation\_method](#input\_public\_ip\_allocation\_method) | Defines the allocation method for the Public IP address. Accepted values are Static or Dynamic if basic SKU is used, otherwise it will default to Static. Defaults to Static | `string` | `"Static"` | no |
| <a name="input_public_ip_dns_label"></a> [public\_ip\_dns\_label](#input\_public\_ip\_dns\_label) | Label for the Domain Name. Will be used to make up the FQDN. Defauts to null. | `string` | `null` | no |
| <a name="input_public_ip_id"></a> [public\_ip\_id](#input\_public\_ip\_id) | To assign an existing Public IP to your VM, set this variable. public\_ip\_id takes precedence over public\_ip variable. Defaults to 'null'. | `string` | `null` | no |
| <a name="input_public_ip_sku"></a> [public\_ip\_sku](#input\_public\_ip\_sku) | The SKU of the Public IP. Accepted values are Basic and Standard. If Availability zones are used, you should define 'Standard' and define the 'public\_ip\_allocation\_method' parameter as 'Static'. Defaults to Standard | `string` | `"Standard"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which the resources will be created. This parameter is required | `string` | n/a | yes |
| <a name="input_secure_boot_enabled"></a> [secure\_boot\_enabled](#input\_secure\_boot\_enabled) | Specifies if Secure Boot and Trusted Launch is enabled for the Virtual Machine. This parameter is optional and defaults to 'true' | `bool` | `true` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | A list of subnet IDs in which the VM NIC(s) will be attached. This parameter is required | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to resources. | `map(string)` | `{}` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | The size of the VM. Defaults to Standard\_D2s\_v5 | `string` | `"Standard_D2s_v5"` | no |
| <a name="input_vtpm_enabled"></a> [vtpm\_enabled](#input\_vtpm\_enabled) | Specifies if vTPM (virtual Trusted Platform Module) and Trusted Launch is enabled for the Virtual Machine. This parameter is optional and defaults to 'true' | `bool` | `true` | no |
| <a name="input_winrm_certificate_url"></a> [winrm\_certificate\_url](#input\_winrm\_certificate\_url) | The Secret URL of a Key Vault Certificate, which must be specified when protocol is set to Https. Defaults to null | `string` | `null` | no |
| <a name="input_winrm_protocol"></a> [winrm\_protocol](#input\_winrm\_protocol) | Specifies the protocol of listener. Possible values are Http or Https. Defaults to Null | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the virtual machine |
| <a name="output_identity"></a> [identity](#output\_identity) | The identity of the virtual machine |
| <a name="output_name"></a> [name](#output\_name) | The name of the virtual machine |
| <a name="output_privateipaddress"></a> [privateipaddress](#output\_privateipaddress) | The private ip address of the virtual machine |
| <a name="output_publicipaddress"></a> [publicipaddress](#output\_publicipaddress) | The public ip address the virtual machine |

## Examples
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
More examples in ./examples folder
<!-- END_TF_DOCS -->