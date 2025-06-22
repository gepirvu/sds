resource "azurerm_managed_disk" "disk" {
  depends_on = [azurerm_role_assignment.role_assignment]

  for_each = var.storage_data_disk_config

  location            = var.location
  resource_group_name = var.resource_group_name

  name = "${local.vm_data_disk_name}-${format("%03d", index(keys(var.storage_data_disk_config), each.key) + 1)}"
  zone = can(regex("_zrs$", lower(each.value.storage_account_type))) ? null : var.zone_id

  storage_account_type   = each.value.storage_account_type
  create_option          = each.value.create_option
  disk_size_gb           = each.value.disk_size_gb
  source_resource_id     = contains(["Copy", "Restore"], each.value.create_option) ? each.value.source_resource_id : null
  disk_encryption_set_id = azurerm_disk_encryption_set.disk_encryption_set.id
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attachment" {
  for_each = var.storage_data_disk_config

  managed_disk_id    = azurerm_managed_disk.disk[each.key].id
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id

  lun     = coalesce(each.value.lun, index(keys(var.storage_data_disk_config), each.key))
  caching = each.value.caching
}
#Encrypting the data disk
resource "azurerm_disk_encryption_set" "disk_encryption_set" {
  name                = local.disk_encryption_set_name
  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_key_id    = azurerm_key_vault_key.key_vault_key.versionless_id

  auto_key_rotation_enabled = true

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_key_vault_key" "key_vault_key" {
  name            = local.disk_encryption_key_name
  key_vault_id    = data.azurerm_key_vault.key_vault.id
  key_type        = "RSA"
  key_size        = 2048
  expiration_date = local.expiration_date
  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }
    expire_after         = "P365D"
    notify_before_expiry = "P45D"
  }

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  lifecycle {
    ignore_changes = [
      expiration_date, tags
    ]
  }

}

resource "azurerm_role_assignment" "role_assignment" {
  scope                = data.azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_disk_encryption_set.disk_encryption_set.identity.0.principal_id
}

resource "azurerm_key_vault_access_policy" "key_vault_access_policy" {
  count        = var.keyvault_rbac ? 0 : 1
  key_vault_id = data.azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_disk_encryption_set.disk_encryption_set.identity.0.principal_id

  key_permissions = [
    "Get", "UnwrapKey", "WrapKey"
  ]
}
