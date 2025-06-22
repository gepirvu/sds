locals {
  serviceplan_name    = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-${var.service_plan_os_type}-${var.service_plan_usage}-asp")
  private_dns_zone_id = "/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/resourceGroups/rg-privatedns-pe-prod-axpo/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"

}