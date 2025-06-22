data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "key_vault" {
  count               = var.key_vault_name != null ? 1 : 0
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "key_vault_secrets" {
  for_each     = { for named_value in var.keyvault_named_values : named_value.name => named_value }
  name         = each.value.value # Use the "value" attribute from each named value
  key_vault_id = data.azurerm_key_vault.key_vault[0].id
}

data "azurerm_key_vault" "key_vault_certificate" {
  count               = var.requires_custom_host_name_configuration ? 1 : 0
  name                = var.wildcard_certificate_key_vault_name
  resource_group_name = var.wildcard_certificate_key_vault_resource_group_name
}

data "azurerm_application_insights" "app_insights" {
  count               = var.app_insights_name != null ? 1 : 0
  name                = var.app_insights_name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_certificate" "cert" {
  count        = var.requires_custom_host_name_configuration ? 1 : 0
  name         = var.wildcard_certificate_name
  key_vault_id = data.azurerm_key_vault.key_vault_certificate[0].id
}

data "azurerm_subnet" "subnet" {
  for_each             = toset(var.subnet_names)
  name                 = each.value
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.virtual_network_resource_group_name
}
