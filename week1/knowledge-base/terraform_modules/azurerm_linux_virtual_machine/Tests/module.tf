
module "vm" {
  for_each                    = { for each in var.vm_config : each.vm_number => each }
  source                      = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_linux_virtual_machine?ref=~{gitRef}~"
  subscription                = var.subscription
  project_name                = var.project_name
  environment                 = var.environment
  resource_group_name         = var.resource_group_name
  location                    = var.location
  vm_image                    = var.vm_image
  virtual_network_name        = var.virtual_network_name
  network_resource_group_name = var.network_resource_group_name
  subnet_name                 = var.subnet_name
  vm_size                     = each.value.vm_size
  vm_number                   = each.value.vm_number
  admin_username              = each.value.admin_username
  storage_data_disk_config    = each.value.storage_data_disk_config
  key_vault_name              = var.key_vault_name
  zone_id                     = each.value.zone_id
}




