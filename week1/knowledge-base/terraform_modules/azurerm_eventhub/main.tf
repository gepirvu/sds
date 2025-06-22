# EventHub Resources

resource "azurerm_eventhub_namespace" "eventhub_namespace" {
  name                          = local.eventhub_namespace_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = "Premium"
  capacity                      = 1
  public_network_access_enabled = false
  local_authentication_enabled  = false

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_eventhub" "eventhub" {
  name                = local.eventhub_namespace
  namespace_name      = azurerm_eventhub_namespace.eventhub_namespace.name
  resource_group_name = var.resource_group_name
  partition_count     = var.partition_count
  message_retention   = var.message_retention

}

# Private Endpoint - EventHub

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = azurerm_eventhub.eventhub.name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.eventhub_pe_subnet.id

  private_service_connection {
    name                           = "${azurerm_eventhub.eventhub.name}-pe-sc"
    private_connection_resource_id = azurerm_eventhub_namespace.eventhub_namespace.id
    is_manual_connection           = false
    subresource_names              = ["namespace"]
  }

  private_dns_zone_group {
    name                 = "privatelink.servicebus.windows.net"
    private_dns_zone_ids = [local.private_dns_zone_id]
  }
}