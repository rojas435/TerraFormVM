# Compute Module - Main Configuration
locals {
  common_tags = merge(var.tags, {
    Environment = var.environment
    Module      = "compute"
    ManagedBy   = "terraform"
  })
}

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "vm-${var.project_name}-${var.environment}"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  tags                            = local.common_tags

  network_interface_ids = [var.network_interface_id]

  os_disk {
    caching              = var.os_disk_config.caching
    storage_account_type = var.os_disk_config.storage_account_type
    disk_size_gb         = var.os_disk_config.disk_size_gb
  }

  source_image_reference {
    publisher = var.source_image_config.publisher
    offer     = var.source_image_config.offer
    sku       = var.source_image_config.sku
    version   = var.source_image_config.version
  }

  # Only set custom_data if provided
  custom_data = var.custom_data != "" ? var.custom_data : null
}