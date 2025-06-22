resource "random_string" "password" {
  count            = var.ssh_public_key == null ? 1 : 0
  length           = 16
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  override_special = "'()/|"

}

resource "azurerm_key_vault_secret" "vm_secret" {
  count           = var.ssh_public_key == null ? 1 : 0
  name            = replace("${local.vm_name}-password-${random_string.string.result}", "_", "-")
  value           = random_string.password[count.index].result
  key_vault_id    = data.azurerm_key_vault.key_vault.id
  expiration_date = local.expiration_date
  lifecycle {
    ignore_changes = [
      expiration_date, tags
    ]
  }
}

resource "azurerm_key_vault_secret" "vm_user" {
  name            = replace("${local.vm_name}-username-${random_string.string.result}", "_", "-")
  value           = var.admin_username
  key_vault_id    = data.azurerm_key_vault.key_vault.id
  expiration_date = local.expiration_date
  lifecycle {
    ignore_changes = [
      expiration_date, tags
    ]
  }
}
