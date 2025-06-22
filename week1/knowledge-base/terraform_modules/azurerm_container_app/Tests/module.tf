
module "axso_container_apps" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_container_app?ref=~{gitRef}~"
  providers = {
    azurerm.dns = azurerm.dns
  }
  for_each = { for each in var.container_app_configs : each.usecase => each }

  # General
  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_name      = var.key_vault_name

  # Naming convention
  subscription = var.subscription
  project_name = var.project_name
  environment  = var.environment
  ca_umids     = var.ca_umids

  # Container App Environment
  usecase                      = each.value.usecase
  cae_workload_profiles        = each.value.cae_workload_profiles
  infra_subnet_configs         = each.value.infra_subnet_configs
  log_analytics_workspace_name = each.value.log_analytics_workspace_name
  cae_custom_certificates      = each.value.cae_custom_certificates
  ca_custom_domains            = each.value.ca_custom_domains
  # Container registry - optional
  container_registry_server = var.container_registry_server
  acr_umid_name             = var.acr_umid_name
  acr_umid_resource_group   = var.acr_umid_resource_group

  # Container App Environment - Storage Configurations
  cae_storage_configs = each.value.cae_storage_configs

  # Container Apps
  container_apps = each.value.container_apps
  dns_zone_name  = var.dns_zone_name

  # Container Apps Jobs
  container_apps_jobs = each.value.container_apps_jobs

}




