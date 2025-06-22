resource "azurerm_network_security_group" "network_security_group" {
  name                = "${local.adb_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}

resource "azurerm_subnet_network_security_group_association" "public_subnet_network_security_group_association" {
  subnet_id                 = data.azurerm_subnet.public_subnet.id
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}

resource "azurerm_subnet_network_security_group_association" "private_subnet_network_security_group_association" {
  subnet_id                 = data.azurerm_subnet.private_subnet.id
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}