output "name" {
  value = var.name
}

output "id" {
  value = length(azurerm_windows_virtual_machine.default.*.id) > 0 ? azurerm_windows_virtual_machine.default[0].id : azurerm_linux_virtual_machine.default[0].id
}

output "privateipaddress" {
  value = azurerm_network_interface.default.*.private_ip_address
}

output "publicipaddress" {
  value = azurerm_public_ip.default.*.ip_address
}