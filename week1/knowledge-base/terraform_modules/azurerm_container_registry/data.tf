#----------------------------------------------------------------------------------------------------------------#
# User assigned managed identity information                                                                     #
#----------------------------------------------------------------------------------------------------------------#

data "azurerm_user_assigned_identity" "umids" {
  count               = var.identity_type == "SystemAssigned, UserAssigned" || var.identity_type == "SystemAssigned" ? length(var.acr_umids) : 0
  name                = var.acr_umids != null ? var.acr_umids[count.index].umid_name : null
  resource_group_name = var.acr_umids != null ? var.acr_umids[count.index].umid_rg_name : null
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

#----------------------------------------------------------------------------------------------------------------#
# ACR allowed subnets                                                                                            #
#----------------------------------------------------------------------------------------------------------------#

data "azurerm_subnet" "acr_allowed_subnets" {
  for_each             = { for idx, subnet in var.acr_allowed_subnets : idx => subnet }
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.vnet_rg_name
}

#----------------------------------------------------------------------------------------------------------------#