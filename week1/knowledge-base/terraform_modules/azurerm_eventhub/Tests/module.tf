module "azurerm_eventhub" {
  source                      = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_eventhub?ref=~{gitRef}~"
  project_name                = var.project_name
  subscription                = var.subscription
  environment                 = var.environment
  location                    = var.location
  resource_group_name         = var.resource_group_name
  partition_count             = var.partition_count
  message_retention           = var.message_retention
  virtual_network_name        = var.virtual_network_name
  network_resource_group_name = var.network_resource_group_name
  pe_subnet_name              = var.pe_subnet_name
}