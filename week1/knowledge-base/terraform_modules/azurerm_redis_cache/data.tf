#-------------------------------------------------------------------------------------------------------------------#

# User assigned managed identity information

data "azurerm_user_assigned_identity" "umids" {
  for_each            = var.redis_umids != null && length(var.redis_umids) > 0 ? { for key, value in var.redis_umids : key => value if value != null && value.umid_name != null } : {}
  name                = each.value.umid_name
  resource_group_name = each.value.umid_rg_name
}

#-------------------------------------------------------------------------------------------------------------------#

# Subnet information for the private endpoint of the redis cache

data "azurerm_subnet" "pe_subnet" {
  count                = var.pe_subnet_details != null && length(var.pe_subnet_details) > 0 ? 1 : 0
  name                 = var.pe_subnet_details != null ? lookup(var.pe_subnet_details, "subnet_name", null) : null
  virtual_network_name = var.pe_subnet_details != null ? lookup(var.pe_subnet_details, "vnet_name", null) : null
  resource_group_name  = var.pe_subnet_details != null ? lookup(var.pe_subnet_details, "vnet_rg_name", null) : null
}

#-------------------------------------------------------------------------------------------------------------------#