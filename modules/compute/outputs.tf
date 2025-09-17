# Compute Module - Outputs
output "vm_id" {
  description = "ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.vm.id
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = azurerm_linux_virtual_machine.vm.name
}

output "vm_private_ip" {
  description = "Private IP address of the virtual machine"
  value       = azurerm_linux_virtual_machine.vm.private_ip_address
}

output "vm_admin_username" {
  description = "Administrator username"
  value       = azurerm_linux_virtual_machine.vm.admin_username
}