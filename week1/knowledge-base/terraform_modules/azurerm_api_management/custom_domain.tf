resource "azurerm_key_vault_access_policy" "keyvault" {
  count        = var.requires_custom_host_name_configuration ? 1 : 0
  key_vault_id = data.azurerm_key_vault.key_vault_certificate[0].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_api_management.apim.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

# APIM Custom Domain Configuration

resource "azurerm_api_management_custom_domain" "apim_domain" {

  count             = var.requires_custom_host_name_configuration ? 1 : 0
  api_management_id = azurerm_api_management.apim.id

  dynamic "developer_portal" {
    for_each = var.developer_portal_host_name != "" ? [1] : [0]
    content {
      host_name                    = var.developer_portal_host_name
      key_vault_id                 = data.azurerm_key_vault_certificate.cert[0].secret_id
      negotiate_client_certificate = false
    }
  }

  dynamic "management" {
    for_each = var.management_host_name != "" ? [1] : [0]
    content {
      host_name                    = var.management_host_name
      key_vault_id                 = data.azurerm_key_vault_certificate.cert[0].secret_id
      negotiate_client_certificate = false
    }
  }

  dynamic "gateway" {
    for_each = var.gateway_host_name != "" ? [1] : [0]
    content {
      host_name                    = var.gateway_host_name
      key_vault_id                 = data.azurerm_key_vault_certificate.cert[0].secret_id
      negotiate_client_certificate = true
    }
  }


  depends_on = [azurerm_api_management.apim, azurerm_key_vault_access_policy.keyvault]
}