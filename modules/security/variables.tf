# Security Module - Variables
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

variable "subnet_id" {
  type        = string
  description = "ID of the subnet to associate with NSG"
}

variable "allowed_ssh_sources" {
  type        = list(string)
  description = "List of IP addresses or CIDR blocks allowed to SSH"
  default     = ["*"]
}

variable "custom_security_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  description = "List of custom security rules"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}