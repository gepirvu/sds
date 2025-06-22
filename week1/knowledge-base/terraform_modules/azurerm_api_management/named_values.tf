resource "azurerm_api_management_named_value" "keyvault_named_values" {
  for_each            = { for named_value in var.keyvault_named_values : named_value["name"] => named_value }
  api_management_name = azurerm_api_management.apim.name
  display_name        = lookup(each.value, "display_name", each.value["name"])
  name                = each.value["name"]
  resource_group_name = var.resource_group_name
  secret              = lookup(each.value, "secret", false)
  value_from_key_vault {
    secret_id = data.azurerm_key_vault_secret.key_vault_secrets[each.key].id
  }
  depends_on = [azurerm_role_assignment.keyvault_role_assignment]
}

resource "azurerm_api_management_named_value" "named_values" {
  for_each            = { for named_value in var.named_values : named_value["name"] => named_value }
  api_management_name = azurerm_api_management.apim.name
  display_name        = lookup(each.value, "display_name", each.value["name"])
  name                = each.value["name"]
  resource_group_name = var.resource_group_name
  value               = each.value["value"]
  secret              = lookup(each.value, "secret", false)
}

resource "azurerm_role_assignment" "keyvault_role_assignment" {
  count                = length(var.keyvault_named_values) > 0 ? 1 : 0
  scope                = data.azurerm_key_vault.key_vault[0].id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_api_management.apim.identity[0].principal_id
}