| **Build Status**                                                                                                                                                                                                                                                                                                           | **Latest Version** | **Date**       |
| :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----------------------- | :------------------- |
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_kubernetes_cluster?repoName=azurerm_kubernetes_cluster&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2469&repoName=azurerm_kubernetes_cluster&branchName=main) | **v3.1.0**         | **05/02/2025** |

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**

# INDEX

----------------------------

1. [Azure Kubernetes Service Configuration](#azure-kubernetes-service-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Azure Kubernetes Service Configuration

----------------------------

[Learn more about Azure Kubernetes Service in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/aks/what-is-aks/?wt.mc_id=DT-MVP-5004771)


## Service Description

----------------------------

Azure Kubernetes Service (AKS) is a managed Kubernetes service that you can use to deploy and manage containerized applications. You need minimal container orchestration expertise to use AKS.

AKS reduces the complexity and operational overhead of managing Kubernetes by offloading much of that responsibility to Azure.


## Deployed Resources

----------------------------
This module will deploy the following azurerm resources:

- azurerm_user_assigned_identity  
- azurerm_disk_encryption_set
- azurerm_key_vault_key  
- azurerm_kubernetes_cluster  
- azurerm_private_endpoint
- azurerm_dashboard_grafana
- azurerm_monitor_prometheus
- azurerm_kubernetes_cluster_node_pool

## Pre-requisites

----------------------------

It is assumed that the following resources already exists:

- Resource Group
- Subnet for Private endpoint deployment
- AD Group 
- Azure Container Registry (When needed)
- Log analytics workspace

## Axso Naming convention example

----------------------------

The naming convention is derived from the following variables `subscription`, `project_name` and `environment`:

- **Construct:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-aks"`
- **NonProd:** `axso-np-appl-etools-dev-aks`
- **Prod:** `axso-p-appl-etools-prod-aks`

# Terraform Files

----------------------------



## module.tf

```hcl

module "axso_kubernetes_cluster" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_kubernetes_cluster?ref=v3.1.0"

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

```

## module.tf.tfvars

```hcl

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

```

## variables.tf

```hcl

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the resources will be created."
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Specifies azure region/location where resources will be created."
}


# Kubernetes cluster

variable "project_name" {
  type        = string
  default     = "etools"
  description = "The name of the project. e.g. MDS, etools, cp, cpm etc.. etc.."
}

variable "subscription" {
  type        = string
  default     = "p"
  description = "The subscription type e.g. 'p' or 'np'"
}

variable "environment" {
  type        = string
  default     = "prod "
  description = "The environment. e.g. dev, qa, uat, prod"
}

variable "kubernetes_version" {
  type        = string
  default     = "1.27.7"
  description = "value of the kubernetes version to use with the AKS cluster."
}

variable "support_plan" {
  type        = string
  default     = "KubernetesOfficial"
  description = "Kubernetes support Plan. If you used Long term support, use Premium Sku Tier "
}

variable "sku_tier" {
  type        = string
  default     = "Standard"
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free, Standard (which includes the Uptime SLA) and Premium. Defaults to Standard"
}

variable "dns_prefix" {
  type        = string
  default     = "axpo-aks"
  description = "value of the DNS prefix to use with the AKS cluster."
}

variable "private_cluster_public_fqdn_enabled" {
  type        = bool
  default     = false
  description = "Enable or Disable the private cluster public FQDN."

}

variable "temporary_name_for_rotation" {
  type        = string
  default     = "temporary-name"
  description = "(Optional) A temporary name to use when rotating the Node Pool. This value must be specified when attempting a rotation."

}

variable "oidc_issuer_enabled" {
  type        = bool
  default     = false
  description = "OIDC issuer enabled to use with the AKS cluster."
}

variable "workload_identity_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Enable or Disable the Workload Identity"

}

variable "service_accounts" {
  type = list(object({
    name                              = string
    namespace                         = string
    service_account_name              = string
    workload_assigned_identity_name   = string
    workload_assigned_identity_exists = optional(bool, false) # If the identity already exists, set this to true
  }))
  default     = []
  description = "The service accounts to create in the Kubernetes cluster for the workload identity"
}
variable "workload_assigned_identities" {
  type = list(object({
    workload_assigned_identity_name   = string
    workload_assigned_identity_exists = optional(bool, false) # If the identity already exists, set this to true
  }))
  default     = []
  description = "The identities to create to use with the workload identity"
}

variable "key_vault_name" {
  type        = string
  default     = "etools-kv"
  description = "The name of the key vault to use with the AKS cluster."
}

variable "patch_setting" {
  type        = string
  default     = null
  description = "(Optional) The upgrade channel for this Kubernetes Cluster. Possible values are patch, rapid, node-image and stable. Omitting this field sets this value to none."
}

# Default system node pool configuration

variable "system_node_pool_name" {
  type        = string
  default     = "systempool"
  description = "value of the name of the system node pool."
}

variable "node_count" {
  type        = number
  default     = 3
  description = "value of the number of nodes in the system node pool."
}

variable "vm_size" {
  type        = string
  default     = "Standard_DS2_v2"
  description = "value of the VM size to use with the system node pool."
}

variable "os_disk_size_gb" {
  type        = string
  default     = "128"
  description = "value of the OS disk size to use with the system node pool (in GB)."
}

variable "is_enabled_auto_scaling" {
  type        = bool
  default     = false
  description = "Auto scaling enabled to use with the system node pool."
}

variable "min_count" {
  type        = number
  default     = 3
  description = "value of the minimum number of nodes in the system node pool ('null' if is_enabled_auto_scaling == true)."
}

variable "max_count" {
  type        = number
  default     = 4
  description = "value of the maximum number of nodes in the system node pool ('null' if is_enabled_auto_scaling == true)."
}

variable "agents_type" {
  type        = string
  default     = "VirtualMachineScaleSets"
  description = "value of the type of agents to use with the system node pool. VirtualMachineScaleSets or AvailabilitySet."
}

variable "agents_availability_zones" {
  type        = list(string)
  description = "(Optional) A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created."
  default     = ["Zone 1"]
}

# AKS Authentication and Authorization

variable "azuread_group_readers_names" {
  type        = list(string)
  default     = ["CL-AXSO-AZ-SUB-cloudinfra-nonprod-Owner"]
  description = "The reader/s groups of the AAD groups to associate with the  aks reader group."
}

variable "azuread_group_admin_names" {
  type        = list(string)
  default     = ["CL-AXSO-AZ-SUB-cloudinfra-nonprod-Owner"]
  description = "The owner/s groups of the AAD groups to associate with the  aks owner group."
}

# Networking
# Data sources

variable "network_resource_group_name" {
  type        = string
  default     = ""
  description = "The name of the network that hosts the AKS subnet."
}

variable "virtual_network_name" {
  type        = string
  default     = ""
  description = "The name of the network that hosts the AKS subnet."
}

variable "aks_subnet_name" {
  type        = string
  description = "(Optional) The name of a Subnet where the Kubernetes Node Pool should exist. Changing this forces a new resource to be created."
}

variable "acr_name" {
  type        = string
  default     = null
  description = "Enable ACR integration if specified. Default is null. If true, the ACR name must be specified."
}

variable "acr_resource_group_name" {
  type        = string
  default     = null
  description = "Name of the resource group where the container registry is deployed"
}

variable "image_cleaner_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether the image cleaner should be enabled."

}

variable "image_cleaner_interval_hours" {
  type        = number
  default     = 24
  description = "The interval in hours at which the image cleaner should run."

}

variable "sysctl_config_system_pool" {
  type = object({
    fs_aio_max_nr                     = optional(number, null)
    fs_file_max                       = optional(number, null)
    fs_inotify_max_user_watches       = optional(number, null)
    fs_nr_open                        = optional(number, null)
    kernel_threads_max                = optional(number, null)
    net_core_netdev_max_backlog       = optional(number, null)
    net_core_optmem_max               = optional(number, null)
    net_core_rmem_default             = optional(number, null)
    net_core_rmem_max                 = optional(number, null)
    net_core_somaxconn                = optional(number, null)
    net_core_wmem_default             = optional(number, null)
    net_core_wmem_max                 = optional(number, null)
    net_ipv4_ip_local_port_range_max  = optional(number, null)
    net_ipv4_ip_local_port_range_min  = optional(number, null)
    net_ipv4_neigh_default_gc_thresh1 = optional(number, null)
    net_ipv4_neigh_default_gc_thresh2 = optional(number, null)
    net_ipv4_neigh_default_gc_thresh3 = optional(number, null)
    net_ipv4_tcp_fin_timeout          = optional(number, null)
    net_ipv4_tcp_keepalive_intvl      = optional(number, null)
    net_ipv4_tcp_keepalive_probes     = optional(number, null)
    net_ipv4_tcp_keepalive_time       = optional(number, null)
    net_ipv4_tcp_max_syn_backlog      = optional(number, null)
    net_ipv4_tcp_max_tw_buckets       = optional(number, null)
    vm_max_map_count                  = optional(number, null)
    vm_swappiness                     = optional(number, null)
    vm_vfs_cache_pressure             = optional(number, null)
  })
  default = {}
}

variable "acr_subscription_id" {
  type        = string
  default     = null
  description = "Id of the subscription where the container registry is deployed"

}

variable "aks_loga_name" {
  type        = string
  default     = "Log Analytics Workspace Name"
  description = "(Required) The name of the Log Analytics Workspace which the OMS Agent should send data to."
}

variable "pool_names" {
  type = list(object({
    name                      = string
    subnet_name               = string
    node_count                = number
    vm_size                   = string
    os_type                   = string
    os_sku                    = string
    os_disk_size_gb           = string
    max_pods                  = number
    enable_auto_scaling       = bool
    min_count                 = number
    max_count                 = number
    pool_mode                 = string
    agents_availability_zones = list(string)
    sysctl_config = object({
      fs_aio_max_nr                     = optional(number, null)
      fs_file_max                       = optional(number, null)
      fs_inotify_max_user_watches       = optional(number, null)
      fs_nr_open                        = optional(number, null)
      kernel_threads_max                = optional(number, null)
      net_core_netdev_max_backlog       = optional(number, null)
      net_core_optmem_max               = optional(number, null)
      net_core_rmem_default             = optional(number, null)
      net_core_rmem_max                 = optional(number, null)
      net_core_somaxconn                = optional(number, null)
      net_core_wmem_default             = optional(number, null)
      net_core_wmem_max                 = optional(number, null)
      net_ipv4_ip_local_port_range_max  = optional(number, null)
      net_ipv4_ip_local_port_range_min  = optional(number, null)
      net_ipv4_neigh_default_gc_thresh1 = optional(number, null)
      net_ipv4_neigh_default_gc_thresh2 = optional(number, null)
      net_ipv4_neigh_default_gc_thresh3 = optional(number, null)
      net_ipv4_tcp_fin_timeout          = optional(number, null)
      net_ipv4_tcp_keepalive_intvl      = optional(number, null)
      net_ipv4_tcp_keepalive_probes     = optional(number, null)
      net_ipv4_tcp_keepalive_time       = optional(number, null)
      net_ipv4_tcp_max_syn_backlog      = optional(number, null)
      net_ipv4_tcp_max_tw_buckets       = optional(number, null)
      vm_max_map_count                  = optional(number, null)
      vm_swappiness                     = optional(number, null)
      vm_vfs_cache_pressure             = optional(number, null)
    })
  }))

  default = [
    {
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
      sysctl_config             = null
    }
  ]

  description = <<EOF
  Available sysctl parameters and their value ranges:

    - fs_aio_max_nr: Minimum 65536, Maximum 6553500
    - fs_file_max: Minimum 8192, Maximum 12000500
    - fs_inotify_max_user_watches: Minimum 781250, Maximum 2097152
    - fs_nr_open: Minimum 8192, Maximum 20000500
    - kernel_threads_max: Minimum 20, Maximum 513785
    - net_core_netdev_max_backlog: Minimum 1000, Maximum 3240000
    - net_core_optmem_max: Minimum 20480, Maximum 4194304
    - net_core_rmem_default: Minimum 212992, Maximum 134217728
    - net_core_rmem_max: Minimum 212992, Maximum 134217728
    - net_core_somaxconn: Minimum 4096, Maximum 3240000
    - net_core_wmem_default: Minimum 212992, Maximum 134217728
    - net_core_wmem_max: Minimum 212992, Maximum 134217728
    - net_ipv4_ip_local_port_range_max: Minimum 32768, Maximum 65535
    - net_ipv4_ip_local_port_range_min: Minimum 1024, Maximum 60999
    - net_ipv4_neigh_default_gc_thresh1: Minimum 128, Maximum 80000
    - net_ipv4_neigh_default_gc_thresh2: Minimum 512, Maximum 90000
    - net_ipv4_neigh_default_gc_thresh3: Minimum 1024, Maximum 100000
    - net_ipv4_tcp_fin_timeout: Minimum 5, Maximum 120
    - net_ipv4_tcp_keepalive_intvl: Minimum 10, Maximum 90
    - net_ipv4_tcp_keepalive_probes: Minimum 1, Maximum 15
    - net_ipv4_tcp_keepalive_time: Minimum 30, Maximum 432000
    - net_ipv4_tcp_max_syn_backlog: Minimum 128, Maximum 3240000
    - net_ipv4_tcp_max_tw_buckets: Minimum 8000, Maximum 1440000
    - vm_max_map_count: Minimum 65530, Maximum 262144
    - vm_swappiness: Minimum 0, Maximum 100
    - vm_vfs_cache_pressure: Minimum 0, Maximum 100

  Set these values as needed for system performance and tuning. Values left as "null" will not be applied.
  EOF
}


variable "pe_subnet_name" {
  type        = string
  description = "The subnet name, used in data source to get subnet ID, to enable the private endpoint."
}

variable "grafana_enabled" {
  type        = bool
  default     = true
  description = "Indicates whether the Grafana instance should be enabled."
}

variable "api_key_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether the API key should be enabled for the Grafana instance."
}

variable "grafana_major_version" {
  type        = string
  default     = "10"
  description = "The major version of Grafana to use. Possible values are 9 and 10."
}

variable "sku" {
  type        = string
  default     = "Standard"
  description = "The SKU of the Grafana instance. Possible values are Essential and Standard."

}

variable "zone_redundancy_enabled" {
  type        = bool
  default     = true
  description = "Indicates whether zone redundancy should be enabled for the Grafana instance."
}

variable "deterministic_outbound_ip_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether the deterministic outbound IP should be enabled for the Grafana instance. Only use it in case you cant use private connection to the datasources."

}

variable "smtp_enable" {
  type        = bool
  default     = false
  description = "Indicates whether the SMTP should be enabled for the Grafana instance."

}

variable "identity_type" {
  type        = string
  default     = "SystemAssigned"
  description = "The identity type for the Grafana instance. Possible values are SystemAssigned and UserAssigned."

}

variable "azure_monitor_workspace_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether the Azure Monitor workspace should be enabled for the Grafana instance."

}

variable "admin_groups" {
  type        = list(string)
  default     = []
  description = "The list of Azure AD groups that should be assigned the Grafana Admin role."

}

variable "container_Insights_data_collection_interval" {
  default = "5m"
  type    = string
}

variable "container_Insights_namespace_filtering_mode_for_data_collection" {
  default     = "Exclude"
  description = "value can be 'Off' or 'Exclude'"
  type        = string
}

variable "container_Insights_namespaces_for_data_collection" {
  default = ["kube-system", "gatekeeper-system", "azure-arc"]
  type    = list(string)
}

variable "container_Insights_streams" {
  default     = ["Microsoft-ContainerInsights-Group-Default"]
  description = "value can be ['Microsoft-ContainerLog', 'Microsoft-ContainerLogV2', 'Microsoft-KubeEvents', 'Microsoft-KubePodInventory', 'Microsoft-KubeNodeInventory', 'Microsoft-KubePVInventory','Microsoft-KubeServices', 'Microsoft-KubeMonAgentEvents', 'Microsoft-InsightsMetrics', 'Microsoft-ContainerInventory',  'Microsoft-ContainerNodeInventory', 'Microsoft-Perf']"
  type        = list(string)
}

variable "container_Insights_enableContainerLogV2" {
  default     = true
  description = "Enable ContainerLogV2"
  type        = bool

}

#Prometheus variables

variable "enable_prometheus" {
  type        = bool
  default     = false
  description = "Indicates whether the Prometheus rules should be enabled."

}

variable "default_node_recording_rules_rule_group_enabled" {
  type        = bool
  default     = true
  description = "Indicates whether the default node recording rules rule group should be enabled."

}

variable "default_kubernetes_recording_rules_rule_group_enabled" {
  type        = bool
  default     = true
  description = "Indicates whether the default kubernetes recording rules rule group should be enabled."

}

variable "role_assignments_writer" {
  type = list(object({
    group_names = list(string)
    namespaces  = list(string)
  }))
  default     = []
  description = "The role assignments to create with each group and namespace"
}

variable "role_assignments_reader" {
  type = list(object({
    group_names = list(string)
    namespaces  = list(string)
  }))
  default     = []
  description = "The role assignments to create with each group and namespace"
}

#AKS BACKUP

# Purpose: Define the variables that will be used in the terraform configuration

variable "enable_azure_backup" {
  type        = bool
  default     = false
  description = "Indicates whether the Azure Backup Vault should be enabled for backing up this AKS cluster."

}

variable "datastore_type" {
  type        = string
  default     = "VaultStore"
  description = <<EOF
  (Required) Specifies the type of the data store. Possible values are ArchiveStore, OperationalStore, and VaultStore. Changing this forces a new resource to be created
  *VaultStore*: It stores backups in the Azure Blob service,It's designed to provide high availability for backup data. Vault Store provides good performance for backup and recovery operations.
  *SnapshotStore*: It is used for frequent backups and is crucial when the ability to quickly capture and recover from point-in-time changes is important.
  *ArchiveStore*: It is used for a long time, especially for data that is rarely accessed and has extended retention periods, ArchiveStore is a cost-effective option.
  EOF
}

variable "redundancy" {
  type        = string
  default     = "GeoRedundant"
  description = "(Required) Specifies the backup storage redundancy. Possible values are GeoRedundant, LocallyRedundant and ZoneRedundant. Changing this forces a new Backup Vault to be created. "

}

variable "cross_region_restore_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Specifies whether cross-region restore is enabled. Changing this forces a new Backup Vault to be created."

}

variable "retention_duration_in_days" {
  type        = number
  default     = 14
  description = "(Optional) Specifies the retention duration for the backup data in days. Changing this forces a new Backup Vault to be created."

}

variable "soft_delete" {
  type        = string
  default     = "Off"
  description = "(Optional) Specifies whether soft delete is enabled. Changing this forces a new Backup Vault to be created."

}


variable "kubernetes_cluster_backup_policy" {
  type = list(object({
    kubernetes_cluster_backup_policy_name = string
    resource_group_name                   = string
    vault_name                            = string
    backup_repeating_time_intervals       = optional(list(string))
    time_zone                             = optional(string)
    default_retention_rule = optional(object({
      lifecycle = object({
        duration = string
      })
    }))
    retention_rule = optional(list(object({
      name     = string
      priority = number
      criteria = optional(object({
        absolute_criteria      = optional(string)
        days_of_week           = optional(list(string))
        months_of_year         = optional(list(string))
        scheduled_backup_times = optional(list(string))
        weeks_of_month         = optional(list(string))
      }))
      lifecycle = object({
        duration = string
      })
    })))
  }))
  description = <<EOF
Specifies the backup policy for Kubernetes clusters. This variable allows you to define a list of backup policies with detailed attributes. Changing any of these attributes forces the creation of a new Backup Policy for the Kubernetes cluster.

Attributes:
- **kubernetes_cluster_backup_policy_name** (Required): The name of the backup policy. Changing this forces a new Backup Policy to be created.
- **resource_group_name** (Required): The name of the Azure Resource Group where the Kubernetes cluster resides.
- **vault_name** (Required): The name of the backup vault associated with the policy.
- **backup_repeating_time_intervals** (Optional): A list of repeating time intervals for backups. These intervals must adhere to the ISO 8601 repeating interval format. Changing this forces a new Backup Policy to be created.
- **time_zone** (Optional): Specifies the time zone to be used by the backup schedule. Changing this forces a new Backup Policy to be created.
- **retention_rule** (Optional): Defines the retention rules for the backup policy, including:
  - **name** (Required): The name of the retention rule.
  - **priority** (Required): The priority of the retention rule.
  - **criteria** (Optional): Specifies additional criteria for the retention rule, including:
    - **absolute_criteria** (Optional): Specifies an optional absolute criteria string.
    - **days_of_week** (Optional): A list of days of the week for the backup schedule.
    - **months_of_year** (Optional): A list of months of the year for the backup schedule.
    - **scheduled_backup_times** (Optional): A list of specific backup times in HH:mm:ss format.
    - **weeks_of_month** (Optional): A list of weeks of the month for the backup schedule.
  - **lifecycle** (Required): Specifies lifecycle management settings for the retention rule, including:
    - **duration** (Required): The duration for lifecycle management, following the ISO 8601 duration format.

Note: Changing any of these attributes forces a new Backup Policy to be created for the specified Kubernetes cluster.
EOF
}

variable "kubernetes_cluster_backup_config" {
  type = list(object({
    resource_group_name                   = string
    kubernetes_cluster_backup_policy_name = string
    kubernetes_cluster_name               = string
    backup_datasource_parameters = object({
      excluded_namespaces              = list(string)
      excluded_resource_types          = list(string)
      cluster_scoped_resources_enabled = bool
      included_namespaces              = optional(list(string))
      included_resource_types          = list(string)
      label_selectors                  = list(string)
      volume_snapshot_enabled          = bool
    })
  }))
  default = []

  description = <<EOF
Specifies the configuration for Kubernetes cluster backups. This variable defines a list of backup configurations, associating Kubernetes cluster resources with their respective backup policies.

Attributes:
- **kubernetes_cluster_name** (Required): The name of the Kubernetes cluster. This must be unique within the context of your Terraform configuration.
- **resource_group_name** (Required): The name of the Azure Resource Group where the Kubernetes cluster resides.
- **kubernetes_cluster_backup_policy_name** (Required): The name of the backup policy to be applied to the Kubernetes cluster. This should correspond to an existing backup policy defined within your Azure environment.

Default: An empty list, meaning no backup configurations are defined unless explicitly specified.

Note: Changing the attributes in this variable will force updates to the associated backup configurations.
EOF
}


variable "kubernetes_cluster_storage_account_config" {
  type = object({
    kubernetes_cluster_backup_storage_account_name                = optional(string)
    kubernetes_cluster_backup_storage_account_resource_group_name = optional(string)
    kubernetes_cluster_backup_storage_account_blob_name           = optional(string)
  })
  default = {}

  description = <<EOF
Specifies the configuration for Kubernetes cluster storage accounts used for backups. This variable defines the necessary attributes to associate Kubernetes cluster resources with their respective Azure storage accounts for backup purposes.

Attributes:
- **kubernetes_cluster_backup_storage_account_name** (Required): The name of the Azure Storage Account used for Kubernetes cluster backups.
- **kubernetes_cluster_backup_storage_account_resource_group_name** (Required): The name of the Azure Resource Group where the storage account is located.
- **kubernetes_cluster_backup_storage_account_blob_name** (Required): The name of the blob container within the storage account where the backups will be stored.

Default: An empty object, indicating no storage account configurations are defined unless explicitly specified.

Note: Modifying these attributes will trigger updates to the associated Kubernetes cluster backup configurations in Terraform.
EOF
}

```

<!-- BEGIN_TF_DOCS -->
### main.tf

```hcl
terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.14.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.1.0"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}

provider "azuread" {}
```

----------------------------

# Input Description

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |  

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~> 3.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |  

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_axso_dashboard_grafana"></a> [axso\_dashboard\_grafana](#module\_axso\_dashboard\_grafana) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_dashboard_grafana | v1.2.0 |
| <a name="module_axso_monitor_prometheus"></a> [axso\_monitor\_prometheus](#module\_axso\_monitor\_prometheus) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_monitor_prometheus | v1.1.3 |
| <a name="module_data_protection_backup_vault"></a> [data\_protection\_backup\_vault](#module\_data\_protection\_backup\_vault) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_data_protection_backup | feature/mmdiez |  

## Resources

| Name | Type |
|------|------|
| [azurerm_disk_encryption_set.disk_encryption_set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set) | resource |
| [azurerm_federated_identity_credential.federated_identity_credential](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_key_vault_key.key_vault_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_node_pool.node_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_monitor_data_collection_endpoint.dce](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_endpoint) | resource |
| [azurerm_monitor_data_collection_rule.monitor_data_collection_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule) | resource |
| [azurerm_monitor_data_collection_rule.monitor_data_collection_rule_msci](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule) | resource |
| [azurerm_monitor_data_collection_rule_association.dcra_msci](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule_association) | resource |
| [azurerm_monitor_data_collection_rule_association.dcra_msprom_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule_association) | resource |
| [azurerm_role_assignment.acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks-admin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks-admin-spi](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks-reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks-vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_secretprovider_keyvault_certificates](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_secretprovider_keyvault_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_uai_route_table_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.loga](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.rbac_aks_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.rbac_aks_writer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.role_assignmen_user_assigned_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.role_assignment_keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.des_user_assigned_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.user_assigned_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.workload_assigned_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [random_string.string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azuread_group.azuread_group_admin](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.azuread_group_readers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.group_objects_reader](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.group_objects_writer](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_log_analytics_workspace.log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_user_assigned_identity.user_assigned_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |
| [azurerm_virtual_network.aks_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_name"></a> [acr\_name](#input\_acr\_name) | Name of the Container registry | `string` | `null` | no |
| <a name="input_acr_resource_group_name"></a> [acr\_resource\_group\_name](#input\_acr\_resource\_group\_name) | Name of the resource group where the container registry is deployed | `string` | `null` | no |
| <a name="input_acr_subscription_id"></a> [acr\_subscription\_id](#input\_acr\_subscription\_id) | Id of the subscription where the container registry is deployed | `string` | `null` | no |
| <a name="input_admin_groups"></a> [admin\_groups](#input\_admin\_groups) | The list of Azure AD groups that should be assigned the Grafana Admin role. | `list(string)` | `[]` | no |
| <a name="input_agents_availability_zones"></a> [agents\_availability\_zones](#input\_agents\_availability\_zones) | (Optional) A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created. | `list(string)` | <pre>[<br>  "1",<br>  "2",<br>  "3"<br>]</pre> | no |
| <a name="input_agents_type"></a> [agents\_type](#input\_agents\_type) | (Optional) The type of Node Pool which should be created. Possible values are AvailabilitySet and VirtualMachineScaleSets. Defaults to VirtualMachineScaleSets. | `string` | `"VirtualMachineScaleSets"` | no |
| <a name="input_aks_loga_name"></a> [aks\_loga\_name](#input\_aks\_loga\_name) | (Required) The name of the Log Analytics Workspace which the OMS Agent should send data to. | `string` | `"Log Analytics Workspace Name"` | no |
| <a name="input_aks_subnet_name"></a> [aks\_subnet\_name](#input\_aks\_subnet\_name) | (Optional) The name of a Subnet where the Kubernetes Node Pool should exist. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_api_key_enabled"></a> [api\_key\_enabled](#input\_api\_key\_enabled) | Indicates whether the API key should be enabled for the Grafana instance. | `bool` | `false` | no |
| <a name="input_azure_monitor_workspace_enabled"></a> [azure\_monitor\_workspace\_enabled](#input\_azure\_monitor\_workspace\_enabled) | Indicates whether the Azure Monitor workspace should be enabled for the Grafana instance. | `bool` | `false` | no |
| <a name="input_azuread_group_admin_names"></a> [azuread\_group\_admin\_names](#input\_azuread\_group\_admin\_names) | The owner/s groups of the AAD groups to associate with the  aks owner group. | `list(string)` | <pre>[<br>  "CL-AXSO-AZ-SUB-cloudinfra-nonprod-Owner"<br>]</pre> | no |
| <a name="input_azuread_group_readers_names"></a> [azuread\_group\_readers\_names](#input\_azuread\_group\_readers\_names) | The reader/s groups of the AAD groups to associate with the  aks reader group. | `list(string)` | <pre>[<br>  "CL-AXSO-AZ-SUB-cloudinfra-nonprod-Owner"<br>]</pre> | no |
| <a name="input_container_Insights_data_collection_interval"></a> [container\_Insights\_data\_collection\_interval](#input\_container\_Insights\_data\_collection\_interval) | n/a | `string` | `"5m"` | no |
| <a name="input_container_Insights_enableContainerLogV2"></a> [container\_Insights\_enableContainerLogV2](#input\_container\_Insights\_enableContainerLogV2) | Enable ContainerLogV2 | `bool` | `true` | no |
| <a name="input_container_Insights_namespace_filtering_mode_for_data_collection"></a> [container\_Insights\_namespace\_filtering\_mode\_for\_data\_collection](#input\_container\_Insights\_namespace\_filtering\_mode\_for\_data\_collection) | value can be 'Off' or 'Exclude' | `string` | `"Exclude"` | no |
| <a name="input_container_Insights_namespaces_for_data_collection"></a> [container\_Insights\_namespaces\_for\_data\_collection](#input\_container\_Insights\_namespaces\_for\_data\_collection) | n/a | `list(string)` | <pre>[<br>  "kube-system",<br>  "gatekeeper-system",<br>  "azure-arc"<br>]</pre> | no |
| <a name="input_container_Insights_streams"></a> [container\_Insights\_streams](#input\_container\_Insights\_streams) | value can be ['Microsoft-ContainerLog', 'Microsoft-ContainerLogV2', 'Microsoft-KubeEvents', 'Microsoft-KubePodInventory', 'Microsoft-KubeNodeInventory', 'Microsoft-KubePVInventory','Microsoft-KubeServices', 'Microsoft-KubeMonAgentEvents', 'Microsoft-InsightsMetrics', 'Microsoft-ContainerInventory',  'Microsoft-ContainerNodeInventory', 'Microsoft-Perf'] | `list(string)` | <pre>[<br>  "Microsoft-ContainerInsights-Group-Default"<br>]</pre> | no |
| <a name="input_cross_region_restore_enabled"></a> [cross\_region\_restore\_enabled](#input\_cross\_region\_restore\_enabled) | (Optional) Specifies whether cross-region restore is enabled. Changing this forces a new Backup Vault to be created. | `bool` | `false` | no |
| <a name="input_custom_kubernetes_recording_rules_rule_group"></a> [custom\_kubernetes\_recording\_rules\_rule\_group](#input\_custom\_kubernetes\_recording\_rules\_rule\_group) | (Optional) The custom kubernetes recording rules rule group. Defaults to "". | <pre>list(object({<br>    record     = string<br>    expression = string<br>  }))</pre> | `[]` | no |
| <a name="input_custom_kubernetes_recording_rules_rule_group_enabled"></a> [custom\_kubernetes\_recording\_rules\_rule\_group\_enabled](#input\_custom\_kubernetes\_recording\_rules\_rule\_group\_enabled) | Indicates whether the custom kubernetes recording rules rule group should be enabled. | `bool` | `false` | no |
| <a name="input_datastore_type"></a> [datastore\_type](#input\_datastore\_type) | (Required) Specifies the type of the data store. Possible values are ArchiveStore, OperationalStore, and VaultStore. Changing this forces a new resource to be created<br>  *VaultStore*: It stores backups in the Azure Blob service,It's designed to provide high availability for backup data. Vault Store provides good performance for backup and recovery operations.<br>  *SnapshotStore*: It is used for frequent backups and is crucial when the ability to quickly capture and recover from point-in-time changes is important.<br>  *ArchiveStore*: It is used for a long time, especially for data that is rarely accessed and has extended retention periods, ArchiveStore is a cost-effective option. | `string` | `"VaultStore"` | no |
| <a name="input_default_kubernetes_recording_rules_rule_group_enabled"></a> [default\_kubernetes\_recording\_rules\_rule\_group\_enabled](#input\_default\_kubernetes\_recording\_rules\_rule\_group\_enabled) | Indicates whether the default kubernetes recording rules rule group should be enabled. | `bool` | `true` | no |
| <a name="input_default_node_recording_rules_rule_group_enabled"></a> [default\_node\_recording\_rules\_rule\_group\_enabled](#input\_default\_node\_recording\_rules\_rule\_group\_enabled) | Indicates whether the default node recording rules rule group should be enabled. | `bool` | `true` | no |
| <a name="input_deterministic_outbound_ip_enabled"></a> [deterministic\_outbound\_ip\_enabled](#input\_deterministic\_outbound\_ip\_enabled) | Indicates whether the deterministic outbound IP should be enabled for the Grafana instance. Only use it in case you cant use private connection to the datasources. | `bool` | `false` | no |
| <a name="input_dns_prefix"></a> [dns\_prefix](#input\_dns\_prefix) | (Optional) DNS prefix specified when creating the managed cluster. Possible values must begin and end with a letter or number, contain only letters, numbers, and hyphens and be between 1 and 54 characters in length. Changing this forces a new resource to be created | `string` | `"axpo-aks"` | no |
| <a name="input_enable_azure_backup"></a> [enable\_azure\_backup](#input\_enable\_azure\_backup) | Indicates whether the Azure Backup Vault should be enabled for backing up this AKS cluster. | `bool` | `false` | no |
| <a name="input_enable_prometheus"></a> [enable\_prometheus](#input\_enable\_prometheus) | Indicates whether the Prometheus rules should be enabled. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"prod"` | no |
| <a name="input_grafana_enabled"></a> [grafana\_enabled](#input\_grafana\_enabled) | Indicates whether the Grafana instance should be enabled. | `bool` | `true` | no |
| <a name="input_grafana_major_version"></a> [grafana\_major\_version](#input\_grafana\_major\_version) | The major version of Grafana to use. Possible values are 9 and 10. | `string` | `"10"` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | The identity type for the Grafana instance. Possible values are SystemAssigned and UserAssigned. | `string` | `"SystemAssigned"` | no |
| <a name="input_image_cleaner_enabled"></a> [image\_cleaner\_enabled](#input\_image\_cleaner\_enabled) | Indicates whether the image cleaner should be enabled. | `bool` | `false` | no |
| <a name="input_image_cleaner_interval_hours"></a> [image\_cleaner\_interval\_hours](#input\_image\_cleaner\_interval\_hours) | The interval in hours at which the image cleaner should run. | `number` | `24` | no |
| <a name="input_is_enabled_auto_scaling"></a> [is\_enabled\_auto\_scaling](#input\_is\_enabled\_auto\_scaling) | Auto scalling is set to True or False | `bool` | `"true"` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | The name of the Key Vault to associate with the Disk Encryption Set. Changing this forces a new resource to be created. | `string` | `"axso-np-appl-<project-name>-<environment>-kv"` | no |
| <a name="input_kubernetes_cluster_backup_config"></a> [kubernetes\_cluster\_backup\_config](#input\_kubernetes\_cluster\_backup\_config) | Specifies the configuration for Kubernetes cluster backups. This variable defines a list of backup configurations, associating Kubernetes cluster resources with their respective backup policies.<br><br>Attributes:<br>- **kubernetes\_cluster\_name** (Required): The name of the Kubernetes cluster. This must be unique within the context of your Terraform configuration.<br>- **resource\_group\_name** (Required): The name of the Azure Resource Group where the Kubernetes cluster resides.<br>- **kubernetes\_cluster\_backup\_policy\_name** (Required): The name of the backup policy to be applied to the Kubernetes cluster. This should correspond to an existing backup policy defined within your Azure environment.<br><br>Default: An empty list, meaning no backup configurations are defined unless explicitly specified.<br><br>Note: Changing the attributes in this variable will force updates to the associated backup configurations. | <pre>list(object({<br>    resource_group_name                   = string<br>    kubernetes_cluster_backup_policy_name = string<br>    kubernetes_cluster_name               = string<br>    backup_datasource_parameters = object({<br>      excluded_namespaces              = list(string)<br>      excluded_resource_types          = list(string)<br>      cluster_scoped_resources_enabled = bool<br>      included_namespaces              = optional(list(string))<br>      included_resource_types          = list(string)<br>      label_selectors                  = list(string)<br>      volume_snapshot_enabled          = bool<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_kubernetes_cluster_backup_policy"></a> [kubernetes\_cluster\_backup\_policy](#input\_kubernetes\_cluster\_backup\_policy) | Specifies the backup policy for Kubernetes clusters. This variable allows you to define a list of backup policies with detailed attributes. Changing any of these attributes forces the creation of a new Backup Policy for the Kubernetes cluster.<br><br>Attributes:<br>- **kubernetes\_cluster\_backup\_policy\_name** (Required): The name of the backup policy. Changing this forces a new Backup Policy to be created.<br>- **resource\_group\_name** (Required): The name of the Azure Resource Group where the Kubernetes cluster resides.<br>- **vault\_name** (Required): The name of the backup vault associated with the policy.<br>- **backup\_repeating\_time\_intervals** (Optional): A list of repeating time intervals for backups. These intervals must adhere to the ISO 8601 repeating interval format. Changing this forces a new Backup Policy to be created.<br>- **time\_zone** (Optional): Specifies the time zone to be used by the backup schedule. Changing this forces a new Backup Policy to be created.<br>- **retention\_rule** (Optional): Defines the retention rules for the backup policy, including:<br>  - **name** (Required): The name of the retention rule.<br>  - **priority** (Required): The priority of the retention rule.<br>  - **criteria** (Optional): Specifies additional criteria for the retention rule, including:<br>    - **absolute\_criteria** (Optional): Specifies an optional absolute criteria string.<br>    - **days\_of\_week** (Optional): A list of days of the week for the backup schedule.<br>    - **months\_of\_year** (Optional): A list of months of the year for the backup schedule.<br>    - **scheduled\_backup\_times** (Optional): A list of specific backup times in HH:mm:ss format.<br>    - **weeks\_of\_month** (Optional): A list of weeks of the month for the backup schedule.<br>  - **lifecycle** (Required): Specifies lifecycle management settings for the retention rule, including:<br>    - **duration** (Required): The duration for lifecycle management, following the ISO 8601 duration format.<br><br>Note: Changing any of these attributes forces a new Backup Policy to be created for the specified Kubernetes cluster. | <pre>list(object({<br>    kubernetes_cluster_backup_policy_name = string<br>    resource_group_name                   = string<br>    vault_name                            = string<br>    backup_repeating_time_intervals       = optional(list(string))<br>    time_zone                             = optional(string)<br>    default_retention_rule = optional(object({<br>      lifecycle = object({<br>        duration = string<br>      })<br>    }))<br>    retention_rule = optional(list(object({<br>      name     = string<br>      priority = number<br>      criteria = optional(object({<br>        absolute_criteria      = optional(string)<br>        days_of_week           = optional(list(string))<br>        months_of_year         = optional(list(string))<br>        scheduled_backup_times = optional(list(string))<br>        weeks_of_month         = optional(list(string))<br>      }))<br>      lifecycle = object({<br>        duration = string<br>      })<br>    })))<br>  }))</pre> | n/a | yes |
| <a name="input_kubernetes_cluster_storage_account_config"></a> [kubernetes\_cluster\_storage\_account\_config](#input\_kubernetes\_cluster\_storage\_account\_config) | Specifies the configuration for Kubernetes cluster storage accounts used for backups. This variable defines the necessary attributes to associate Kubernetes cluster resources with their respective Azure storage accounts for backup purposes.<br><br>Attributes:<br>- **kubernetes\_cluster\_backup\_storage\_account\_name** (Required): The name of the Azure Storage Account used for Kubernetes cluster backups.<br>- **kubernetes\_cluster\_backup\_storage\_account\_resource\_group\_name** (Required): The name of the Azure Resource Group where the storage account is located.<br>- **kubernetes\_cluster\_backup\_storage\_account\_blob\_name** (Required): The name of the blob container within the storage account where the backups will be stored.<br><br>Default: An empty object, indicating no storage account configurations are defined unless explicitly specified.<br><br>Note: Modifying these attributes will trigger updates to the associated Kubernetes cluster backup configurations in Terraform. | <pre>object({<br>    kubernetes_cluster_backup_storage_account_name                = optional(string)<br>    kubernetes_cluster_backup_storage_account_resource_group_name = optional(string)<br>    kubernetes_cluster_backup_storage_account_blob_name           = optional(string)<br>  })</pre> | `{}` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes cluster version | `string` | `"1.30.5"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location where the Managed Kubernetes Cluster should be created. Changing this forces a new resource to be created. | `string` | `"west europe"` | no |
| <a name="input_max_count"></a> [max\_count](#input\_max\_count) | (Optional) The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000 | `number` | `4` | no |
| <a name="input_min_count"></a> [min\_count](#input\_min\_count) | (Optional) The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000. | `number` | `3` | no |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | Name of the resource group where virtual network has been deployed | `string` | `""` | no |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | (Optional) The initial number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000 and between min\_count and max\_count. | `number` | `3` | no |
| <a name="input_oidc_issuer_enabled"></a> [oidc\_issuer\_enabled](#input\_oidc\_issuer\_enabled) | (Optional) Enable or Disable the OIDC issuer URL | `bool` | `false` | no |
| <a name="input_os_disk_size_gb"></a> [os\_disk\_size\_gb](#input\_os\_disk\_size\_gb) | Optional) The size of the OS Disk which should be used for each agent in the Node Pool. temporary\_name\_for\_rotation must be specified when attempting a change. | `string` | `"32"` | no |
| <a name="input_patch_setting"></a> [patch\_setting](#input\_patch\_setting) | (Optional) The upgrade channel for this Kubernetes Cluster. Possible values are patch, rapid, node-image and stable. Omitting this field sets this value to none. | `string` | `null` | no |
| <a name="input_pe_subnet_name"></a> [pe\_subnet\_name](#input\_pe\_subnet\_name) | The subnet name, used in data source to get subnet ID, to enable the private endpoint. | `string` | n/a | yes |
| <a name="input_pool_names"></a> [pool\_names](#input\_pool\_names) | Available sysctl parameters and their value ranges:<br><br>    - fs\_aio\_max\_nr: Minimum 65536, Maximum 6553500<br>    - fs\_file\_max: Minimum 8192, Maximum 12000500<br>    - fs\_inotify\_max\_user\_watches: Minimum 781250, Maximum 2097152<br>    - fs\_nr\_open: Minimum 8192, Maximum 20000500<br>    - kernel\_threads\_max: Minimum 20, Maximum 513785<br>    - net\_core\_netdev\_max\_backlog: Minimum 1000, Maximum 3240000<br>    - net\_core\_optmem\_max: Minimum 20480, Maximum 4194304<br>    - net\_core\_rmem\_default: Minimum 212992, Maximum 134217728<br>    - net\_core\_rmem\_max: Minimum 212992, Maximum 134217728<br>    - net\_core\_somaxconn: Minimum 4096, Maximum 3240000<br>    - net\_core\_wmem\_default: Minimum 212992, Maximum 134217728<br>    - net\_core\_wmem\_max: Minimum 212992, Maximum 134217728<br>    - net\_ipv4\_ip\_local\_port\_range\_max: Minimum 32768, Maximum 65535<br>    - net\_ipv4\_ip\_local\_port\_range\_min: Minimum 1024, Maximum 60999<br>    - net\_ipv4\_neigh\_default\_gc\_thresh1: Minimum 128, Maximum 80000<br>    - net\_ipv4\_neigh\_default\_gc\_thresh2: Minimum 512, Maximum 90000<br>    - net\_ipv4\_neigh\_default\_gc\_thresh3: Minimum 1024, Maximum 100000<br>    - net\_ipv4\_tcp\_fin\_timeout: Minimum 5, Maximum 120<br>    - net\_ipv4\_tcp\_keepalive\_intvl: Minimum 10, Maximum 90<br>    - net\_ipv4\_tcp\_keepalive\_probes: Minimum 1, Maximum 15<br>    - net\_ipv4\_tcp\_keepalive\_time: Minimum 30, Maximum 432000<br>    - net\_ipv4\_tcp\_max\_syn\_backlog: Minimum 128, Maximum 3240000<br>    - net\_ipv4\_tcp\_max\_tw\_buckets: Minimum 8000, Maximum 1440000<br>    - vm\_max\_map\_count: Minimum 65530, Maximum 262144<br>    - vm\_swappiness: Minimum 0, Maximum 100<br>    - vm\_vfs\_cache\_pressure: Minimum 0, Maximum 100<br><br>  Set these values as needed for system performance and tuning. Values left as "null" will not be applied. | <pre>list(object({<br>    name                      = string<br>    subnet_name               = string<br>    node_count                = number<br>    vm_size                   = string<br>    os_type                   = string<br>    os_sku                    = string<br>    os_disk_size_gb           = string<br>    max_pods                  = number<br>    enable_auto_scaling       = bool<br>    min_count                 = number<br>    max_count                 = number<br>    pool_mode                 = string<br>    agents_availability_zones = list(string)<br>    sysctl_config = object({<br>      fs_aio_max_nr                     = optional(number, null)<br>      fs_file_max                       = optional(number, null)<br>      fs_inotify_max_user_watches       = optional(number, null)<br>      fs_nr_open                        = optional(number, null)<br>      kernel_threads_max                = optional(number, null)<br>      net_core_netdev_max_backlog       = optional(number, null)<br>      net_core_optmem_max               = optional(number, null)<br>      net_core_rmem_default             = optional(number, null)<br>      net_core_rmem_max                 = optional(number, null)<br>      net_core_somaxconn                = optional(number, null)<br>      net_core_wmem_default             = optional(number, null)<br>      net_core_wmem_max                 = optional(number, null)<br>      net_ipv4_ip_local_port_range_max  = optional(number, null)<br>      net_ipv4_ip_local_port_range_min  = optional(number, null)<br>      net_ipv4_neigh_default_gc_thresh1 = optional(number, null)<br>      net_ipv4_neigh_default_gc_thresh2 = optional(number, null)<br>      net_ipv4_neigh_default_gc_thresh3 = optional(number, null)<br>      net_ipv4_tcp_fin_timeout          = optional(number, null)<br>      net_ipv4_tcp_keepalive_intvl      = optional(number, null)<br>      net_ipv4_tcp_keepalive_probes     = optional(number, null)<br>      net_ipv4_tcp_keepalive_time       = optional(number, null)<br>      net_ipv4_tcp_max_syn_backlog      = optional(number, null)<br>      net_ipv4_tcp_max_tw_buckets       = optional(number, null)<br>      vm_max_map_count                  = optional(number, null)<br>      vm_swappiness                     = optional(number, null)<br>      vm_vfs_cache_pressure             = optional(number, null)<br>    })<br>  }))</pre> | <pre>[<br>  {<br>    "agents_availability_zones": [<br>      "2"<br>    ],<br>    "enable_auto_scaling": true,<br>    "max_count": 3,<br>    "max_pods": 110,<br>    "min_count": 2,<br>    "name": "userpool",<br>    "node_count": 2,<br>    "os_disk_size_gb": "30",<br>    "os_sku": "Ubuntu",<br>    "os_type": "Linux",<br>    "pool_mode": "User",<br>    "subnet_name": "default-subnet",<br>    "sysctl_config": null,<br>    "vm_size": "Standard_D2ads_v5"<br>  }<br>]</pre> | no |
| <a name="input_private_cluster_public_fqdn_enabled"></a> [private\_cluster\_public\_fqdn\_enabled](#input\_private\_cluster\_public\_fqdn\_enabled) | (Optional) Enable or Disable the public FQDN for the private cluster. Changing this forces a new resource to be created. | `bool` | `false` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS, etools, cp, cpm etc.. etc.. | `string` | `"etools"` | no |
| <a name="input_redundancy"></a> [redundancy](#input\_redundancy) | (Required) Specifies the backup storage redundancy. Possible values are GeoRedundant, LocallyRedundant and ZoneRedundant. Changing this forces a new Backup Vault to be created. | `string` | `"GeoRedundant"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) Specifies the Resource Group where the Managed Kubernetes Cluster should exist. Changing this forces a new resource to be created. | `string` | `"axso-np-appl-<project-name>-<environment>-rg"` | no |
| <a name="input_retention_duration_in_days"></a> [retention\_duration\_in\_days](#input\_retention\_duration\_in\_days) | (Optional) Specifies the retention duration for the backup data in days. Changing this forces a new Backup Vault to be created. | `number` | `14` | no |
| <a name="input_role_assignments_reader"></a> [role\_assignments\_reader](#input\_role\_assignments\_reader) | The role assignments to create with each group and namespace | <pre>list(object({<br>    group_names = list(string)<br>    namespaces  = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_role_assignments_writer"></a> [role\_assignments\_writer](#input\_role\_assignments\_writer) | The role assignments to create with each group and namespace | <pre>list(object({<br>    group_names = list(string)<br>    namespaces  = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_service_accounts"></a> [service\_accounts](#input\_service\_accounts) | The service accounts to create in the Kubernetes cluster for the workload identity | <pre>list(object({<br>    name                              = string<br>    namespace                         = string<br>    service_account_name              = string<br>    workload_assigned_identity_name   = string<br>    workload_assigned_identity_exists = optional(bool, false) # If the identity already exists, set this to true<br>  }))</pre> | `[]` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The SKU of the Grafana instance. Possible values are Essential and Standard. | `string` | `"Standard"` | no |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free, Standard (which includes the Uptime SLA) and Premium. Defaults to Standard | `string` | `"Standard"` | no |
| <a name="input_smtp_enable"></a> [smtp\_enable](#input\_smtp\_enable) | Indicates whether the SMTP should be enabled for the Grafana instance. | `bool` | `false` | no |
| <a name="input_soft_delete"></a> [soft\_delete](#input\_soft\_delete) | (Optional) Specifies whether soft delete is enabled. Changing this forces a new Backup Vault to be created. | `string` | `"Off"` | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' or 'np' | `string` | `"p"` | no |
| <a name="input_support_plan"></a> [support\_plan](#input\_support\_plan) | Kubernetes support Plan. If you used Long term support, use Premium Sku Tier | `string` | `"KubernetesOfficial"` | no |
| <a name="input_sysctl_config_system_pool"></a> [sysctl\_config\_system\_pool](#input\_sysctl\_config\_system\_pool) | Available sysctl parameters and their value ranges:<br><br>    - fs\_aio\_max\_nr: Minimum 65536, Maximum 6553500<br>    - fs\_file\_max: Minimum 8192, Maximum 12000500<br>    - fs\_inotify\_max\_user\_watches: Minimum 781250, Maximum 2097152<br>    - fs\_nr\_open: Minimum 8192, Maximum 20000500<br>    - kernel\_threads\_max: Minimum 20, Maximum 513785<br>    - net\_core\_netdev\_max\_backlog: Minimum 1000, Maximum 3240000<br>    - net\_core\_optmem\_max: Minimum 20480, Maximum 4194304<br>    - net\_core\_rmem\_default: Minimum 212992, Maximum 134217728<br>    - net\_core\_rmem\_max: Minimum 212992, Maximum 134217728<br>    - net\_core\_somaxconn: Minimum 4096, Maximum 3240000<br>    - net\_core\_wmem\_default: Minimum 212992, Maximum 134217728<br>    - net\_core\_wmem\_max: Minimum 212992, Maximum 134217728<br>    - net\_ipv4\_ip\_local\_port\_range\_max: Minimum 32768, Maximum 65535<br>    - net\_ipv4\_ip\_local\_port\_range\_min: Minimum 1024, Maximum 60999<br>    - net\_ipv4\_neigh\_default\_gc\_thresh1: Minimum 128, Maximum 80000<br>    - net\_ipv4\_neigh\_default\_gc\_thresh2: Minimum 512, Maximum 90000<br>    - net\_ipv4\_neigh\_default\_gc\_thresh3: Minimum 1024, Maximum 100000<br>    - net\_ipv4\_tcp\_fin\_timeout: Minimum 5, Maximum 120<br>    - net\_ipv4\_tcp\_keepalive\_intvl: Minimum 10, Maximum 90<br>    - net\_ipv4\_tcp\_keepalive\_probes: Minimum 1, Maximum 15<br>    - net\_ipv4\_tcp\_keepalive\_time: Minimum 30, Maximum 432000<br>    - net\_ipv4\_tcp\_max\_syn\_backlog: Minimum 128, Maximum 3240000<br>    - net\_ipv4\_tcp\_max\_tw\_buckets: Minimum 8000, Maximum 1440000<br>    - vm\_max\_map\_count: Minimum 65530, Maximum 262144<br>    - vm\_swappiness: Minimum 0, Maximum 100<br>    - vm\_vfs\_cache\_pressure: Minimum 0, Maximum 100<br><br>  Set these values as needed for system performance and tuning. Values left as "null" will not be applied. | <pre>object({<br>    fs_aio_max_nr                     = optional(number, null)<br>    fs_file_max                       = optional(number, null)<br>    fs_inotify_max_user_watches       = optional(number, null)<br>    fs_nr_open                        = optional(number, null)<br>    kernel_threads_max                = optional(number, null)<br>    net_core_netdev_max_backlog       = optional(number, null)<br>    net_core_optmem_max               = optional(number, null)<br>    net_core_rmem_default             = optional(number, null)<br>    net_core_rmem_max                 = optional(number, null)<br>    net_core_somaxconn                = optional(number, null)<br>    net_core_wmem_default             = optional(number, null)<br>    net_core_wmem_max                 = optional(number, null)<br>    net_ipv4_ip_local_port_range_max  = optional(number, null)<br>    net_ipv4_ip_local_port_range_min  = optional(number, null)<br>    net_ipv4_neigh_default_gc_thresh1 = optional(number, null)<br>    net_ipv4_neigh_default_gc_thresh2 = optional(number, null)<br>    net_ipv4_neigh_default_gc_thresh3 = optional(number, null)<br>    net_ipv4_tcp_fin_timeout          = optional(number, null)<br>    net_ipv4_tcp_keepalive_intvl      = optional(number, null)<br>    net_ipv4_tcp_keepalive_probes     = optional(number, null)<br>    net_ipv4_tcp_keepalive_time       = optional(number, null)<br>    net_ipv4_tcp_max_syn_backlog      = optional(number, null)<br>    net_ipv4_tcp_max_tw_buckets       = optional(number, null)<br>    vm_max_map_count                  = optional(number, null)<br>    vm_swappiness                     = optional(number, null)<br>    vm_vfs_cache_pressure             = optional(number, null)<br>  })</pre> | `{}` | no |
| <a name="input_system_node_pool_name"></a> [system\_node\_pool\_name](#input\_system\_node\_pool\_name) | (Required) A default\_node\_pool | `string` | `"syspool"` | no |
| <a name="input_temporary_name_for_rotation"></a> [temporary\_name\_for\_rotation](#input\_temporary\_name\_for\_rotation) | (Optional) A temporary name to use when rotating the Node Pool. This value must be specified when attempting a rotation. | `string` | `"temporary-name"` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Name of the virtual network where AKS will be deployed | `string` | `""` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | (Required) The size of the Virtual Machine, such as Standard\_DS2\_v2. temporary\_name\_for\_rotation must be specified when attempting a resize | `string` | `"Standard_D2ads_v5"` | no |
| <a name="input_workload_assigned_identities"></a> [workload\_assigned\_identities](#input\_workload\_assigned\_identities) | The identities to create to use with the workload identity | <pre>list(object({<br>    workload_assigned_identity_name   = string<br>    workload_assigned_identity_exists = optional(bool, false) # If the identity already exists, set this to true<br>  }))</pre> | `[]` | no |
| <a name="input_workload_identity_enabled"></a> [workload\_identity\_enabled](#input\_workload\_identity\_enabled) | (Optional) Enable or Disable the Workload Identity | `bool` | `false` | no |
| <a name="input_zone_redundancy_enabled"></a> [zone\_redundancy\_enabled](#input\_zone\_redundancy\_enabled) | Indicates whether zone redundancy should be enabled for the Grafana instance. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks_id"></a> [aks\_id](#output\_aks\_id) | The ID of the Azure Kubernetes Service (AKS) cluster. |
| <a name="output_azurerm_kubernetes_cluster_fqdn"></a> [azurerm\_kubernetes\_cluster\_fqdn](#output\_azurerm\_kubernetes\_cluster\_fqdn) | The fully qualified domain name (FQDN) of the AKS cluster. |
| <a name="output_azurerm_kubernetes_cluster_node_resource_group"></a> [azurerm\_kubernetes\_cluster\_node\_resource\_group](#output\_azurerm\_kubernetes\_cluster\_node\_resource\_group) | The name of the Azure Resource Group where the AKS cluster's nodes are deployed. |
| <a name="output_azurerm_kubernetes_cluster_oidc_issuer_url"></a> [azurerm\_kubernetes\_cluster\_oidc\_issuer\_url](#output\_azurerm\_kubernetes\_cluster\_oidc\_issuer\_url) | The URL of the OpenID Connect (OIDC) issuer for the AKS cluster. |
<!-- END_TF_DOCS -->
