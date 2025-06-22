#-----------------------------------------#
# Azure container app environment storage #
#-----------------------------------------#

resource "azurerm_container_app_environment_storage" "cae_storage" {
  for_each                     = var.cae_storage_configs != null && var.cae_storage_configs != {} ? { for config in var.cae_storage_configs : config.storage_config_name => config } : {}
  name                         = each.value.storage_config_name
  container_app_environment_id = azurerm_container_app_environment.cae.id
  account_name                 = each.value.storage_account_name
  share_name                   = each.value.share_name
  access_key                   = data.azurerm_storage_account.sa[each.value.storage_config_name].primary_access_key
  access_mode                  = each.value.access_mode

  depends_on = [azurerm_container_app_environment.cae, time_sleep.wait_30_seconds]
}

#-----------------------------------------#