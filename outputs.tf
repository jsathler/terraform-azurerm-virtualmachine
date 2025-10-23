output "name" {
  description = "The name of the virtual machine"
  value       = var.name
}

output "id" {
  description = "The ID of the virtual machine"
  value       = lower(var.os_type) == "windows" ? azurerm_windows_virtual_machine.default[0].id : azurerm_linux_virtual_machine.default[0].id
}

output "privateipaddress" {
  description = "The private ip address of the virtual machine"
  value       = azurerm_network_interface.default.*.private_ip_address
}

output "publicipaddress" {
  description = "The public ip address the virtual machine"
  value       = azurerm_public_ip.default.*.ip_address
}

output "identity" {
  description = "The identity of the virtual machine"
  value       = lower(var.os_type) == "windows" ? azurerm_windows_virtual_machine.default[0].identity : azurerm_linux_virtual_machine.default[0].identity
}
