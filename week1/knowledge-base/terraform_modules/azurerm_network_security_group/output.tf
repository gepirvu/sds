##################################################
# OUTPUTS                                        #
##################################################
output "name" {
  value       = [for nsg in azurerm_network_security_group.network_nsg : nsg.name]
  description = "value for the name of the NSG"
}

output "id" {
  value       = [for nsg in azurerm_network_security_group.network_nsg : nsg.id]
  description = "value for the id of the NSG"
}

