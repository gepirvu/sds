
#============================================================================================================================================

resource_group_name = "axso-np-appl-ssp-test-rg"

location = "westeurope"


# Kubernetes Cluster

# Kubernetes cluster naming and AAD groups
subscription = "np"
project_name = "ssp"
environment  = "t3s3tt"

# Kubernetes clustrer standard settings
kubernetes_version           = "1.30.5"
support_plan                 = "AKSLongTermSupport"
sku_tier                     = "Premium"
key_vault_name               = "kv-ssp-0-nonprod-axso"
image_cleaner_enabled        = false
image_cleaner_interval_hours = null
temporary_name_for_rotation  = "temp"

sysctl_config_system_pool = {}


#worload identity
workload_identity_enabled = true
oidc_issuer_enabled       = true

service_accounts = [{
  name                            = "test"
  namespace                       = "test"
  service_account_name            = "satest"
  workload_assigned_identity_name = "axso-np-appl-etools-dev-ak-identity-app1"
  },
  {
    name                            = "test2"
    namespace                       = "test2"
    service_account_name            = "satest2"
    workload_assigned_identity_name = "axso-np-appl-etools-dev-ak-identity-app1"
  },
  {
    name                            = "test3"
    namespace                       = "test3"
    service_account_name            = "satest3"
    workload_assigned_identity_name = "axso-np-appl-etools-dev-ak-identity-app2"
  },
  {
    name                              = "test4"
    namespace                         = "test3"
    service_account_name              = "satest4"
    workload_assigned_identity_name   = "axso-np-appl-ssp-test-umid" #A exiting user managed idenity identity
    workload_assigned_identity_exists = true
  }
]

workload_assigned_identities = [
  {
    workload_assigned_identity_name   = "axso-np-appl-etools-dev-ak-identity-app1"
    workload_assigned_identity_exists = false
  },
  {
    workload_assigned_identity_name   = "axso-np-appl-etools-dev-ak-identity-app2"
    workload_assigned_identity_exists = false
  },
  {
    workload_assigned_identity_name   = "axso-np-appl-ssp-test-umid" #A exiting user managed idenity identity
    workload_assigned_identity_exists = true
  }
]

# Default system node pool configuration
system_node_pool_name     = "systempool"
node_count                = 3
vm_size                   = "Standard_D2ads_v5"
os_disk_size_gb           = "256"
is_enabled_auto_scaling   = true
min_count                 = 3
max_count                 = 4
agents_type               = "VirtualMachineScaleSets"
agents_availability_zones = ["2"]

pool_names = [{
  name                      = "userpool"
  subnet_name               = "default-subnet"
  node_count                = 2
  vm_size                   = "Standard_D2ads_v5"
  os_type                   = "Linux"
  os_sku                    = "Ubuntu"
  os_disk_size_gb           = "30"
  max_pods                  = 110
  enable_auto_scaling       = true
  min_count                 = 2
  max_count                 = 3
  pool_mode                 = "User"
  agents_availability_zones = ["2"]
  sysctl_config = {
    fs_aio_max_nr = "655350" #If you don’t want to add more values, leave this as the default value
  }
}]

# AKS Authentication and Authorization

azuread_group_readers_names = ["CL-AZ-SUBS-cloudinfra-nonprod-Owner"]
azuread_group_admin_names   = ["CL-AZ-SUBS-cloudinfra-nonprod-Owner"]


# Networking
dns_prefix                          = "axpo-aks-dev" # For example this will create this dns *axpo-aks*.ssp.privatelink.westeurope.azmk8s.io
private_cluster_public_fqdn_enabled = false

# Data sources
network_resource_group_name = "rg-cloudinfra-nonprod-axso-ymiw"
virtual_network_name        = "vnet-cloudinfra-nonprod-axso-e3og"
aks_subnet_name             = "aks"
aks_loga_name               = "axso-np-appl-cloudinfra-dev-loga"
acr_name                    = "axso4np4ssp4shared4acr01"
acr_resource_group_name     = "axso-np-appl-ssp-test-rg"
acr_subscription_id         = "77116f35-6e77-4f5f-b82f-49e50812cc75"

# Monitoring

#Container Insights
container_Insights_data_collection_interval                     = "5m"
container_Insights_namespace_filtering_mode_for_data_collection = "Exclude"
container_Insights_namespaces_for_data_collection               = ["kube-system", "gatekeeper-system", "azure-arc"]
container_Insights_streams                                      = ["Microsoft-ContainerInsights-Group-Default"]
container_Insights_enableContainerLogV2                         = true

grafana_enabled                   = true
api_key_enabled                   = false
grafana_major_version             = "10"
sku                               = "Standard"
zone_redundancy_enabled           = false
deterministic_outbound_ip_enabled = false
smtp_enable                       = false
identity_type                     = "SystemAssigned"
pe_subnet_name                    = "pe"
azure_monitor_workspace_enabled   = true
admin_groups                      = ["CL-AZ-SUBS-cloudinfra-nonprod-Owner"]

#Prometheus

enable_prometheus                                     = true
default_node_recording_rules_rule_group_enabled       = true
default_kubernetes_recording_rules_rule_group_enabled = true


role_assignments_writer = [
  {
    group_names = ["CL-AZ-SUBS-cloudinfra-nonprod-Owner", "CL-AZ-SUBS-cloudinfra-nonprod-Contributor"]
    namespaces  = ["kube-system", "default"]
  },
  {
    group_names = ["CL-AZ-SUBS-cloudinfra-nonprod-Owner"]
    namespaces  = ["gatekeeper-system"]
  }
]
role_assignments_reader = [
  {
    group_names = ["CL-AZ-SUBS-cloudinfra-nonprod-Owner", "CL-AZ-SUBS-cloudinfra-nonprod-Contributor"]
    namespaces  = ["kube-system"]
  },
  {
    group_names = ["CL-AZ-SUBS-cloudinfra-nonprod-Owner"]
    namespaces  = ["gatekeeper-system"]
  }
]

#AKS BACKUP

enable_azure_backup          = true
datastore_type               = "VaultStore"
redundancy                   = "GeoRedundant" # LocallyRedundant, GeoRedundant, ZoneRedundant
cross_region_restore_enabled = true
retention_duration_in_days   = 14
soft_delete                  = "Off" # ["AlwaysOn" "Off" "On"]


kubernetes_cluster_backup_policy = [
  {
    kubernetes_cluster_backup_policy_name = "k8s-cluster-backup"
    resource_group_name                   = "axso-np-appl-ssp-test-rg"
    vault_name                            = "my-backup-vault"
    backup_repeating_time_intervals       = ["R/2024-06-10T00:00:00+00:00/P1D"]
    time_zone                             = "Romance Standard Time"
    default_retention_rule = {
      lifecycle = {
        duration = "P30D"
      }
    }

    retention_rule = [
      {
        name     = "retention-FirstOfWeek"
        priority = 1
        criteria = {
          absolute_criteria = "FirstOfWeek"
        }
        lifecycle = {
          duration = "P15D"
        }
      }
    ]
  }
]

kubernetes_cluster_backup_config = [
  {
    kubernetes_cluster_backup_policy_name = "k8s-cluster-backup"
    resource_group_name                   = "axso-np-appl-ssp-test-rg"
    kubernetes_cluster_name               = "axso-np-appl-ssp-t3s3tt-aks"
    backup_datasource_parameters = {
      excluded_namespaces              = []
      included_namespaces              = [] # Empty list means all namespaces
      excluded_resource_types          = []
      cluster_scoped_resources_enabled = true
      included_resource_types          = []
      label_selectors                  = []
      volume_snapshot_enabled          = true
    }
  }
]

kubernetes_cluster_storage_account_config = {
  kubernetes_cluster_backup_storage_account_name                = "axso4p4ssp4np4testsa"
  kubernetes_cluster_backup_storage_account_resource_group_name = "axso-np-appl-ssp-test-rg"
  kubernetes_cluster_backup_storage_account_blob_name           = "aks-backup"
}

