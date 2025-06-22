locals {
  data_factory_name     = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-adf")
  data_factory_key_name = "${local.data_factory_name}-key"

  private_dns_zone_id = "/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/resourceGroups/rg-privatedns-pe-prod-axpo/providers/Microsoft.Network/privateDnsZones/privatelink.datafactory.azure.net"


  days_to_hours = 365 * 24
  // expiration date need to be in a specific format as well
  expiration_date = timeadd(formatdate("YYYY-MM-DD'T'HH:mm:ssZ", timestamp()), "${local.days_to_hours}h")
}