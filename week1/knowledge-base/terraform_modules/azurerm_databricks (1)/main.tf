resource "azurerm_key_vault_key" "notebooks_key" {
  name            = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-adbntb-cmk-${random_string.cmk_suffix.result}")
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

resource "azurerm_key_vault_key" "disks_key" {
  name            = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-adbdsk-cmk-${random_string.cmk_suffix.result}")
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

resource "azurerm_key_vault_key" "dbfs_key" {
  name            = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-adbdfs-cmk-${random_string.cmk_suffix.result}")
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

resource "azurerm_role_assignment" "role_assignment_databricks" {
  scope                = data.azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = data.azuread_service_principal.databricks_spn.object_id
}

resource "azurerm_role_assignment" "role_assignment_identity" {
  scope                = data.azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = data.azurerm_user_assigned_identity.umids[tolist(var.umids_names)[0]].principal_id
}

resource "azurerm_role_assignment" "role_assignment_adbfs" {
  scope                = data.azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_databricks_workspace.databricks_workspace.storage_account_identity[0].principal_id
}

# Sleep for RBACs to take effect

resource "time_sleep" "rbac_sleep" {
  create_duration = "120s"
  depends_on      = [azurerm_role_assignment.role_assignment_identity, azurerm_role_assignment.role_assignment_databricks]
}

resource "azurerm_databricks_access_connector" "databricks_access_connector" {
  name                = "${local.adb_name}-ac"
  resource_group_name = var.resource_group_name
  location            = var.location

  dynamic "identity" {
    for_each = var.identity_type == null ? [] : ["enabled"]
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" || var.identity_type == "SystemAssigned,UserAssigned" ? [for identity in data.azurerm_user_assigned_identity.umids : identity.id] : []
    }
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}


resource "azurerm_databricks_workspace_root_dbfs_customer_managed_key" "databricks_workspace_root_dbfs_customer_managed_key" {
  depends_on = [azurerm_role_assignment.role_assignment_adbfs]

  workspace_id     = azurerm_databricks_workspace.databricks_workspace.id
  key_vault_key_id = azurerm_key_vault_key.dbfs_key.id
}


resource "azurerm_databricks_workspace" "databricks_workspace" {
  name                = local.adb_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  access_connector_id = azurerm_databricks_access_connector.databricks_access_connector.id


  managed_services_cmk_key_vault_key_id               = azurerm_key_vault_key.notebooks_key.id
  managed_disk_cmk_key_vault_key_id                   = azurerm_key_vault_key.disks_key.id
  managed_disk_cmk_rotation_to_latest_version_enabled = true
  customer_managed_key_enabled                        = var.sku == "premium" ? true : false
  infrastructure_encryption_enabled                   = var.sku == "premium" ? true : false

  public_network_access_enabled         = var.frotend_private_access_enabled == false ? true : false
  default_storage_firewall_enabled      = true
  network_security_group_rules_required = "NoAzureDatabricksRules"



  custom_parameters {
    virtual_network_id                                   = data.azurerm_virtual_network.virtual_network.id
    public_subnet_name                                   = var.public_subnet_name
    private_subnet_name                                  = var.private_subnet_name
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.public_subnet_network_security_group_association.id
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.private_subnet_network_security_group_association.id
    storage_account_sku_name                             = var.storage_account_sku_name
    storage_account_name                                 = local.storage_account_name


  }


  lifecycle {
    ignore_changes = [
      tags
    ]
  }
  depends_on = [time_sleep.rbac_sleep]
}


resource "azurerm_role_assignment" "role_assignment_des" {
  # count                = azurerm_databricks_workspace.databricks_workspace.disk_encryption_set_id != null ? 1 : 0
  scope                = data.azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_databricks_workspace.databricks_workspace.managed_disk_identity[0].principal_id
}


# Private Endpoints

# Sleep for the cluster status ready

resource "time_sleep" "status_sleep" {
  create_duration = "90s"
  depends_on      = [azurerm_databricks_workspace.databricks_workspace]
}


resource "azurerm_private_endpoint" "api_pe" {

  name                = "${azurerm_databricks_workspace.databricks_workspace.name}-api-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.pe_subnets.id

  private_service_connection {
    name                           = "${azurerm_databricks_workspace.databricks_workspace.name}-pe-sc"
    private_connection_resource_id = azurerm_databricks_workspace.databricks_workspace.id
    is_manual_connection           = false
    subresource_names              = ["databricks_ui_api"] # Adjust this based on your CosmosDB type
  }

  # Creating the private_dns_zone_group for each DNS zone
  private_dns_zone_group {
    name                 = "${azurerm_databricks_workspace.databricks_workspace.name}-dns-zone-group"
    private_dns_zone_ids = [local.adbdnsid]
  }
  lifecycle {
    ignore_changes = [tags]
  }
  depends_on = [time_sleep.status_sleep]

}

resource "azurerm_private_endpoint" "dbfs_blob" {

  name                = "${azurerm_databricks_workspace.databricks_workspace.name}-blob-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.pe_subnets.id

  private_service_connection {
    name                           = "${azurerm_databricks_workspace.databricks_workspace.name}-pe-blob-sc"
    private_connection_resource_id = local.storage_account_id
    is_manual_connection           = false
    subresource_names              = ["blob"] # Adjust this based on your CosmosDB type
  }

  # Creating the private_dns_zone_group for each DNS zone
  private_dns_zone_group {
    name                 = "${azurerm_databricks_workspace.databricks_workspace.name}-blob-dns-zone-group"
    private_dns_zone_ids = [local.blobdnsid]
  }
  lifecycle {
    ignore_changes = [tags]
  }
  depends_on = [time_sleep.status_sleep]

}

resource "azurerm_private_endpoint" "dbfs_dfs" {

  name                = "${azurerm_databricks_workspace.databricks_workspace.name}-dfs-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.pe_subnets.id

  private_service_connection {
    name                           = "${azurerm_databricks_workspace.databricks_workspace.name}-pe-dfs-sc"
    private_connection_resource_id = local.storage_account_id
    is_manual_connection           = false
    subresource_names              = ["dfs"] # Adjust this based on your CosmosDB type
  }

  # Creating the private_dns_zone_group for each DNS zone
  private_dns_zone_group {
    name                 = "${azurerm_databricks_workspace.databricks_workspace.name}-dfs-dns-zone-group"
    private_dns_zone_ids = [local.dfsdnsid]
  }
  lifecycle {
    ignore_changes = [tags]
  }
  depends_on = [time_sleep.status_sleep]

}
