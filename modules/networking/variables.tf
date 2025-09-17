# Networking Module - Variables
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

variable "vnet_address_space" {
  type        = list(string)
  description = "Address space for the virtual network"
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefixes" {
  type        = list(string)
  description = "Address prefixes for the subnet"
  default     = ["10.0.1.0/24"]
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}