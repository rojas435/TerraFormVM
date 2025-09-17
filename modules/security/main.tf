# Security Module - Main Configuration
locals {
  common_tags = merge(var.tags, {
    Environment = var.environment
    Module      = "security"
    ManagedBy   = "terraform"
  })
}

# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${var.project_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.common_tags

  # Default SSH rule
  dynamic "security_rule" {
    for_each = var.allowed_ssh_sources
    content {
      name                       = "SSH-${security_rule.key}"
      priority                   = 1001 + security_rule.key
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = security_rule.value
      destination_address_prefix = "*"
    }
  }

  # Custom security rules
  dynamic "security_rule" {
    for_each = var.custom_security_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

# Association NSG to Subnet
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.nsg.id
}