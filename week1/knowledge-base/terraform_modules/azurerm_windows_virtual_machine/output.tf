output "vm_id" {
  description = "ID of the Virtual Machine"
  value       = azurerm_windows_virtual_machine.vm.id
}

output "vm_name" {
  description = "Name of the Virtual Machine"
  value       = azurerm_windows_virtual_machine.vm.name
}

output "vm_private_ip_address" {
  description = "Private IP address of the Virtual Machine"
  value       = azurerm_network_interface.nic.private_ip_address
}

output "vm_nic_name" {
  description = "Name of the Network Interface Configuration attached to the Virtual Machine"
  value       = azurerm_network_interface.nic.name
}

output "vm_nic_id" {
  description = "ID of the Network Interface Configuration attached to the Virtual Machine"
  value       = azurerm_network_interface.nic.id
}

