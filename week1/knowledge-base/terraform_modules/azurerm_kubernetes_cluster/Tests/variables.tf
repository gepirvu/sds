
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

