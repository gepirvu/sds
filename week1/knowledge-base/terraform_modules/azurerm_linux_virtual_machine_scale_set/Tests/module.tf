#-----------------------------------------------------------------------------------------------------------------------------------------------#
# Linux Virtual Machine Scale Set
#-----------------------------------------------------------------------------------------------------------------------------------------------#

module "axso_linux_vmss" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_linux_virtual_machine_scale_set?ref=~{gitRef}~"

  # Naming convention
  project_name = var.project_name
  subscription = var.subscription
  environment  = var.environment
  usecase      = var.usecase

  # VMSS properties
  resource_group_name = var.resource_group_name
  location            = var.location
  linux_vmss_sku      = var.linux_vmss_sku
  instances           = var.instances
  overprovision       = var.overprovision
  os_upgrade_mode     = var.os_upgrade_mode
  availability_zones  = var.availability_zones
  source_image_id     = var.source_image_id

  # VMSS Network
  dns_servers = var.dns_servers
  vmss_subnet = var.vmss_subnet

  # VMSS Authentication
  admin_username         = var.admin_username
  admin_ssh_key_data     = var.admin_ssh_key_data
  generate_admin_ssh_key = var.generate_admin_ssh_key
  identity_type          = var.identity_type
  managed_identities     = var.managed_identities

  # VMSS Image
  source_image = var.source_image

  # VMSS Disk
  os_disk_config   = var.os_disk_config
  enable_data_disk = var.enable_data_disk
  data_disks       = var.enable_data_disk ? var.data_disks : []

  # Keyvault
  keyvault_details = var.keyvault_details

  # Extension
  extension_config = var.extension_config
}

#-----------------------------------------------------------------------------------------------------------------------------------------------#