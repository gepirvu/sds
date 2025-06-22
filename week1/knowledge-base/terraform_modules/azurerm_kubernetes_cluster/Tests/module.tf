# Pre-requisites

# Resource group





#============================================================================================================================================

module "axso_kubernetes_cluster" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_kubernetes_cluster?ref=~{gitRef}~"

  # AKS Cluster
  resource_group_name = var.resource_group_name
  location            = var.location


  # AKS Cluster Naming
  project_name   = var.project_name
  subscription   = var.subscription
  environment    = var.environment
  key_vault_name = var.key_vault_name

  # AKS Standard settings
  kubernetes_version                  = var.kubernetes_version
  support_plan                        = var.support_plan
  sku_tier                            = var.sku_tier
  dns_prefix                          = var.dns_prefix
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled
  patch_setting                       = var.patch_setting
  image_cleaner_enabled               = var.image_cleaner_enabled
  image_cleaner_interval_hours        = var.image_cleaner_interval_hours

  # Workload Identity
  oidc_issuer_enabled          = var.oidc_issuer_enabled
  workload_identity_enabled    = var.workload_identity_enabled
  service_accounts             = var.service_accounts
  workload_assigned_identities = var.workload_assigned_identities

  # Default node pool   
  system_node_pool_name       = var.system_node_pool_name
  temporary_name_for_rotation = var.temporary_name_for_rotation
  node_count                  = var.node_count
  vm_size                     = var.vm_size
  os_disk_size_gb             = var.os_disk_size_gb
  aks_subnet_name             = var.aks_subnet_name
  is_enabled_auto_scaling     = var.is_enabled_auto_scaling
  max_count                   = var.max_count
  min_count                   = var.min_count
  agents_type                 = var.agents_type
  agents_availability_zones   = var.agents_availability_zones
  sysctl_config_system_pool   = var.sysctl_config_system_pool

  pool_names = var.pool_names

  # AKS authentication and authorization
  azuread_group_readers_names = var.azuread_group_readers_names
  azuread_group_admin_names   = var.azuread_group_admin_names

  # Networking
  virtual_network_name        = var.virtual_network_name
  network_resource_group_name = var.network_resource_group_name

  # Monitoring
  aks_loga_name = var.aks_loga_name

  # ACR - AKS Identity will have AcrPull RBAC on ACR
  acr_name                = var.acr_name
  acr_resource_group_name = var.acr_resource_group_name
  acr_subscription_id     = var.acr_subscription_id


  #Container Insights
  container_Insights_data_collection_interval                     = var.container_Insights_data_collection_interval
  container_Insights_namespace_filtering_mode_for_data_collection = var.container_Insights_namespace_filtering_mode_for_data_collection
  container_Insights_namespaces_for_data_collection               = var.container_Insights_namespaces_for_data_collection
  container_Insights_streams                                      = var.container_Insights_streams
  container_Insights_enableContainerLogV2                         = var.container_Insights_enableContainerLogV2

  # Grafana
  grafana_enabled                   = var.grafana_enabled
  pe_subnet_name                    = var.pe_subnet_name
  api_key_enabled                   = var.api_key_enabled
  grafana_major_version             = var.grafana_major_version
  sku                               = var.sku
  zone_redundancy_enabled           = var.zone_redundancy_enabled
  deterministic_outbound_ip_enabled = var.deterministic_outbound_ip_enabled
  smtp_enable                       = var.smtp_enable
  identity_type                     = var.identity_type
  azure_monitor_workspace_enabled   = var.azure_monitor_workspace_enabled
  admin_groups                      = var.admin_groups

  #Prometheus
  enable_prometheus                                     = var.enable_prometheus
  default_node_recording_rules_rule_group_enabled       = var.default_node_recording_rules_rule_group_enabled
  default_kubernetes_recording_rules_rule_group_enabled = var.default_kubernetes_recording_rules_rule_group_enabled

  # RBAC

  role_assignments_writer = var.role_assignments_writer

  role_assignments_reader = var.role_assignments_reader

  #Backup
  enable_azure_backup                       = var.enable_azure_backup
  datastore_type                            = var.datastore_type
  redundancy                                = var.redundancy
  cross_region_restore_enabled              = var.cross_region_restore_enabled
  retention_duration_in_days                = var.retention_duration_in_days
  soft_delete                               = var.soft_delete
  kubernetes_cluster_backup_policy          = var.kubernetes_cluster_backup_policy
  kubernetes_cluster_backup_config          = var.kubernetes_cluster_backup_config
  kubernetes_cluster_storage_account_config = var.kubernetes_cluster_storage_account_config


}
#============================================================================================================================================