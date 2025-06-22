resource "random_string" "password" {
  length           = 16
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  override_special = "'()/|"
}

resource "azurerm_key_vault_secret" "vm_secret" {
  name            = replace("${local.vm_name}-password-${random_string.string.result}", "_", "-")
  value           = random_string.password.result
  key_vault_id    = data.azurerm_key_vault.key_vault.id
  expiration_date = local.expiration_date
  lifecycle {
    ignore_changes = [
      expiration_date, tags
    ]
  }
}

