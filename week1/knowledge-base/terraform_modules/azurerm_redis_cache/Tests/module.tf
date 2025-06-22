#-------------------------------------------------------------------------------------------------------------------#
# Redis                                                                                                             #
#-------------------------------------------------------------------------------------------------------------------#

module "axso_redis_cache" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_redis_cache?ref=~{gitRef}~"

  # General
  resource_group_name = var.resource_group_name
  location            = var.location

  # Naming Convention
  subscription = var.subscription
  project_name = var.project_name
  environment  = var.environment

  # Pricing
  capacity = var.capacity
  family   = var.family
  sku_name = var.sku_name

  # Network
  pe_subnet_details = var.pe_subnet_details
  redis_fw_rules    = var.redis_fw_rules

  # Patching - The Patch Window lasts for 5 hours from the start_hour_utc.
  enable_patching = var.enable_patching
  day_of_week     = var.enable_patching ? var.day_of_week : null
  start_hour_utc  = var.enable_patching ? var.start_hour_utc : null

  # Authentication
  access_keys_authentication_enabled = var.access_keys_authentication_enabled
  identity_type                      = var.identity_type
  redis_umids                        = var.redis_umids
}

#-------------------------------------------------------------------------------------------------------------------#