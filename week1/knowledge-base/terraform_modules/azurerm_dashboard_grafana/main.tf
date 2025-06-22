resource "azurerm_monitor_workspace" "monitor_workspace" {
  count                         = var.azure_monitor_workspace_name == null && var.azure_monitor_workspace_enabled == true ? 1 : 0
  name                          = local.monitor_workspace_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  public_network_access_enabled = var.monitor_workspace_public_network_access_enabled
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_endpoint" "private_endpoint_monitor_workspace" {
  depends_on          = [azurerm_monitor_workspace.monitor_workspace]
  count               = var.azure_monitor_workspace_name == null && var.azure_monitor_workspace_enabled == true ? 1 : 0
  name                = azurerm_monitor_workspace.monitor_workspace[0].name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "${azurerm_monitor_workspace.monitor_workspace[0].name}-pe-sc"
    private_connection_resource_id = azurerm_monitor_workspace.monitor_workspace[0].id
    is_manual_connection           = false
    subresource_names              = ["prometheusMetrics"]
  }

  private_dns_zone_group {
    name                 = "privatelink.westeurope.prometheus.monitor.azure.com"
    private_dns_zone_ids = [local.private_dns_zone_monitor_workspace_id]
  }
  lifecycle {
    ignore_changes = [tags]
  }
}


resource "azurerm_dashboard_grafana" "dashboard_grafana" {
  name                              = local.dashboard_grafana_name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  api_key_enabled                   = var.api_key_enabled
  deterministic_outbound_ip_enabled = var.deterministic_outbound_ip_enabled
  grafana_major_version             = var.grafana_major_version
  public_network_access_enabled     = false
  sku                               = var.sku
  zone_redundancy_enabled           = var.zone_redundancy_enabled

  dynamic "smtp" {
    for_each = var.smtp_enable == true ? [1] : []
    content {
      enabled                   = var.smtp_enable
      host                      = var.smtp_host
      user                      = var.smtp_user
      password                  = var.smtp_password
      start_tls_policy          = var.start_tls_policy
      from_address              = var.from_address
      from_name                 = var.from_name
      verification_skip_enabled = var.verification_skip_enabled
    }
  }

  dynamic "azure_monitor_workspace_integrations" {
    for_each = var.azure_monitor_workspace_enabled == true ? [1] : []
    content {
      resource_id = var.azure_monitor_workspace_name != null ? data.azurerm_monitor_workspace.monitor_workspace[0].id : azurerm_monitor_workspace.monitor_workspace[0].id
    }

  }
  identity {
    type         = var.identity_type
    identity_ids = var.identity_type == "SystemAssigned" ? [] : [azurerm_user_assigned_identity.user_assigned_identity[0].id]
  }

  lifecycle {
    ignore_changes = [tags]
  }

}

resource "azurerm_private_endpoint" "private_endpoint" {
  depends_on          = [azurerm_dashboard_grafana.dashboard_grafana]
  name                = azurerm_dashboard_grafana.dashboard_grafana.name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "${azurerm_dashboard_grafana.dashboard_grafana.name}-pe-sc"
    private_connection_resource_id = azurerm_dashboard_grafana.dashboard_grafana.id
    is_manual_connection           = false
    subresource_names              = ["grafana"]
  }

  private_dns_zone_group {
    name                 = "privatelink.grafana.azure.net"
    private_dns_zone_ids = [local.private_dns_zone_dashboard_grafana_id]
  }

  lifecycle {
    ignore_changes = [tags]
  }
}



resource "azurerm_role_assignment" "role_assignment_grafana_reader_monitor_workspace" {
  depends_on           = [azurerm_monitor_workspace.monitor_workspace]
  count                = var.azure_monitor_workspace_enabled == true ? 1 : 0
  scope                = var.azure_monitor_workspace_name == null ? azurerm_monitor_workspace.monitor_workspace[0].id : data.azurerm_monitor_workspace.monitor_workspace[0].id
  role_definition_name = "Monitoring Reader"
  principal_id         = var.identity_type == "SystemAssigned" ? azurerm_dashboard_grafana.dashboard_grafana.identity[0].principal_id : azurerm_user_assigned_identity.user_assigned_identity[0].principal_id
}

resource "azurerm_role_assignment" "role_assignment_grafana_data_reader_monitor_workspace" {
  depends_on           = [azurerm_monitor_workspace.monitor_workspace]
  count                = var.azure_monitor_workspace_enabled == true ? 1 : 0
  scope                = var.azure_monitor_workspace_name == null ? azurerm_monitor_workspace.monitor_workspace[0].id : data.azurerm_monitor_workspace.monitor_workspace[0].id
  role_definition_name = "Monitoring Data Reader"
  principal_id         = var.identity_type == "SystemAssigned" ? azurerm_dashboard_grafana.dashboard_grafana.identity[0].principal_id : azurerm_user_assigned_identity.user_assigned_identity[0].principal_id
}



