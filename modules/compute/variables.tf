# Compute Module - Variables
variable "location" {
  type        = string
  description = "Azure region where resources will be created"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, production)"
}

variable "project_name" {
  type        = string
  description = "Name of the project for resource naming"
}

variable "vm_size" {
  type        = string
  description = "SKU/size of the VM"
  default     = "Standard_B1s"
}

variable "admin_username" {
  type        = string
  description = "Administrator username for SSH"
  default     = "azureuser"
}

variable "admin_password" {
  type        = string
  description = "Administrator password (must comply with Azure policies)"
  sensitive   = true
}

variable "network_interface_id" {
  type        = string
  description = "ID of the network interface to attach to VM"
}

variable "custom_data" {
  type        = string
  description = "Base64 encoded custom data for cloud-init"
  default     = ""
}

variable "os_disk_config" {
  type = object({
    caching              = string
    storage_account_type = string
    disk_size_gb         = optional(number)
  })
  description = "OS disk configuration"
  default = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

variable "source_image_config" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  description = "Source image configuration"
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}