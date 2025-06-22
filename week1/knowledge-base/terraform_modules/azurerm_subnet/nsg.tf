# Network Security Groups
resource "azurerm_network_security_group" "network_nsg" {
  count = (
    var.default_name_network_security_group_create == true &&
    (var.custom_name_network_security_group == null || var.custom_name_network_security_group == "")
  ) ? 1 : 0

  name                = "${var.subnet_name}-nsg"
  location            = var.location
  resource_group_name = var.virtual_network_resource_group_name

  lifecycle {
    ignore_changes = [tags]
  }
}


resource "azurerm_subnet_network_security_group_association" "security_group_association_default" {
  count = (
    var.default_name_network_security_group_create == true &&
    (var.custom_name_network_security_group == null || var.custom_name_network_security_group == "")
  ) ? 1 : 0

  subnet_id                 = azurerm_subnet.azure_network_subnet.id
  network_security_group_id = azurerm_network_security_group.network_nsg[0].id
}
