module "logicapp_standard" {
  source                = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_logic_app_standard?ref=~{gitRef}~"
  resource_group_name   = var.resource_group_name
  logic_app             = var.logic_app
  project_name          = var.project_name
  subscription          = var.subscription
  environment           = var.environment
  location              = var.location
  service_plan_sku_name = var.service_plan_sku_name
  service_plan_os_type  = var.service_plan_os_type
  service_plan_usage    = var.service_plan_usage
  vnet_pe_id            = data.azurerm_subnet.pe_subnet.id

  logic_app_storage_account_name = var.logic_app_storage_account_name
  logic_app_storage_account_key  = data.azurerm_storage_account.sa.primary_access_key

  virtual_network_subnet_id = data.azurerm_subnet.vint_subnet.id

  user_managed_identities = [data.azurerm_user_assigned_identity.identity.id]

}



