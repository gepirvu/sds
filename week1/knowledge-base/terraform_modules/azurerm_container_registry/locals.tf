locals {
  acr_name            = lower("axso4${var.subscription}4${var.project_name}4${var.environment}4acr")
  private_dns_zone_id = "/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/resourceGroups/rg-privatedns-pe-prod-axpo/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io"

  acr_ip_rules = [for address_range in var.allowed_ip_ranges : {
    action   = "Allow"
    ip_range = address_range
    }
  ]

  acr_virtual_network_subnets = [for subnet_name, subnet_config in var.acr_allowed_subnets : {
    action    = "Allow"
    subnet_id = data.azurerm_subnet.acr_allowed_subnets[subnet_name].id
    }
  ]

} 