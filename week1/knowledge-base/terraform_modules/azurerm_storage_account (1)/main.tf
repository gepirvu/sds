resource "azurerm_key_vault_key" "key_vault_key" {
  name            = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-sta-${random_string.cmk_suffix.result}")
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

resource "azurerm_role_assignment" "role_assignment_identity" {
  scope                = azurerm_key_vault_key.key_vault_key.resource_versionless_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = data.azurerm_user_assigned_identity.umids[keys(data.azurerm_user_assigned_identity.umids)[0]].principal_id
}

# Sleep for RBACs to take effect

resource "time_sleep" "rbac_sleep" {
  create_duration = "120s"
  depends_on      = [azurerm_role_assignment.role_assignment_identity]
}

resource "azurerm_storage_account" "storage_account" {
  name                              = local.storage_account_name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  account_tier                      = var.account_tier_storage
  access_tier                       = var.access_tier_storage
  account_replication_type          = var.account_replication_type_storage
  account_kind                      = var.account_kind_storage
  is_hns_enabled                    = var.is_hns_enabled
  allow_nested_items_to_be_public   = false
  https_traffic_only_enabled        = true
  min_tls_version                   = "TLS1_2"
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = var.public_network_access_enabled
  shared_access_key_enabled         = false
  nfsv3_enabled                     = var.nfsv3_enabled
  local_user_enabled                = false

  dynamic "blob_properties" {
    for_each = var.delete_retention_policy_days > 0 ? [1] : []
    content {

      dynamic "delete_retention_policy" {
        for_each = var.delete_retention_policy_days > 0 ? [1] : []
        content {
          days = var.delete_retention_policy_days
        }
      }
    }
  }

  dynamic "network_rules" {
    for_each = var.net_rules != null ? [var.net_rules] : []
    content {
      default_action             = network_rules.value.default_action
      bypass                     = network_rules.value.bypass
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids
    }
  }

  customer_managed_key {
    key_vault_key_id          = azurerm_key_vault_key.key_vault_key.versionless_id
    user_assigned_identity_id = data.azurerm_user_assigned_identity.umids[keys(data.azurerm_user_assigned_identity.umids)[0]].id

  }

  dynamic "identity" {
    for_each = var.identity_type == null ? [] : ["enabled"]
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "SystemAssigned, UserAssigned" || var.identity_type == "UserAssigned" ? [for identity in data.azurerm_user_assigned_identity.umids : identity.id] : []
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }

  depends_on = [time_sleep.rbac_sleep]

}

# Create private based on the storage type
resource "azurerm_private_endpoint" "private_endpoint" {
  for_each            = toset(local.storage_types)
  name                = "${azurerm_storage_account.storage_account.name}-${each.value}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.sa_subnet.id

  private_service_connection {
    name                           = "${azurerm_storage_account.storage_account.name}-${each.value}-pe-sc"
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    is_manual_connection           = false
    subresource_names              = [each.value]
  }

  private_dns_zone_group {
    name                 = "privatelink.${each.value}.windows.net"
    private_dns_zone_ids = ["${local.private_dns_zone_id}.${each.value}.core.windows.net"]
  }

  lifecycle {
    ignore_changes = [tags]
  }

}

# Create containers (optional)
resource "azurerm_storage_container" "storage_container" {
  for_each              = toset(var.container_names)
  name                  = lower(each.key)
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
  depends_on            = [azurerm_private_endpoint.private_endpoint]
}
