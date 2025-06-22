#-----------------------------------------------------------------------------------------------
# Kubernetes cluster - Admin and Reader AAD groups
#-----------------------------------------------------------------------------------------------


resource "azurerm_user_assigned_identity" "des_user_assigned_identity" {
  name                = local.des_user_assigned_identity_name
  resource_group_name = var.resource_group_name
  location            = var.location
  lifecycle {
    ignore_changes = [tags]

  }
}

resource "azurerm_role_assignment" "role_assignment_keyvault" {
  scope                = data.azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_user_assigned_identity.des_user_assigned_identity.principal_id
}

#Encrypting the data disk
resource "azurerm_disk_encryption_set" "disk_encryption_set" {
  name                = local.disk_encryption_set_name
  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_key_id    = azurerm_key_vault_key.key_vault_key.versionless_id

  auto_key_rotation_enabled = true

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.des_user_assigned_identity.id]
  }
  lifecycle {
    ignore_changes = [tags]
  }
  depends_on = [azurerm_role_assignment.role_assignment_keyvault]
}

resource "azurerm_key_vault_key" "key_vault_key" {
  name            = local.disk_encryption_key_name
  key_vault_id    = data.azurerm_key_vault.key_vault.id
  key_type        = "RSA"
  key_size        = 2048
  expiration_date = local.expiration_date
  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }
    expire_after         = "P365D"
    notify_before_expiry = "P45D"
  }

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  lifecycle {
    ignore_changes = [
      expiration_date, tags
    ]
  }
}


resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  name                = local.user_assigned_identity_name
  resource_group_name = var.resource_group_name
  location            = var.location
  lifecycle {
    ignore_changes = [tags]

  }
}

resource "azurerm_role_assignment" "role_assignmen_user_assigned_identity" {
  count                = var.private_cluster_public_fqdn_enabled ? 0 : 1
  scope                = local.private_dns_zone_id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id
}

#-----------------------------------------------------------------------------------------------
# Kubernetes cluster
#-----------------------------------------------------------------------------------------------
resource "azurerm_kubernetes_cluster" "aks" {
  depends_on = [
    azurerm_role_assignment.role_assignmen_user_assigned_identity,
    azurerm_role_assignment.aks-vnet,
    azurerm_role_assignment.role_assignment_keyvault
  ]
  resource_group_name = var.resource_group_name
  location            = var.location

  name                                = local.cluster_name
  kubernetes_version                  = var.kubernetes_version
  sku_tier                            = var.sku_tier
  dns_prefix                          = var.private_cluster_public_fqdn_enabled ? var.dns_prefix : null
  dns_prefix_private_cluster          = var.private_cluster_public_fqdn_enabled ? null : var.dns_prefix
  private_cluster_enabled             = true
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled
  private_dns_zone_id                 = var.private_cluster_public_fqdn_enabled ? "None" : local.private_dns_zone_id
  node_resource_group                 = local.node_resource_group
  automatic_upgrade_channel           = var.patch_setting
  disk_encryption_set_id              = azurerm_disk_encryption_set.disk_encryption_set.id
  local_account_disabled              = true

  image_cleaner_enabled        = var.image_cleaner_enabled
  image_cleaner_interval_hours = var.image_cleaner_enabled == true ? var.image_cleaner_interval_hours : null

  #Workload Identity
  oidc_issuer_enabled       = var.workload_identity_enabled ? true : var.oidc_issuer_enabled
  workload_identity_enabled = var.workload_identity_enabled

  azure_policy_enabled = true
  support_plan         = var.support_plan


  # Default node pool
  default_node_pool {
    name                         = var.system_node_pool_name
    temporary_name_for_rotation  = var.temporary_name_for_rotation
    node_count                   = var.is_enabled_auto_scaling ? null : var.node_count
    vm_size                      = var.vm_size
    os_disk_size_gb              = var.os_disk_size_gb
    vnet_subnet_id               = data.azurerm_subnet.subnet.id
    max_pods                     = 110
    auto_scaling_enabled         = var.is_enabled_auto_scaling
    min_count                    = var.is_enabled_auto_scaling ? var.min_count : null
    max_count                    = var.is_enabled_auto_scaling ? var.max_count : null
    type                         = var.agents_type
    zones                        = var.agents_availability_zones
    host_encryption_enabled      = true
    only_critical_addons_enabled = true
    linux_os_config {
      sysctl_config {
        fs_aio_max_nr                     = var.sysctl_config_system_pool.fs_aio_max_nr != null ? var.sysctl_config_system_pool.fs_aio_max_nr : null
        fs_file_max                       = var.sysctl_config_system_pool.fs_file_max != null ? var.sysctl_config_system_pool.fs_file_max : null
        fs_inotify_max_user_watches       = var.sysctl_config_system_pool.fs_inotify_max_user_watches != null ? var.sysctl_config_system_pool.fs_inotify_max_user_watches : null
        fs_nr_open                        = var.sysctl_config_system_pool.fs_nr_open != null ? var.sysctl_config_system_pool.fs_nr_open : null
        kernel_threads_max                = var.sysctl_config_system_pool.kernel_threads_max != null ? var.sysctl_config_system_pool.kernel_threads_max : null
        net_core_netdev_max_backlog       = var.sysctl_config_system_pool.net_core_netdev_max_backlog != null ? var.sysctl_config_system_pool.net_core_netdev_max_backlog : null
        net_core_optmem_max               = var.sysctl_config_system_pool.net_core_optmem_max != null ? var.sysctl_config_system_pool.net_core_optmem_max : null
        net_core_rmem_default             = var.sysctl_config_system_pool.net_core_rmem_default != null ? var.sysctl_config_system_pool.net_core_rmem_default : null
        net_core_rmem_max                 = var.sysctl_config_system_pool.net_core_rmem_max != null ? var.sysctl_config_system_pool.net_core_rmem_max : null
        net_core_somaxconn                = var.sysctl_config_system_pool.net_core_somaxconn != null ? var.sysctl_config_system_pool.net_core_somaxconn : null
        net_core_wmem_default             = var.sysctl_config_system_pool.net_core_wmem_default != null ? var.sysctl_config_system_pool.net_core_wmem_default : null
        net_core_wmem_max                 = var.sysctl_config_system_pool.net_core_wmem_max != null ? var.sysctl_config_system_pool.net_core_wmem_max : null
        net_ipv4_ip_local_port_range_max  = var.sysctl_config_system_pool.net_ipv4_ip_local_port_range_max != null ? var.sysctl_config_system_pool.net_ipv4_ip_local_port_range_max : null
        net_ipv4_ip_local_port_range_min  = var.sysctl_config_system_pool.net_ipv4_ip_local_port_range_min != null ? var.sysctl_config_system_pool.net_ipv4_ip_local_port_range_min : null
        net_ipv4_neigh_default_gc_thresh1 = var.sysctl_config_system_pool.net_ipv4_neigh_default_gc_thresh1 != null ? var.sysctl_config_system_pool.net_ipv4_neigh_default_gc_thresh1 : null
        net_ipv4_neigh_default_gc_thresh2 = var.sysctl_config_system_pool.net_ipv4_neigh_default_gc_thresh2 != null ? var.sysctl_config_system_pool.net_ipv4_neigh_default_gc_thresh2 : null
        net_ipv4_neigh_default_gc_thresh3 = var.sysctl_config_system_pool.net_ipv4_neigh_default_gc_thresh3 != null ? var.sysctl_config_system_pool.net_ipv4_neigh_default_gc_thresh3 : null
        net_ipv4_tcp_fin_timeout          = var.sysctl_config_system_pool.net_ipv4_tcp_fin_timeout != null ? var.sysctl_config_system_pool.net_ipv4_tcp_fin_timeout : null
        net_ipv4_tcp_keepalive_intvl      = var.sysctl_config_system_pool.net_ipv4_tcp_keepalive_intvl != null ? var.sysctl_config_system_pool.net_ipv4_tcp_keepalive_intvl : null
        net_ipv4_tcp_keepalive_probes     = var.sysctl_config_system_pool.net_ipv4_tcp_keepalive_probes != null ? var.sysctl_config_system_pool.net_ipv4_tcp_keepalive_probes : null
        net_ipv4_tcp_keepalive_time       = var.sysctl_config_system_pool.net_ipv4_tcp_keepalive_time != null ? var.sysctl_config_system_pool.net_ipv4_tcp_keepalive_time : null
        net_ipv4_tcp_max_syn_backlog      = var.sysctl_config_system_pool.net_ipv4_tcp_max_syn_backlog != null ? var.sysctl_config_system_pool.net_ipv4_tcp_max_syn_backlog : null
        net_ipv4_tcp_max_tw_buckets       = var.sysctl_config_system_pool.net_ipv4_tcp_max_tw_buckets != null ? var.sysctl_config_system_pool.net_ipv4_tcp_max_tw_buckets : null
        vm_max_map_count                  = var.sysctl_config_system_pool.vm_max_map_count != null ? var.sysctl_config_system_pool.vm_max_map_count : null
        vm_swappiness                     = var.sysctl_config_system_pool.vm_swappiness != null ? var.sysctl_config_system_pool.vm_swappiness : null
        vm_vfs_cache_pressure             = var.sysctl_config_system_pool.vm_vfs_cache_pressure != null ? var.sysctl_config_system_pool.vm_vfs_cache_pressure : null
      }
    }
  }

  # Networking
  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "azure"
    service_cidr        = "172.16.0.0/16"
    dns_service_ip      = "172.16.0.10"
    outbound_type       = "userDefinedRouting"
  }

  azure_active_directory_role_based_access_control {
    tenant_id              = "8619c67c-945a-48ae-8e77-35b1b71c9b98"
    admin_group_object_ids = tolist(flatten([for g in data.azuread_group.azuread_group_admin : g.object_id]))
    azure_rbac_enabled     = true
  }

  ## Monitoring integration
  oms_agent {

    log_analytics_workspace_id      = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
    msi_auth_for_monitoring_enabled = true
  }

  ## Identity
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.user_assigned_identity.id]
  }

  dynamic "monitor_metrics" {
    for_each = var.grafana_enabled ? [1] : []
    content {
      annotations_allowed = null
      labels_allowed      = null
    }
  }

  ## Enable the secrets store CSI driver support

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  storage_profile {
    blob_driver_enabled = true
    file_driver_enabled = true
  }

  microsoft_defender {
    log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
  }

  lifecycle {
    ignore_changes = [tags]
  }

}

#Workload Identity

resource "azurerm_user_assigned_identity" "workload_assigned_identity" {
  for_each            = { for each in var.workload_assigned_identities : each.workload_assigned_identity_name => each if each.workload_assigned_identity_exists == false }
  name                = each.value.workload_assigned_identity_name
  resource_group_name = var.resource_group_name
  location            = var.location
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_federated_identity_credential" "federated_identity_credential" {
  for_each            = { for each in var.service_accounts : each.name => each }
  name                = each.value.name
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = each.value.workload_assigned_identity_exists == false ? azurerm_user_assigned_identity.workload_assigned_identity[each.value.workload_assigned_identity_name].id : data.azurerm_user_assigned_identity.user_assigned_identity[each.value.workload_assigned_identity_name].id
  subject             = "system:serviceaccount:${each.value.namespace}:${each.value.service_account_name}"
}

#Container Insights
resource "azurerm_monitor_data_collection_rule" "monitor_data_collection_rule_msci" {
  name                = local.data_collection_rule_name_msci
  resource_group_name = var.resource_group_name
  location            = var.location

  data_sources {
    extension {
      name           = "ContainerInsightsExtension"
      streams        = var.container_Insights_streams
      extension_name = "ContainerInsights"
      extension_json = jsonencode({
        dataCollectionSettings = {
          interval               = var.container_Insights_data_collection_interval
          namespaceFilteringMode = var.container_Insights_namespace_filtering_mode_for_data_collection
          namespaces             = var.container_Insights_namespaces_for_data_collection
          enableContainerLogV2   = var.container_Insights_enableContainerLogV2
        }
      })
    }
  }

  destinations {
    log_analytics {
      name                  = data.azurerm_log_analytics_workspace.log_analytics_workspace.name
      workspace_resource_id = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
    }
  }

  data_flow {
    streams      = var.container_Insights_streams
    destinations = [data.azurerm_log_analytics_workspace.log_analytics_workspace.name]
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_monitor_data_collection_rule_association" "dcra_msci" {
  name                    = local.azurerm_monitor_data_collection_rule_association_name_prometheus
  target_resource_id      = azurerm_kubernetes_cluster.aks.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.monitor_data_collection_rule_msci.id
}

#Prometheus
resource "azurerm_monitor_data_collection_endpoint" "dce" {
  count               = var.grafana_enabled ? 1 : 0
  name                = local.data_collection_endpoint_name_prometheus
  resource_group_name = var.resource_group_name
  location            = var.location
  kind                = "Linux"
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_monitor_data_collection_rule" "monitor_data_collection_rule" {
  count                       = var.grafana_enabled ? 1 : 0
  name                        = local.data_collection_rule_name_prometheus
  resource_group_name         = var.resource_group_name
  location                    = var.location
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.dce[0].id

  data_sources {
    prometheus_forwarder {
      name    = "PrometheusDataSource"
      streams = ["Microsoft-PrometheusMetrics"]
    }
  }

  destinations {
    monitor_account {
      monitor_account_id = module.axso_dashboard_grafana[0].azurerm_monitor_workspace_id
      name               = module.axso_dashboard_grafana[0].azurerm_monitor_workspace_name
    }
  }

  data_flow {
    streams      = ["Microsoft-PrometheusMetrics"]
    destinations = [module.axso_dashboard_grafana[0].azurerm_monitor_workspace_name]
  }
  lifecycle {
    ignore_changes = [tags]
  }

}

resource "azurerm_monitor_data_collection_rule_association" "dcra_msprom_rule" {
  count                   = var.grafana_enabled ? 1 : 0
  name                    = local.azurerm_monitor_data_collection_rule_association_name_msci
  target_resource_id      = azurerm_kubernetes_cluster.aks.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.monitor_data_collection_rule[0].id
}

module "axso_dashboard_grafana" {
  source                            = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_dashboard_grafana?ref=v1.2.0"
  count                             = var.grafana_enabled ? 1 : 0
  resource_group_name               = var.resource_group_name
  location                          = var.location
  project_name                      = var.project_name
  subscription                      = var.subscription
  environment                       = var.environment
  network_resource_group_name       = var.network_resource_group_name
  virtual_network_name              = var.virtual_network_name
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
}

module "axso_monitor_prometheus" {
  source                                                = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_monitor_prometheus?ref=v1.1.3"
  count                                                 = var.enable_prometheus ? 1 : 0
  resource_group_name                                   = var.resource_group_name
  location                                              = var.location
  project_name                                          = var.project_name
  subscription                                          = var.subscription
  environment                                           = var.environment
  azure_monitor_workspace_name                          = module.axso_dashboard_grafana[0].azurerm_monitor_workspace_name
  default_node_recording_rules_rule_group_enabled       = var.default_node_recording_rules_rule_group_enabled
  default_kubernetes_recording_rules_rule_group_enabled = var.default_kubernetes_recording_rules_rule_group_enabled
  custom_kubernetes_recording_rules_rule_group_enabled  = var.custom_kubernetes_recording_rules_rule_group_enabled
  custom_kubernetes_recording_rules_rule_group          = var.custom_kubernetes_recording_rules_rule_group
  depends_on                                            = [module.axso_dashboard_grafana]

}


module "data_protection_backup_vault" {
  source                                    = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_data_protection_backup?ref=v1.1.0"
  count                                     = var.enable_azure_backup ? 1 : 0
  subscription                              = var.subscription
  project_name                              = var.project_name
  environment                               = var.environment
  location                                  = var.location
  resource_group_name                       = var.resource_group_name
  datastore_type                            = var.datastore_type
  redundancy                                = var.redundancy
  cross_region_restore_enabled              = var.cross_region_restore_enabled
  retention_duration_in_days                = var.retention_duration_in_days
  soft_delete                               = var.soft_delete
  snapshot_resource_group_name              = azurerm_kubernetes_cluster.aks.node_resource_group
  kubernetes_cluster_backup_policy          = var.kubernetes_cluster_backup_policy
  kubernetes_cluster_backup_config          = var.kubernetes_cluster_backup_config
  kubernetes_cluster_storage_account_config = var.kubernetes_cluster_storage_account_config
  depends_on                                = [azurerm_kubernetes_cluster.aks]
}
