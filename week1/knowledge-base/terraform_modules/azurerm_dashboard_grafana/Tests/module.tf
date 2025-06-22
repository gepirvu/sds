module "axso_dashboard_grafana" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_dashboard_grafana?ref=~{gitRef}~"

  resource_group_name                             = var.resource_group_name
  location                                        = var.location
  project_name                                    = var.project_name
  subscription                                    = var.subscription
  environment                                     = var.environment
  network_resource_group_name                     = var.network_resource_group_name
  virtual_network_name                            = var.virtual_network_name
  monitor_workspace_public_network_access_enabled = var.monitor_workspace_public_network_access_enabled
  pe_subnet_name                                  = var.pe_subnet_name
  api_key_enabled                                 = var.api_key_enabled
  grafana_major_version                           = var.grafana_major_version
  sku                                             = var.sku
  zone_redundancy_enabled                         = var.zone_redundancy_enabled
  deterministic_outbound_ip_enabled               = var.deterministic_outbound_ip_enabled
  smtp_enable                                     = var.smtp_enable
  identity_type                                   = var.identity_type
  azure_monitor_workspace_enabled                 = var.azure_monitor_workspace_enabled
  admin_groups                                    = var.admin_groups
  editor_groups                                   = var.editor_groups
  viewer_groups                                   = var.viewer_groups

}