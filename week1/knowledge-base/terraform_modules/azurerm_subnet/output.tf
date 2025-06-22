output "subnet_ids" {
  value = azurerm_subnet.azure_network_subnet.id
}

output "subnet_names" {
  value = azurerm_subnet.azure_network_subnet.name
}

output "subnet_subnet_id_map" {
  value = {
    name = azurerm_subnet.azure_network_subnet.name
    id   = azurerm_subnet.azure_network_subnet.id
  }
}