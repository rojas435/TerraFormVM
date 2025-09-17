# Common locals for all environments
# This file contains common configurations used across environments

locals {
  # Common resource naming conventions
  naming_convention = {
    separator           = "-"
    resource_group      = "rg"
    virtual_network     = "vnet"
    subnet              = "subnet"
    public_ip           = "pip"
    network_interface   = "nic"
    virtual_machine     = "vm"
    security_group      = "nsg"
  }

  # Common Azure VM sizes by environment
  vm_sizes = {
    development = "Standard_B1s"
    staging     = "Standard_B2s"
    production  = "Standard_D2s_v3"
  }

  # Common security configurations
  security_config = {
    ssh_port = 22
    http_port = 80
    https_port = 443
  }

  # Common OS disk configurations
  os_disk_config = {
    development = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    staging = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    production = {
      caching              = "ReadWrite"
      storage_account_type = "Premium_LRS"
      disk_size_gb         = 128
    }
  }

  # Common allowed locations per Azure policy
  allowed_locations = [
    "northcentralus",
    "chilecentral",
    "centralus",
    "brazilsouth",
    "southcentralus"
  ]
}