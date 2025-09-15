output "public_ip" {
  description = "Dirección IP pública de la VM"
  value       = azurerm_public_ip.public_ip.ip_address
}

output "ssh_command" {
  description = "Comando sugerido para conectarse por SSH"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.public_ip.ip_address}"
}
