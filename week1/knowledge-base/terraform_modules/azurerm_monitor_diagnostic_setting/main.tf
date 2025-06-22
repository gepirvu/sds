terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.40"
    }
  }
}

# Retrieve Log Analytics
data "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.loga_resource_group_name
}

# Diagnostic Settings to manage logs for target resource for example, Firewall, Key Vault etc.
resource "azurerm_monitor_diagnostic_setting" "logs_for_target_resource" {
  name                           = var.diagnostic_setting_name
  target_resource_id             = var.target_resource_id
  log_analytics_workspace_id     = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
  log_analytics_destination_type = var.log_analytics_destination_type

  dynamic "log" {
    for_each = [for l in var.logs : {
      category          = l.category
      logs_enabled      = l.logs_enabled
      retention_enabled = l.retention_enabled
      days              = l.days
    } if l.is_log_block == true]

    content {
      category = log.value.category
      enabled  = log.value.logs_enabled
      retention_policy {
        enabled = log.value.retention_enabled
        days    = log.value.days
      }
    }
  }

  dynamic "metric" {
    for_each = [for m in var.logs : {
      category          = m.category
      logs_enabled      = m.logs_enabled
      retention_enabled = m.retention_enabled
      days              = m.days
    } if m.is_log_block == false]

    content {
      category = metric.value.category
      enabled  = metric.value.logs_enabled
      retention_policy {
        enabled = metric.value.retention_enabled
        days    = metric.value.days
      }
    }
  }
}