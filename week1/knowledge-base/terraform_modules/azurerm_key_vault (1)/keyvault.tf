

resource "azurerm_key_vault" "keyvault" {
  name = local.key_vault_name

  location            = var.location
  resource_group_name = var.resource_group_name

  tenant_id = data.azurerm_client_config.current_config.tenant_id

  sku_name = var.sku_name

  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment

  purge_protection_enabled   = true
  soft_delete_retention_days = var.soft_delete_retention_days

  enable_rbac_authorization = true

  public_network_access_enabled = var.public_network_access_enabled

  dynamic "network_acls" {
    for_each = var.network_acls == null ? [] : [var.network_acls]
    iterator = acl
    content {
      bypass                     = acl.value.bypass
      default_action             = acl.value.default_action
      ip_rules                   = acl.value.ip_rules
      virtual_network_subnet_ids = acl.value.virtual_network_subnet_ids
    }
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}



resource "azurerm_private_endpoint" "private_endpoint" {
  name                = azurerm_key_vault.keyvault.name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.sa_subnet.id

  private_service_connection {
    name                           = "${azurerm_key_vault.keyvault.name}-pe-sc"
    private_connection_resource_id = azurerm_key_vault.keyvault.id
    is_manual_connection           = false
    subresource_names              = ["Vault"]
  }

  private_dns_zone_group {
    name                 = "privatelink.vaultcore.azure.net"
    private_dns_zone_ids = [local.private_dns_zone_id]
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}

resource "azurerm_monitor_diagnostic_setting" "monitor_diagnostic_setting" {
  name                       = "keyvault-loga"
  target_resource_id         = azurerm_key_vault.keyvault.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics_workspace[0].id

  enabled_log {
    category = "AuditEvent"
  }

  metric {
    category = "AllMetrics"
  }
}

resource "time_sleep" "wait_120_seconds" {
  depends_on = [azurerm_private_endpoint.private_endpoint]

  create_duration = "120s"
}

resource "azurerm_monitor_action_group" "monitor_action_group" {
  name                = "${azurerm_key_vault.keyvault.name}-actiongroup"
  resource_group_name = var.resource_group_name
  short_name          = local.action_group_short_name

  dynamic "email_receiver" {
    for_each = var.email_receiver
    content {
      name                    = split("@", email_receiver.value)[0]
      email_address           = email_receiver.value
      use_common_alert_schema = true
    }

  }

  dynamic "webhook_receiver" {
    for_each = var.webhook_receiver
    content {
      name                    = webhook_receiver.value.name
      service_uri             = webhook_receiver.value.service_uri
      use_common_alert_schema = true
    }
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}


resource "azurerm_monitor_scheduled_query_rules_alert_v2" "monitor_scheduled_query_rules_alert_v2" {
  count               = var.expire_notification ? 1 : 0
  name                = "${azurerm_key_vault.keyvault.name}-SecretExpiryNotification"
  resource_group_name = var.resource_group_name
  location            = var.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [azurerm_key_vault.keyvault.id]
  severity             = 3
  criteria {
    query                   = <<-QUERY
      AzureDiagnostics
      | where OperationName contains "SecretNearExpiry"
      or OperationName contains "SecretExpired"
      or OperationName contains "CertificateNearExpiry"
      or OperationName contains "CertificateExpired"
      or OperationName contains "KeyNearExpiry"
      or OperationName contains "KeyExpired"
      | project
      SecretName = iff((isnotempty(eventGridEventProperties_data_ObjectName_s) == true), eventGridEventProperties_data_ObjectName_s, ""),
      TimeGenerated = iff((isnotempty(eventGridEventProperties_data_ObjectName_s) == true), TimeGenerated, datetime(null))
      | where     isnotnull(TimeGenerated)
      QUERY
    time_aggregation_method = "Count"
    threshold               = 1
    operator                = "GreaterThanOrEqual"

    dimension {
      name     = "SecretName"
      operator = "Include"
      values   = ["*"]
    }
    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  auto_mitigation_enabled          = true
  workspace_alerts_storage_enabled = false
  description                      = "SecretExpiryNotification"
  display_name                     = "SecretExpiryNotification"
  enabled                          = true
  skip_query_validation            = true
  action {
    action_groups = [azurerm_monitor_action_group.monitor_action_group.id]
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

  depends_on = [time_sleep.wait_120_seconds]

}