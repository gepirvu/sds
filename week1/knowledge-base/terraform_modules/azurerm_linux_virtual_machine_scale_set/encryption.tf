#----------------------------------------------------------------------------------------------------------------#
# Random String
#----------------------------------------------------------------------------------------------------------------#

resource "random_string" "string" {
  length      = 4
  upper       = false
  min_numeric = 1
  special     = false
}

#----------------------------------------------------------------------------------------------------------------#
# Disk Encryption Set
#----------------------------------------------------------------------------------------------------------------#

resource "azurerm_disk_encryption_set" "disk_encryption_set" {
  name                = local.disk_encryption_set_name
  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_key_id    = azurerm_key_vault_key.key_vault_key.versionless_id

  auto_key_rotation_enabled = true

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

#----------------------------------------------------------------------------------------------------------------#
# Disk Encryption Key
#----------------------------------------------------------------------------------------------------------------#


resource "azurerm_key_vault_key" "key_vault_key" {
  name            = local.disk_encryption_key_name
  key_vault_id    = local.key_vault_id
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

#----------------------------------------------------------------------------------------------------------------#
# Role Assignment for Disk Encryption Set
#----------------------------------------------------------------------------------------------------------------#

resource "azurerm_role_assignment" "kv_role_assignment" {
  scope                = local.key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_disk_encryption_set.disk_encryption_set.identity[0].principal_id
}

#----------------------------------------------------------------------------------------------------------------#