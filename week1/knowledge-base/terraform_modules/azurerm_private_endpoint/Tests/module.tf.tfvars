
#common variables
private_dns_zone_name               = "privatelink.vaultcore.azure.net"
private_endpoint_name               = "kv-ssp-0-nonprod-axso-pe-2"
resource_group_name                 = "axso-np-appl-ssp-test-rg"
virtual_network_resource_group_name = "rg-cloudinfra-nonprod-axso-ymiw"
virtual_network_name                = "vnet-cloudinfra-nonprod-axso-e3og"
pe_subnet_name                      = "pe"
private_dns_zone_group = [
  {
    enabled              = false
    name                 = "privatelink.vaultcore.azure.net"
    private_dns_zone_ids = ["/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/resourceGroups/rg-privatedns-pe-prod-axpo/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"]
  }
]
subresource_names              = ["Vault"]
is_manual_connection           = false
private_connection_resource_id = "/subscriptions/77116f35-6e77-4f5f-b82f-49e50812cc75/resourceGroups/axso-np-appl-ssp-test-rg/providers/Microsoft.KeyVault/vaults/kv-ssp-0-nonprod-axso"