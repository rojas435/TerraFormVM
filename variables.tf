variable "subscription_id" {
  type        = string
  description = "ID de suscripción de Azure"
}

variable "location" {
  type        = string
  description = "Región de Azure"
  default     = "chilecentral"
  validation {
    condition = contains([
      "northcentralus",
      "chilecentral",
      "centralus",
      "brazilsouth",
      "southcentralus"
    ], lower(var.location))
    error_message = "La política de la suscripción solo permite regiones: northcentralus, chilecentral, centralus, brazilsouth, southcentralus. Ajusta la variable 'location'."
  }
}

variable "vm_name" {
  type        = string
  description = "Nombre base de la máquina virtual"
  default     = "demo" 
}

variable "vm_size" {
  type        = string
  description = "SKU/tamaño de la VM"
  default     = "Standard_B1s"
}

variable "public_ip_sku" {
  type        = string
  description = "SKU de la IP pública (Basic o Standard)"
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard"], var.public_ip_sku)
    error_message = "public_ip_sku debe ser 'Basic' o 'Standard'."
  }
}

variable "admin_username" {
  type        = string
  description = "Usuario administrador para SSH"
  default     = "profesor"
}

variable "admin_password" {
  type        = string
  description = "Contraseña del usuario administrador (cumpla políticas de Azure)"
  sensitive   = true
}
