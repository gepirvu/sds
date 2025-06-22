
resource "azurerm_network_interface" "nic" {
  name                = local.vm_nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  accelerated_networking_enabled = var.nic_enable_accelerated_networking

  ip_configuration {
    name                          = local.vm_nic_name
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = var.static_private_ip == null ? "Dynamic" : "Static"
    private_ip_address            = var.static_private_ip
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
