# Production Environment Variables
variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "chilecentral"
  validation {
    condition = contains([
      "northcentralus",
      "chilecentral", 
      "centralus",
      "brazilsouth",
      "southcentralus"
    ], lower(var.location))
    error_message = "Subscription policy only allows regions: northcentralus, chilecentral, centralus, brazilsouth, southcentralus."
  }
}

variable "project_name" {
  type        = string
  description = "Base name of the project for resource naming"
  default     = "demo"
}

variable "owner" {
  type        = string
  description = "Owner of the resources"
  default     = "production-team"
}

variable "vm_size" {
  type        = string
  description = "SKU/size of the VM"
  default     = "Standard_D2s_v3"  # Production-grade VM
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

variable "allowed_ssh_sources" {
  type        = list(string)
  description = "List of IP addresses or CIDR blocks allowed to SSH"
  default     = []  # No SSH access by default in production - must be explicitly configured
}