resource "azurerm_private_endpoint" "private_endpoint" {
  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.pe_subnet.id
  private_service_connection {
    name                           = "${var.private_endpoint_name}-sc"
    private_connection_resource_id = var.private_connection_resource_id
    is_manual_connection           = var.is_manual_connection
    subresource_names              = var.subresource_names
  }

  dynamic "private_dns_zone_group" {
    for_each = [for each in var.private_dns_zone_group :
      {
        name                 = each.name
        private_dns_zone_ids = each.private_dns_zone_ids
        enabled              = each.enabled
      } if each.enabled == true
    ]

    content {
      name                 = private_dns_zone_group.value.name
      private_dns_zone_ids = private_dns_zone_group.value.private_dns_zone_ids
    }
  }
  lifecycle {
    ignore_changes = [tags]
  }
}