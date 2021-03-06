#################################################################################################################################
# General information
#
# azurerm_windows_virtual_machine and linux_windows_virtual_machine resource types zone is defined as String but in other 
# resources it is defined as list. If changed in future provider version, we can adapt this code.
#################################################################################################################################

#################################################################################################################################
# Public IP
#
# It creates only one public ip per VM, even if the VM has multiple vNICs
# If Availability Zone is used, IP will be created as Static and Standard as required by Azure
#################################################################################################################################

resource "azurerm_public_ip" "default" {
  count               = var.public_ip ? 1 : 0
  name                = "${var.name}-PublicIP01"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.availability_zone == null ? var.public_ip_allocation_method : "Static"
  sku                 = var.availability_zone == null ? var.public_ip_sku : "Standard"
  zones               = var.availability_zone == null ? null : [var.availability_zone]
  domain_name_label   = var.public_ip_dns_label != null ? var.public_ip_dns_label : null
  tags                = var.tags
}

#################################################################################################################################
# Network Interface
#################################################################################################################################

resource "azurerm_network_interface" "default" {
  count                         = length(var.subnet_id)
  name                          = "${var.name}-nic${format("%02d", count.index + 1)}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enable_accelerated_networking = var.enable_accelerated_networking
  enable_ip_forwarding          = var.enable_ip_forwarding

  ip_configuration {
    name                          = "${var.name}-PrivateIP${format("%02d", count.index + 1)}"
    subnet_id                     = element(var.subnet_id, count.index)
    private_ip_address_allocation = var.private_ip_address != null ? "Static" : "Dynamic"
    private_ip_address            = var.private_ip_address != null ? element(var.private_ip_address, count.index) : null
    public_ip_address_id          = length(azurerm_public_ip.default.*.id) > 0 && count.index == 0 ? azurerm_public_ip.default.0.id : null
  }

  tags = var.tags
}

#################################################################################################################################
# Windows Virtual Machine
#################################################################################################################################

resource "azurerm_windows_virtual_machine" "default" {
  count                        = var.os_type == lower("windows") ? 1 : 0
  name                         = var.name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  network_interface_ids        = azurerm_network_interface.default.*.id
  size                         = var.vm_size
  license_type                 = var.os_type == lower("windows") && var.hybrid_enabled ? "Windows_Server" : null
  zone                         = var.availability_zone == null ? null : var.availability_zone
  availability_set_id          = var.availability_set_id
  proximity_placement_group_id = var.proximity_placement_group_id

  admin_username = var.local_admin_name
  admin_password = var.local_admin_password

  source_image_id = var.image_id
  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  custom_data              = var.custom_data
  enable_automatic_updates = var.enable_automatic_updates

  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics_sa == null ? [] : [var.boot_diagnostics_sa]
    content {
      storage_account_uri = var.boot_diagnostics_sa
    }
  }

  os_disk {
    name                 = "${var.name}-os"
    storage_account_type = var.boot_disk_type
    disk_size_gb         = var.boot_disk_size_gb
    caching              = "ReadWrite"
  }

  tags = var.tags
}

#################################################################################################################################
# Linux Virtual Machine
#################################################################################################################################

resource "azurerm_linux_virtual_machine" "default" {
  count                        = var.os_type == lower("linux") ? 1 : 0
  name                         = var.name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  network_interface_ids        = azurerm_network_interface.default.*.id
  size                         = var.vm_size
  zone                         = var.availability_zone == null ? null : var.availability_zone
  availability_set_id          = var.availability_set_id
  proximity_placement_group_id = var.proximity_placement_group_id

  disable_password_authentication = var.local_admin_key == null ? false : true

  admin_username = var.local_admin_name
  admin_password = var.local_admin_password

  dynamic "admin_ssh_key" {
    for_each = var.local_admin_key == null ? [] : [var.local_admin_key]
    content {
      username   = var.local_admin_name
      public_key = file(var.local_admin_key)
    }
  }

  source_image_id = var.image_id
  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  custom_data = var.custom_data

  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics_sa == null ? [] : [var.boot_diagnostics_sa]
    content {
      storage_account_uri = var.boot_diagnostics_sa
    }
  }

  os_disk {
    name                 = "${var.name}-os"
    storage_account_type = var.boot_disk_type
    disk_size_gb         = var.boot_disk_size_gb
    caching              = "ReadWrite"
  }
}

#################################################################################################################################
# Virtual Machine Disks
#################################################################################################################################

resource "azurerm_managed_disk" "default" {
  for_each             = { for data_disk in var.data_disks : data_disk.name => data_disk }
  name                 = "${var.name}-${each.value.name}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  disk_size_gb         = each.value.disk_size_gb
  storage_account_type = each.value.managed_disk_type
  create_option        = "Empty"
  zones                = var.availability_zone == null ? null : [var.availability_zone]
}

#################################################################################################################################
# Virtual Machine Disks attachment
#################################################################################################################################

resource "azurerm_virtual_machine_data_disk_attachment" "default" {
  for_each                  = { for data_disk in var.data_disks : data_disk.name => data_disk }
  managed_disk_id           = azurerm_managed_disk.default[each.key].id
  virtual_machine_id        = var.os_type == lower("windows") ? azurerm_windows_virtual_machine.default[0].id : azurerm_linux_virtual_machine.default[0].id
  write_accelerator_enabled = each.value.write_accelerator_enabled
  lun                       = each.value.lunid
  caching                   = each.value.caching
}

#################################################################################################################################
# Windows AD domain join
#################################################################################################################################

resource "azurerm_virtual_machine_extension" "ADDomainExtension" {
  count                = var.domain_fqdn != null && var.os_type == lower("windows") ? 1 : 0
  name                 = "${var.name}-ADDomainExtension"
  virtual_machine_id   = azurerm_windows_virtual_machine.default[0].id
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"

  settings           = <<SETTINGS
    {
        "Name": "${var.domain_fqdn}",
        "OUPath": "${var.domain_ou}",
        "User": "${var.domain_fqdn}\\${var.domain_user_name}",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
    {
      "Password": "${var.domain_user_password}"
    }
  PROTECTED_SETTINGS

  depends_on = [azurerm_windows_virtual_machine.default]
}

#################################################################################################################################
# Windows virtual machine post-deploy script
#################################################################################################################################

resource "azurerm_virtual_machine_extension" "CustomScriptExtension" {
  count                = var.post_deploy_uri != null ? 1 : 0
  name                 = "${var.name}-CustomScriptExtension"
  virtual_machine_id   = var.os_type == lower("windows") ? azurerm_windows_virtual_machine.default[0].id : azurerm_linux_virtual_machine.default[0].id
  publisher            = var.os_type == lower("windows") ? "Microsoft.Compute" : "Microsoft.Azure.Extensions"
  type                 = var.os_type == lower("windows") ? "CustomScriptExtension" : "CustomScript"
  type_handler_version = var.os_type == lower("windows") ? "1.10" : "2.1"

  settings = <<SETTINGS
    {
        "fileUris": ["${var.post_deploy_uri}"],
        "commandToExecute": "${var.post_deploy_command}"
    }
  SETTINGS

  protected_settings = var.post_deploy_sa_name == null ? null : <<PROTECTED_SETTINGS
    {
      "storageAccountName": "var.post_deploy_sa_name",
      "storageAccountKey": "var.post_deploy_sa_key"      
    }
  PROTECTED_SETTINGS

  depends_on = [azurerm_virtual_machine_extension.ADDomainExtension, azurerm_linux_virtual_machine.default]
}