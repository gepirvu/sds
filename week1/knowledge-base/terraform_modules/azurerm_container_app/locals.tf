locals {
  ca_env_name                                = lower("axso-${var.subscription}-appl-${substr(var.project_name, 0, 5)}-${var.environment}-${var.usecase}-cae")
  private_dns_resource_group_name            = "rg-privatedns-prod-axpo"
  private_endpoint_dns_resource_group_name   = "rg-privatedns-pe-prod-axpo"
  infrastructure_resource_group_name         = "ME_${local.ca_env_name}_${var.resource_group_name}_${var.location}"
  standard_private_dns_zone_westeurope       = "westeurope.azurecontainerapps.io"
  standard_private_dns_zone_northeurope      = "northeurope.azurecontainerapps.io"
  standard_private_dns_zone_switzerlandnorth = "switzerlandnorth.azurecontainerapps.io"
  standard_private_dns_zone_switzerlandwest  = "switzerlandwest.azurecontainerapps.io"

}


locals {
  standard_private_dns_zone = lookup({
    "westeurope "      = local.standard_private_dns_zone_westeurope,
    "northeurope"      = local.standard_private_dns_zone_northeurope,
    "switzerlandnorth" = local.standard_private_dns_zone_switzerlandnorth,
    "switzerlandwest"  = local.standard_private_dns_zone_switzerlandwest
  }, var.location, local.standard_private_dns_zone_westeurope)
}