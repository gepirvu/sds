#Resources Ids
locals {
  network_security_group_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.virtual_network_resource_group_name}/providers/Microsoft.Network/networkSecurityGroups/${try(var.custom_name_network_security_group, "")}"
  route_table_id            = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.virtual_network_resource_group_name}/providers/Microsoft.Network/routeTables/${var.route_table_name}"
}


