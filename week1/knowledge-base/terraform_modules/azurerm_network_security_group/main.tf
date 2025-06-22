##################################################
# RESOURCES                                      #
##################################################
# Network Security Groups
resource "azurerm_network_security_group" "network_nsg" {
  for_each            = { for each in var.nsgs : each.subnet_name => each }
  name                = "${each.value.subnet_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name


  dynamic "security_rule" {
    for_each = each.value.nsg_rules
    content {
      name                         = security_rule.value.nsg_rule_name
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_port_range            = security_rule.value.source_port_range
      source_port_ranges           = security_rule.value.source_port_ranges
      destination_port_range       = security_rule.value.destination_port_range
      destination_port_ranges      = security_rule.value.destination_port_ranges
      source_address_prefix        = security_rule.value.source_address_prefix
      source_address_prefixes      = security_rule.value.source_address_prefixes
      destination_address_prefix   = security_rule.value.destination_address_prefix
      destination_address_prefixes = security_rule.value.destination_address_prefixes
    }

  }

  lifecycle {
    ignore_changes = [tags]
  }
}


