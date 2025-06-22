locals {
  monitor_workspace_name                = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-mws")
  dashboard_grafana_name                = lower("axso4${var.subscription}4${substr(var.environment, 0, 4)}4${substr(var.project_name, 0, 6)}4amg")
  user_assigned_identity_name           = lower("${local.dashboard_grafana_name}-identity")
  private_dns_zone_dashboard_grafana_id = "/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/resourceGroups/rg-privatedns-pe-prod-axpo/providers/Microsoft.Network/privateDnsZones/privatelink.grafana.azure.com"
  private_dns_zone_monitor_workspace_id = "/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/resourceGroups/rg-privatedns-pe-prod-axpo/providers/Microsoft.Network/privateDnsZones/privatelink.westeurope.prometheus.monitor.azure.com"
}

