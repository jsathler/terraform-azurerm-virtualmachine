variable "public_ip" {
  description = "Controls if the VM should have a public IP associated. Defaults to false."
  type        = bool
  default     = false
}

variable "public_ip_sku" {
  description = "The SKU of the Public IP. Accepted values are Basic and Standard. If Availability zones are used, you should define 'Standard' and define the 'public_ip_allocation_method' parameter as 'Static'. Defaults to Standard"
  type        = string
  default     = "Standard"
  validation {
    condition     = can(index(["basic", "standard"], lower(var.public_ip_sku)) >= 0)
    error_message = "Accepted values are Basic and Standard."
  }
}

variable "public_ip_allocation_method" {
  description = "Defines the allocation method for the Public IP address. Accepted values are Static or Dynamic if basic SKU is used, otherwise it will default to Static. Defaults to Static"
  type        = string
  default     = "Static"
  validation {
    condition     = can(index(["static", "dynamic"], lower(var.public_ip_allocation_method)) >= 0)
    error_message = "Accepted values are Static or Dynamic."
  }
}

variable "public_ip_dns_label" {
  description = "Label for the Domain Name. Will be used to make up the FQDN. Defauts to null."
  type        = string
  default     = null
}

variable "private_ip_address" {
  description = "List of private VM IP(s), if not specified a dynamic IP will be allocated. Defauts to null."
  type        = list(string)
  default     = null
}

variable "enable_ip_forwarding" {
  description = "Define if IP Forwarding should be enabled. Defaults to false."
  type        = bool
  default     = false
}

variable "enable_accelerated_networking" {
  description = "Controls if 'Accelerated Networking' should be enabled on NIC. Defaults to true"
  type        = bool
  default     = true
}

variable "location" {
  description = "The region where the VM will be created. This parameter is required"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created. This parameter is required"
  type        = string
}

variable "name" {
  description = "Virtual machine's name. This parameter is required"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to resources."
  type        = map(string)
  default     = {}
}

variable "subnet_id" {
  description = "A list of subnet IDs in which the VM NIC(s) will be attached. This parameter is required"
  type        = list(string)
}

variable "application_security_group_id" {
  description = " The ID of the Application Security Group which this Network Interface which should be connected to. This parameter is optional"
  type        = list(string)
  default     = null
}

variable "vm_size" {
  description = "The size of the VM. Defaults to Standard_D2s_v5"
  type        = string
  default     = "Standard_D2s_v5"
}

variable "hybrid_enabled" {
  description = "Controls if 'Hybrid license' should be enabled. Defaults to true."
  type        = bool
  default     = true
}

variable "availability_zone" {
  description = "The availability zone where the VM will be deployed. Defaults to null."
  type        = number
  default     = null
}

variable "os_type" {
  description = "Specifies the Operating System. Valid values are 'windows' and 'linux'. Defaults to Linux."
  type        = string
  default     = "linux"
  validation {
    condition     = can(index(["windows", "linux"], lower(var.os_type)) >= 0)
    error_message = "Accepted values are Windows or Linux."
  }
}

variable "image_id" {
  description = "The ID of the Operating System Image to be used as source. If not declared, you should declare image_publisher, image_offer and image_sku."
  type        = string
  default     = null
}

variable "image_publisher" {
  description = "Specifies the publisher of the image used to create the virtual machine."
  type        = string
  default     = null
}
variable "image_offer" {
  description = "Specifies the offer of the image used to create the virtual machine."
  type        = string
  default     = null
}
variable "image_sku" {
  description = "Specifies the SKU of the image used to create the virtual machine."
  type        = string
  default     = null
}

variable "image_version" {
  description = "Specifies the version of the image used to create the virtual machine. Defaults to latest."
  type        = string
  default     = "latest"
}

variable "local_admin_name" {
  description = "Specifies the local admin username to be created. This parameter is required"
  type        = string
}

variable "local_admin_password" {
  description = "Specifies the local admin password. For linux VMs you can use this variable or local_admin_key."
  type        = string
  default     = null
}

variable "local_admin_key" {
  description = "The Public Key which should be used for authentication, which needs to be at least 2048-bit and in ssh-rsa format."
  type        = string
  default     = null
}

variable "boot_diagnostics_sa" {
  description = "Specifies the storage account to host boot diagnostics logs in format 'https://<storage-account-name>.blob.core.windows.net'. If you don't specify a storage account, a Managed Storage Account will be used to store Boot Diagnostics."
  type        = string
  default     = null
}

variable "boot_disk_type" {
  description = "Specifies the type of managed disk to create for the OS disk. Valid values are Standard_LRS, StandardSSD_LRS or Premium_LRS. Defaults to StandardSSD_LRS."
  type        = string
  default     = "StandardSSD_LRS"
  validation {
    condition     = can(index(["standard_lrs", "standardssd_lrs", "premium_lrs"], lower(var.boot_disk_type)) >= 0)
    error_message = "Valid values are Standard_LRS, StandardSSD_LRS or Premium_LRS."
  }
}

variable "boot_disk_size_gb" {
  description = "The size of the VM OS disk. This parameter is optional"
  type        = string
  default     = null
}

variable "data_disks" {
  description = "Data disks to be added to the VM. It is a MAP of object, which requires: caching, disk_size_gb, managed_disk_type, lun and write_accelerator_enabled."
  type = map(
    object({
      caching                   = optional(string, "None"),
      disk_size_gb              = number,
      managed_disk_type         = optional(string, "StandardSSD_LRS"),
      lunid                     = number,
      write_accelerator_enabled = optional(bool, false)
  }))
  default = {}
}

variable "domain_fqdn" {
  description = "Specifies the domain FQDN to be used to join the computer."
  type        = string
  default     = null
}

variable "domain_ou" {
  description = "Specifies the domain OU to be used to join the computer in format 'OU=servers,DC=domain,DC=com''."
  type        = string
  default     = null
}

variable "domain_user_name" {
  description = "Specifies the domain username to be used to join the computer to domain."
  type        = string
  default     = null
}

variable "domain_user_password" {
  description = "Specifies the domain password."
  type        = string
  default     = null
}

variable "post_deploy_uri" {
  description = "Specifies the URI to download the post-deploy script."
  type        = string
  default     = null
}

variable "post_deploy_command" {
  description = "Specifies the post-deploy command to be executed. If you define post_deploy_command, you should not define post_deploy_script variable"
  type        = string
  default     = null
}

variable "post_deploy_script" {
  description = "A Base64-encoded and optionally gzip'ed script run by /bin/sh (linux only). If you define post_deploy_script, you should not define post_deploy_command variable"
  type        = string
  default     = null
}

variable "post_deploy_sa_name" {
  description = "Specifies the storage account name where the post-deploy script is hosted. It is required if the storage account doesn't allow anonymous access and it must not be used in conjunction with the post_deploy_identity."
  type        = string
  default     = null
}

variable "post_deploy_sa_key" {
  description = "Specifies the storage account key where the post-deploy script is hosted. It is required if the storage account doesn't allow anonymous access and it must not be used in conjunction with the post_deploy_identity."
  type        = string
  default     = null
}

variable "post_deploy_identity" {
  description = "Specifies the Managed Identity to be used to access the post-deploy script. Set it as \"{}\" to use system-assigned identity, \"{ \"clientId\": \"<ID>\" } \" or \"{ \"objectId\": \"<ID>\" } \". It is required if the storage account doesn't allow anonymous access and it must not be used in conjunction with the post_deploy_sa_name or post_deploy_sa_key."
  type        = string
  default     = null
}

variable "enable_automatic_updates" {
  description = "Specifies if Automatic Updates are Enabled for the Windows Virtual Machine. Defaults to false."
  type        = bool
  default     = false
}

variable "availability_set_id" {
  description = "The ID of the Availability Set in which the Virtual Machine should exist. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "proximity_placement_group_id" {
  description = "The ID of the Proximity Placement Group to which this Virtual Machine should be assigned."
  type        = string
  default     = null
}

variable "identity_type" {
  description = "The type of Managed Identity which should be assigned to the Virtual Machine. Possible values are SystemAssigned, UserAssigned or SystemAssigned, UserAssigned. Defaults to null"
  type        = string
  default     = null
  validation {
    condition     = var.identity_type == null ? true : can(index(["systemassigned", "userassigned", "systemassigned, userassigned"], lower(var.identity_type)) >= 0)
    error_message = "Valid values are SystemAssigned, UserAssigned or SystemAssigned, UserAssigned."
  }
}

variable "identity_ids" {
  description = "A list of User Managed Identity ID's which should be assigned to the Virtual Machine. Defaults to null"
  type        = list(string)
  default     = null
}

variable "patch_mode" {
  description = "Specifies the mode of in-guest patching to this Virtual Machine. Possible values are Manual, AutomaticByOS and AutomaticByPlatform. Defaults to Manual on Windows and to ImageDefault on Linux"
  type        = string
  default     = null
  validation {
    condition     = var.patch_mode == null ? true : can(index(["automaticbyos", "automaticbyplatform"], lower(var.patch_mode)) >= 0)
    error_message = "Valid values are Manual, AutomaticByOS and AutomaticByPlatform."
  }
}

variable "winrm_protocol" {
  description = "Specifies the protocol of listener. Possible values are Http or Https. Defaults to Null"
  type        = string
  default     = null
  validation {
    condition     = var.winrm_protocol == null ? true : can(index(["http", "https"], lower(var.winrm_protocol)) >= 0)
    error_message = "Valid values are Http and Https."
  }
}

variable "winrm_certificate_url" {
  description = "The Secret URL of a Key Vault Certificate, which must be specified when protocol is set to Https. Defaults to null"
  type        = string
  default     = null
}
