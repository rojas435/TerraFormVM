# Staging Environment Outputs
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "public_ip_address" {
  description = "Public IP address of the VM"
  value       = module.networking.public_ip_address
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = module.compute.vm_name
}

output "vm_private_ip" {
  description = "Private IP address of the VM"
  value       = module.compute.vm_private_ip
}

output "ssh_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh ${module.compute.vm_admin_username}@${module.networking.public_ip_address}"
}

output "environment_info" {
  description = "Environment information"
  value = {
    environment = "staging"
    vm_size     = var.vm_size
    location    = var.location
  }
}