# Purpose: To defining the local values to use in the configuration such as naming conventions, private endpoints, etc.
locals {
  app_service_plan_name = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-asp")
  function_app_name     = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-func")
  private_dns_zone_id   = "/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/resourceGroups/rg-privatedns-pe-prod-axpo/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"
}