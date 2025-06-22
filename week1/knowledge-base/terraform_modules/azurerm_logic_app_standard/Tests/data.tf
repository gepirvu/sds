data "azurerm_user_assigned_identity" "identity" {
  name                = var.user_assigned_identity_name
  resource_group_name = var.resource_group_name
}

data "azurerm_storage_account" "sa" {
  name                = var.logic_app_storage_account_name
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "vint_subnet" {
  name                 = var.vint_subnet_name
  virtual_network_name = "vnet-ssp-nonprod-axso-vnet"
  resource_group_name  = var.resource_group_name

}

data "azurerm_subnet" "pe_subnet" {
  name                 = var.pe_subnet_name
  virtual_network_name = "vnet-ssp-nonprod-axso-vnet"
  resource_group_name  = "axso-np-appl-ssp-test-rg"

}