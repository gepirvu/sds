locals {
  app_conf_name       = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-app-conf")
  cmk_name            = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-app-conf-cmk-${random_string.cmk_suffix.result}")
  private_dns_zone_id = "/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/resourceGroups/rg-privatedns-pe-prod-axpo/providers/Microsoft.Network/privateDnsZones/privatelink.azconfig.io"
} 