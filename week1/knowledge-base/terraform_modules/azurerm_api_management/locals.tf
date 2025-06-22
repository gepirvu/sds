locals {
  apim_name                                = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-apim")
  nsg_rule_name                            = var.custom_management_rule_name
  dns_apim_zone_name                       = "azure-api.net"
  private_endpoint_dns_resource_group_name = "rg-privatedns-pe-prod-axpo"
  gateway_hostname                         = replace(replace(azurerm_api_management.apim.gateway_url, "https://", ""), ".azure-api.net", "")
  management_hostname                      = replace(replace(azurerm_api_management.apim.management_api_url, "https://", ""), ".azure-api.net", "")
  portal_hostname                          = replace(replace(azurerm_api_management.apim.portal_url, "https://", ""), ".azure-api.net", "")
  developer_portal_hostname                = replace(replace(azurerm_api_management.apim.developer_portal_url, "https://", ""), ".azure-api.net", "")
  scm_hostname                             = replace(replace(azurerm_api_management.apim.scm_url, "https://", ""), ".azure-api.net", "")

}