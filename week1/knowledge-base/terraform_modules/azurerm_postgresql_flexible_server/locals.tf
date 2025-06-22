locals {
  pgsqlflexible_server_name = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-pgsql-flexi-server")
  pgsql_dns_id              = "/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/resourceGroups/rg-privatedns-pe-prod-axpo/providers/Microsoft.Network/privateDnsZones/privatelink.postgres.database.azure.com"
  udr_config = {
    routes = [
      {
        route_name     = "PSQL_AzureActiveDirectory"
        address_prefix = "AzureActiveDirectory"
        next_hop_type  = "Internet"
        next_hop_ip    = null
      },
      {
        route_name     = "PSQL_SUBNET_${var.psql_subnet_name}"
        address_prefix = data.azurerm_subnet.pgsql-subnet.address_prefixes[0]
        next_hop_type  = "VnetLocal"
        next_hop_ip    = null
      }
    ]
  }
} 