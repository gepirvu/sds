module "axso_mssql_server" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_mssql_server?ref=~{gitRef}~"
  # naming_convention 
  project_name = var.project_name
  subscription = var.subscription
  environment  = var.environment

  # Server params
  location                                              = var.location
  server_version                                        = var.server_version
  threat_detection_policy                               = var.threat_detection_policy
  azurerm_mssql_server_vulnerability_assessment_enabled = var.azurerm_mssql_server_vulnerability_assessment_enabled

  # EntraID Administrator  
  resource_group_name         = var.resource_group_name
  login_username              = var.login_username
  mssql_administrator_group   = var.mssql_administrator_group
  key_vault_name              = var.key_vault_name
  azuread_authentication_only = var.azuread_authentication_only

  # Private endpoint
  network_resource_group_name = var.network_resource_group_name
  network_name                = var.virtual_network_name
  mssql_subnet_name           = var.mssql_subnet_name

  # vulnerability scan results and audit logs
  storage_account_name = var.storage_account_name
  email_accounts       = var.email_accounts

  # Create Elastic Pool (optional) with default values
  create_elastic_pool = var.create_elastic_pool
  elastic_pool_config = var.elastic_pool_config

  # MSSQL Databases
  mssql_databases = var.mssql_databases
}