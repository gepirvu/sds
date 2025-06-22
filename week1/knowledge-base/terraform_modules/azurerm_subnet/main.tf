# Azure Virtual Network Subnets
resource "azurerm_subnet" "azure_network_subnet" {
  resource_group_name                           = var.virtual_network_resource_group_name
  virtual_network_name                          = var.virtual_network_name
  name                                          = var.subnet_name
  address_prefixes                              = var.subnet_address_prefixes
  service_endpoints                             = var.subnet_service_endpoints
  private_link_service_network_policies_enabled = var.private_link_service_network_policies_enabled
  private_endpoint_network_policies             = var.private_endpoint_network_policies_enabled

  dynamic "delegation" {
    for_each = var.subnets_delegation_settings
    content {
      name = delegation.key
      dynamic "service_delegation" {
        for_each = toset(delegation.value)
        content {
          name    = service_delegation.value.name
          actions = service_delegation.value.actions
        }
      }
    }
  }
}

resource "azurerm_subnet_route_table_association" "route_table_association" {
  count          = var.route_table_name == "" ? 0 : 1
  subnet_id      = azurerm_subnet.azure_network_subnet.id
  route_table_id = local.route_table_id
}



resource "azurerm_subnet_network_security_group_association" "security_group_association" {
  count = (
    (var.custom_name_network_security_group != null && var.custom_name_network_security_group != "") &&
    (var.default_name_network_security_group_create != true)
  ) ? 1 : 0
  subnet_id                 = azurerm_subnet.azure_network_subnet.id
  network_security_group_id = local.network_security_group_id
}

