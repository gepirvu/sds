locals {
  key_vault_name          = lower("axso-${substr(var.environment, 0, 4)}-${substr(var.project_name, 0, 3)}-kv-${var.kv_number}")
  private_dns_zone_id     = "/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/resourceGroups/rg-privatedns-pe-prod-axpo/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
  action_group_short_name = lower("${substr(var.environment, 0, 4)}${substr(var.project_name, 0, 3)}kv${var.kv_number}")
}