# Networking
data "azurerm_subnet" "vint_subnets" {
  name                 = var.vint_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.network_resource_group_name
}

data "azurerm_subnet" "pe_subnets" {
  name                 = var.pe_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.network_resource_group_name
}

data "azurerm_container_registry" "acr_id" {
  count               = var.acr_name != null ? 1 : 0
  name                = var.acr_name
  resource_group_name = var.resource_group_name
}

data "azurerm_user_assigned_identity" "webapp_umids" {
  for_each            = toset(var.umids)
  name                = each.value
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault" "webapp_cert_key_vault" {
  count               = var.webapp_custom_certificates_key_vault != null ? 1 : 0
  name                = var.webapp_custom_certificates_key_vault
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "key_vault_secret" {
  for_each     = { for webapp_certificate_friendly_name, config in var.webapp_custom_certificates : config.keyvault_certificate_name => config }
  name         = each.key
  key_vault_id = data.azurerm_key_vault.webapp_cert_key_vault[0].id
}

data "azuread_service_principal" "MicrosoftWebApp" {
  client_id = "abfa0a7c-a6b6-4736-8310-5855508787cd"
}