module "cosmosdb" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_cosmosdb?ref=~{gitRef}~"

  cosmosdb_accounts                   = var.cosmosdb_accounts
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  subscription                        = var.subscription
  project_name                        = var.project_name
  environment                         = var.environment
  identity_type                       = var.identity_type
  default_identity_type               = var.default_identity_type
  umids_names                         = var.umids_names
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  key_vault_name                      = var.key_vault_name
  virtual_network_name                = var.virtual_network_name
  pe_subnet_name                      = var.pe_subnet_name
  cosmosdb_postgres                   = var.cosmosdb_postgres

}