resource "azurerm_role_assignment" "rbac_keyvault_administrator" {
  for_each             = toset(var.admin_groups)
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_group.rbac_keyvault_administrator[each.key].object_id
}

resource "azurerm_role_assignment" "rbac_keyvault_secrets_users" {
  for_each             = toset(var.reader_groups)
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azuread_group.rbac_keyvault_reader[each.key].object_id
}

resource "azurerm_role_assignment" "rbac_keyvault_reader" {
  for_each             = toset(var.reader_groups)
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Reader"
  principal_id         = data.azuread_group.rbac_keyvault_reader[each.key].object_id
}

resource "azurerm_role_assignment" "rbac_keyvault_administrator_spi" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current_config.object_id
}

