# Staging Environment Configuration
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.100.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Locals for license handling and common configurations
locals {
  environment          = "staging"
  project_name         = var.project_name
  license_file_path    = "${path.root}/../../shared/templates/license.txt"
  license_content      = fileexists(local.license_file_path) ? file(local.license_file_path) : "LICENCIA_NO_SUMINISTRADA"
  
  # Common tags for all resources
  common_tags = {
    Environment = local.environment
    Project     = local.project_name
    ManagedBy   = "terraform"
    Owner       = var.owner
    CostCenter  = "staging"
  }
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.project_name}-${local.environment}"
  location = var.location
  tags     = local.common_tags
}

# Networking Module
module "networking" {
  source = "../../modules/networking"

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  environment         = local.environment
  project_name        = local.project_name
  tags                = local.common_tags

  # Staging-specific networking configuration
  vnet_address_space       = ["10.1.0.0/16"]
  subnet_address_prefixes  = ["10.1.1.0/24"]
}

# Security Module
module "security" {
  source = "../../modules/security"

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  environment         = local.environment
  project_name        = local.project_name
  subnet_id           = module.networking.subnet_id
  tags                = local.common_tags

  # Staging environment has more restrictive SSH access
  allowed_ssh_sources = var.allowed_ssh_sources

  # Custom security rules for staging
  custom_security_rules = [
    {
      name                       = "AllowHTTPS"
      priority                   = 1100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]

  depends_on = [module.networking]
}

# Compute Module
module "compute" {
  source = "../../modules/compute"

  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  environment           = local.environment
  project_name          = local.project_name
  network_interface_id  = module.networking.network_interface_id
  tags                  = local.common_tags

  # Staging-specific compute configuration
  vm_size        = var.vm_size
  admin_username = var.admin_username
  admin_password = var.admin_password

  # Cloud-init configuration with license
  custom_data = base64encode(
    templatefile(
      "${path.root}/../../shared/templates/cloud-init.tpl",
      {
        license_content = local.license_content
        host_name       = "${local.project_name}-${local.environment}"
      }
    )
  )

  depends_on = [module.networking, module.security]
}