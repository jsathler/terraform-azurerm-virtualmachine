variable "public_ip" {
  description = "Controls if the VM should have a public IP associated."
  type        = bool
  default     = false
}

variable "public_ip_sku" {
  description = "The SKU of the Public IP. Accepted values are Basic and Standard. If Availability zones are used, you should define 'Standard' and define the 'public_ip_allocation_method' parameter as 'Static'."
  type        = string
  default     = "Basic"
  validation {
    condition     = can(index(["basic", "standard"], lower(var.public_ip_sku)) >= 0)
    error_message = "Accepted values are Basic and Standard."
  }
}

variable "public_ip_allocation_method" {
  description = "Defines the allocation method for this IP address. Accepted values are Static or Dynamic."
  type        = string
  default     = "Dynamic"
  validation {
    condition     = can(index(["static", "dynamic"], lower(var.public_ip_allocation_method)) >= 0)
    error_message = "Accepted values are Static or Dynamic."
  }
}

variable "public_ip_dns_label" {
  description = "Label for the Domain Name. Will be used to make up the FQDN"
  type        = string
  default     = null
}

variable "private_ip_address" {
  description = "List of private VM IP(s)."
  type        = list(string)
  default     = null
}

variable "enable_ip_forwarding" {
  description = "Define if IP Forwarding should be enabled."
  type        = bool
  default     = false
}

variable "enable_accelerated_networking" {
  description = "Controls if 'Accelerated Networking' should be enabled on NIC."
  type        = bool
  default     = false
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

variable "vm_size" {
  description = "The size of the VM."
  type        = string
  default     = "Standard_B1s"
}

variable "hybrid_enabled" {
  description = "Controls if 'Hybrid license' should be enabled."
  type        = bool
  default     = true
}

variable "availability_zone" {
  description = "The availability zone where the VM will be deployed."
  type        = number
  default     = null
}

variable "os_type" {
  description = "Specifies the Operating System. Valid values are 'windows' and 'linux'."
  type        = string
  default     = "windows"
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
  description = "Specifies the version of the image used to create the virtual machine."
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
  description = "Specifies the storage account to host boot diagnostics logs in format 'https://<storage-account-name>.blob.core.windows.net'."
  type        = string
  default     = null
}

variable "boot_disk_type" {
  description = "Specifies the type of managed disk to create for the OS disk. Valid values are Standard_LRS, StandardSSD_LRS or Premium_LRS."
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
  description = "Data disks to be added to the VM. Required key/pair values: name, caching, disk_size_gb, managed_disk_type, lun and write_accelerator_enabled."
  type        = list(object({ name = string, caching = string, disk_size_gb = number, managed_disk_type = string, lunid = number, write_accelerator_enabled = bool }))
  default     = []
}

variable "domain_fqdn" {
  description = "Specifies the domain FQDN to be used to join the computer"
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
  description = "Specifies the post-deploy command to be executed."
  type        = string
  default     = null
}

variable "post_deploy_sa_name" {
  description = "Specifies the storage account name where the post-deploy script is hosted. It is required if the storage account doesn't allow anonymous access."
  type        = string
  default     = null
}

variable "post_deploy_sa_key" {
  description = "Specifies the storage account key where the post-deploy script is hosted. It is required if the storage account doesn't allow anonymous access."
  type        = string
  default     = null
}

variable "enable_automatic_updates" {
  description = "Specifies if Automatic Updates are Enabled for the Windows Virtual Machine."
  type        = bool
  default     = false
}

variable "custom_data" {
  description = "The Base64-Encoded Custom Data which should be used for this Virtual Machine. Changing this forces a new resource to be created"
  type        = string
  default     = null
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