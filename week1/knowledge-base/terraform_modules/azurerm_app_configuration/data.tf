#----------------------------------------------------------------------------------------------------------------#
# DevOps SPI information                                                                                         #
#----------------------------------------------------------------------------------------------------------------#

data "azurerm_client_config" "current" {}

#----------------------------------------------------------------------------------------------------------------#
# User assigned managed identity information                                                                     #
#----------------------------------------------------------------------------------------------------------------#

data "azurerm_user_assigned_identity" "umids" {
  for_each            = var.identity_type == "UserAssigned" ? toset(var.app_conf_umids_names) : toset([])
  name                = each.value
  resource_group_name = var.resource_group_name
}


#----------------------------------------------------------------------------------------------------------------#
# Private endpoint subnet information                                                                            #
#----------------------------------------------------------------------------------------------------------------#

data "azurerm_subnet" "pe_subnet" {
  count                = var.pe_subnet != null && length(var.pe_subnet) > 0 ? 1 : 0
  name                 = var.pe_subnet != null ? lookup(var.pe_subnet, "subnet_name", null) : null
  virtual_network_name = var.pe_subnet != null ? lookup(var.pe_subnet, "vnet_name", null) : null
  resource_group_name  = var.pe_subnet != null ? lookup(var.pe_subnet, "vnet_rg_name", null) : null
}

data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}