data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

data "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  count               = var.enable_oms_agent_extension == true ? 1 : 0
  name                = var.log_analytics_workspace_name
  resource_group_name = var.resource_group_name


}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.virtual_network_resource_group_name
}