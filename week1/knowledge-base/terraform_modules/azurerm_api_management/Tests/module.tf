
data "azurerm_subnet" "subnet" {
  name                 = var.subnet_names[0]
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.virtual_network_resource_group_name
}


resource "azurerm_network_security_group" "network_nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_network_security_group_association" {
  subnet_id                 = data.azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.network_nsg.id
}

module "apim" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_api_management?ref=~{gitRef}~"
  providers = {
    azurerm.dns = azurerm.dns
  }
  location                                           = var.location
  environment                                        = var.environment
  resource_group_name                                = var.resource_group_name
  virtual_network_name                               = var.virtual_network_name
  virtual_network_resource_group_name                = var.virtual_network_resource_group_name
  virtual_network_type                               = var.virtual_network_type
  subnet_names                                       = var.subnet_names
  nsg_name                                           = var.nsg_name
  app_insights_name                                  = var.app_insights_name
  backend_services                                   = var.backend_services
  backend_protocol                                   = var.backend_protocol
  sku_name                                           = var.sku_name
  publisher_name                                     = var.publisher_name
  publisher_email                                    = var.publisher_email
  zones                                              = var.zones
  key_vault_name                                     = var.key_vault_name
  named_values                                       = var.named_values
  keyvault_named_values                              = var.keyvault_named_values
  wildcard_certificate_key_vault_name                = var.wildcard_certificate_key_vault_name
  wildcard_certificate_name                          = var.wildcard_certificate_name
  wildcard_certificate_key_vault_resource_group_name = var.wildcard_certificate_key_vault_resource_group_name
  requires_custom_host_name_configuration            = var.requires_custom_host_name_configuration
  developer_portal_host_name                         = var.developer_portal_host_name
  management_host_name                               = var.management_host_name
  gateway_host_name                                  = var.gateway_host_name
  depends_on                                         = [azurerm_network_security_group.network_nsg, azurerm_subnet_network_security_group_association.subnet_network_security_group_association]
}