#----------------------------------------------------------------------------------------------------------------#
# Container app environment - infrastructure subnet information                                                  #
#----------------------------------------------------------------------------------------------------------------#

data "azurerm_subnet" "cae_subnet" {
  count                = var.infra_subnet_configs != null && length(var.infra_subnet_configs) > 0 ? 1 : 0
  name                 = var.infra_subnet_configs != null ? lookup(var.infra_subnet_configs, "infra_subnet_name", null) : null
  virtual_network_name = var.infra_subnet_configs != null ? lookup(var.infra_subnet_configs, "infra_vnet_name", null) : null
  resource_group_name  = var.infra_subnet_configs != null ? lookup(var.infra_subnet_configs, "infra_subnet_rg_name", null) : null

}

#----------------------------------------------------------------------------------------------------------------#
# Container app environment - Log analytics workspace information                                                #
#----------------------------------------------------------------------------------------------------------------#

data "azurerm_log_analytics_workspace" "law" {
  count               = var.log_analytics_workspace_name != null ? 1 : 0
  name                = var.log_analytics_workspace_name
  resource_group_name = var.resource_group_name
}

#----------------------------------------------------------------------------------------------------------------#
# Container app environment storage - storage account information                                                #
#----------------------------------------------------------------------------------------------------------------#

data "azurerm_storage_account" "sa" {
  for_each            = var.cae_storage_configs != null && var.cae_storage_configs != {} ? { for config in var.cae_storage_configs : config.storage_config_name => config } : {}
  name                = each.value.storage_account_name
  resource_group_name = each.value.storage_account_rg_name

  depends_on = [azurerm_container_app_environment.cae]
}

#----------------------------------------------------------------------------------------------------------------#
# Container app - User assigned identity information                                                             #
#----------------------------------------------------------------------------------------------------------------#

data "azurerm_user_assigned_identity" "umids" {
  for_each            = var.ca_umids != null && var.ca_umids != {} ? { for config in var.ca_umids : config.umid_name => config } : {}
  name                = each.value.umid_name
  resource_group_name = each.value.umid_rg_name
}

# Container app - User assigned identity information for ACR
data "azurerm_user_assigned_identity" "acr" {
  count               = var.container_registry_server != null ? 1 : 0
  name                = var.acr_umid_name
  resource_group_name = var.acr_umid_resource_group
}

#----------------------------------------------------------------------------------------------------------------#
# Container app Environment - Custom Certificate                                            #
#----------------------------------------------------------------------------------------------------------------#

data "azurerm_key_vault" "key_vault" {
  for_each            = var.cae_custom_certificates != null ? { for config in var.cae_custom_certificates : config.keyvault_certificate_name => config } : {}
  name                = each.value.key_vault_name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "key_vault_secret" {
  for_each     = var.cae_custom_certificates != null ? { for config in var.cae_custom_certificates : config.keyvault_certificate_name => config } : {}
  name         = each.value.keyvault_certificate_name
  key_vault_id = data.azurerm_key_vault.key_vault[each.value.keyvault_certificate_name].id
}

data "azurerm_key_vault" "key_vault_secrets" {
  count               = var.key_vault_name != null ? 1 : 0
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}
