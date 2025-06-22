
module "webapps" {

  source   = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_linux_web_app?ref=~{gitRef}~"
  location = var.location
  providers = {
    azurerm.dns = azurerm.dns
  }
  resource_group_name                  = var.resource_group_name
  project_name                         = var.project_name
  subscription                         = var.subscription
  environment                          = var.environment
  service_plan_sku_name                = var.service_plan_sku_name
  service_plan_os_type                 = var.service_plan_os_type
  service_plan_usage                   = var.service_plan_usage
  app_services                         = var.app_services
  deployment_slots                     = var.deployment_slots
  default_documents                    = var.default_documents
  app_settings                         = var.app_settings
  network_resource_group_name          = var.network_resource_group_name
  virtual_network_name                 = var.virtual_network_name
  vint_subnet_name                     = var.vint_subnet_name
  pe_subnet_name                       = var.pe_subnet_name
  docker_registry_url                  = var.docker_registry_url
  acr_name                             = var.acr_name
  umids                                = var.umid_names
  private_dns_zone_name                = var.private_dns_zone_name
  public_dns_zone_name                 = var.public_dns_zone_name
  webapp_custom_certificates_key_vault = var.webapp_custom_certificates_key_vault
  webapp_custom_certificates           = var.webapp_custom_certificates
  webapp_custom_domains                = var.webapp_custom_domains
}
