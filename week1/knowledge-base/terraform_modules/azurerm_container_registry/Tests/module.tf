#===========================================================================================================================================#
# Container Registry                                                                                                                        #
#===========================================================================================================================================#

module "axso_container_registry" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_container_registry?ref=~{gitRef}~"

  resource_group_name = var.resource_group_name
  location            = var.location

  project_name             = var.project_name
  subscription             = var.subscription
  environment              = var.environment
  admin_enabled            = var.admin_enabled
  retention_policy_in_days = var.retention_policy_in_days
  data_endpoint_enabled    = var.data_endpoint_enabled
  # Identity
  identity_type = var.identity_type
  acr_umids     = var.acr_umids

  # Networking
  pe_subnet                     = var.pe_subnet
  allowed_ip_ranges             = var.allowed_ip_ranges
  acr_allowed_subnets           = var.acr_allowed_subnets
  public_network_access_enabled = var.public_network_access_enabled

  # Georeplication
  georeplications_configuration = var.georeplications_configuration

}

#============================================================================================================================================