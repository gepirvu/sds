
module "axso_data_factory" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_data_factory?ref=~{gitRef}~"
  # General
  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_name      = var.key_vault_name

  # Naming convention
  subscription = var.subscription
  project_name = var.project_name
  environment  = var.environment

  identity_type = var.identity_type
  umids_names   = var.umids_names

  managed_virtual_network_enabled     = var.managed_virtual_network_enabled
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  virtual_network_name                = var.virtual_network_name
  pe_subnet_name                      = var.pe_subnet_name

  global_parameters  = var.global_parameters
  vsts_configuration = var.vsts_configuration

  purview_id = var.purview_id

  azure_integration_runtimes       = var.azure_integration_runtimes
  self_hosted_integration_runtimes = var.self_hosted_integration_runtimes

}