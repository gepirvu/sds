# Namin conventions ------------------------------------------------------------------------------------------------------------------------------------------------ #

project_name = "ci"

subscription = "np"

environment = "dev"

usecase = "buildagent"


# VMSS properties --------------------------------------------------------------------------------------------------------------------------------------------------- #

resource_group_name = "axso-np-appl-ssp-test-rg"

location = "West Europe"

linux_vmss_sku = "Standard_D2as_v4"

instances = 1

overprovision = false

os_upgrade_mode = "Manual"

availability_zones = null

source_image_id = null

# VMSS Network ------------------------------------------------------------------------------------------------------------------------------------------------------- #

vmss_subnet = {
  subnet_name  = "vmss"
  vnet_name    = "vnet-cloudinfra-nonprod-axso-e3og"
  vnet_rg_name = "rg-cloudinfra-nonprod-axso-ymiw"
}

# VMSS Authentication ------------------------------------------------------------------------------------------------------------------------------------------------ #

admin_username = "adminuser"

generate_admin_ssh_key = true

identity_type = "SystemAssigned, UserAssigned"

managed_identities = [
  {
    name                = "axso-np-appl-ssp-test-vmss-umid"
    resource_group_name = "axso-np-appl-ssp-test-rg"
  }
]

# VMSS Image --------------------------------------------------------------------------------------------------------------------------------------------------------- #

source_image = {
  offer     = "UbuntuServer"
  publisher = "Canonical"
  sku       = "18.04-LTS"
  version   = "latest"
}

# VMSS Disk ---------------------------------------------------------------------------------------------------------------------------------------------------------- #

os_disk_config = {
  caching              = "ReadWrite"
  storage_account_type = "Standard_LRS"
  disk_size_gb         = 30
}

enable_data_disk = true

data_disks = [
  {
    #name                 = "datadisk1"
    lun                  = 0
    caching              = "ReadWrite"
    disk_size_gb         = 30
    storage_account_type = "Standard_LRS"
  }
]

# Encryption --------------------------------------------------------------------------------------------------------------------------------------------------------- #

keyvault_details = {
  kv_name    = "kv-ssp-0-nonprod-axso"
  kv_rg_name = "axso-np-appl-ssp-test-rg"
}

# Extension ---------------------------------------------------------------------------------------------------------------------------------------------------------- #

extension_config = {
  enable                     = false
  name                       = ""
  publisher                  = ""
  type                       = ""
  type_handler_version       = ""
  auto_upgrade_minor_version = true
  settings                   = {}
}

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------- #