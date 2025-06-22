| **Build Status**      | **Latest Version** | **Date** |
|:----------------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_data_protection_backup?repoName=azurerm_data_protection_backup&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=4204&repoName=azurerm_data_protection_backup&branchName=main) | **v2.0.0**         | 27/03/2025 |

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Azure Backup vault Configuration](#azure-backup-vault-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Azure Backup vault Configuration

----------------------------

[Learn more about Azure Backup vault in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/backup/backup-vault-overview/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------
A Backup vault is a storage entity in Azure that houses backup data for certain newer workloads that Azure Backup supports. You can use Backup vaults to hold backup data for various Azure services, such as Azure Blob, Azure Database for PostgreSQL servers and newer workloads that Azure Backup will support. Backup vaults make it easy to organize your backup data, while minimizing management overhead.

This module allow you to create backup for:

- Azure Disk(VMs)
- Storage acocunts blob containers
- AKS clusters
- PostgreSQL flexible server

## Deployed Resources

----------------------------
This module will deploy the following azurerm resources:

- azurerm_data_protection_backup_vault
- azurerm_data_protection_backup_policy_kubernetes_cluster
- azurerm_data_protection_backup_instance_kubernetes_cluster
- azurerm_data_protection_backup_policy_blob_storage
- azurerm_data_protection_backup_instance_blob_storage
- azurerm_data_protection_backup_policy_disk
- azurerm_data_protection_backup_instance_disk
- azurerm_data_protection_backup_policy_postgresql_flexible_server
- azurerm_data_protection_backup_instance_postgresql_flexible_server

## Pre-requisites

----------------------------
>**Note:**  
> Your resources must exist before you can create backups for them


It is assumed that the following resources already exists:

- Resource Group
- Snapshoot Resource Group(in case you dont want to reuse your Resource Group)
- Storage Account with access keys enabled for the AKS backup

## Axso Naming convention example

----------------------------

The naming convention is derived from the following variables `subscription`, `project_name` and `environment`:

- **Construct:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-dpb"`
- **NonProd:** `axso-np-appl-etools-dev-dpb`
- **Prod:** `axso-p-appl-etools-prod-dpb`

# Terraform Files

----------------------------

## module.tf

```hcl


module "data_protection_backup_vault" {
  source                                    = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_data_protection_backup?ref=v2.0.0" 
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
  snapshot_resource_group_id                = var.snapshot_resource_group_id
  blob_storage_backup_config                = var.blob_storage_backup_config
  blob_storage_backup_policy                = var.blob_storage_backup_policy
  managed_disk_backup_config                = var.managed_disk_backup_config
  managed_disk_backup_policy                = var.managed_disk_backup_policy
  kubernetes_cluster_backup_policy          = var.kubernetes_cluster_backup_policy
  kubernetes_cluster_backup_config          = var.kubernetes_cluster_backup_config
  kubernetes_cluster_storage_account_config = var.kubernetes_cluster_storage_account_config
  psql_flexible_server_backup_policy        = var.psql_flexible_server_backup_policy
  psql_flexible_server_backup_config        = var.psql_flexible_server_backup_config
}



```

## module.tf.tfvars

```hcl
subscription        = "np"
project_name        = "infra"
environment         = "test"
location            = "westeurope"
resource_group_name = "axso-np-appl-ssp-test-rg"

datastore_type               = "VaultStore"
redundancy                   = "GeoRedundant" # LocallyRedundant, GeoRedundant, ZoneRedundant
cross_region_restore_enabled = true
retention_duration_in_days   = 14
soft_delete                  = "Off" # ["AlwaysOn" "Off" "On"]

snapshot_resource_group_id = "/subscriptions/77116f35-6e77-4f5f-b82f-49e50812cc75/resourceGroups/axso-np-appl-ssp-test-rg"

#Blob Storage
blob_storage_backup_config = [{
  blob_storage_backup_policy_name = "blob-storage-backup"
  storage_account_name            = "axso4p4ssp4np4testsa"
  resource_group_name             = "axso-np-appl-ssp-test-rg"
  storage_account_container_names = ["aks-backup"]
}]

blob_storage_backup_policy = [{
  blob_storage_backup_policy_name        = "blob-storage-backup"
  operational_default_retention_duration = "P30D"
  vault_default_retention_duration       = "P30D"
  backup_repeating_time_intervals        = ["R/2024-06-10T00:00:00+00:00/P1D"] # Backup will be taken every day at 00:00:00 UTC
  time_zone                              = "Romance Standard Time"
  retention_rule = [
    {
      name     = "retent-FirstOfMonth"
      duration = "P60D"
      priority = 1
      criteria = {
        absolute_criteria = "FirstOfMonth" # Possible values are AllBackup, FirstOfDay, FirstOfWeek, FirstOfMonth and FirstOfYear
        # If you chose absoulte criteria you cant select days_of_month, days_of_week and months_of_year. 
      }
      lifecycle = {
        data_store_type = "VaultStore"
        duration        = "P15D"
      }
    },
    {
      name     = "retent-Monday"
      duration = "P60D"
      priority = 10
      criteria = {
        # days_of_month     = [1, 15]
        # days_of_week = ["Monday", "Tuesday"]
        # months_of_year = ["January", "February"]
        days_of_week = ["Monday"]
      }
      lifecycle = {
        data_store_type = "VaultStore"
        duration        = "P15D"
      }
    }
  ]
}]

#Disk

managed_disk_backup_config = [{
  managed_disk_backup_policy_name = "managed-disk-backup"
  disk_name                       = "axso-np-appl-cloudinfra-tst-disk"
  resource_group_name             = "axso-np-appl-ssp-test-rg"
}]

managed_disk_backup_policy = [{
  managed_disk_backup_policy_name = "managed-disk-backup"
  backup_repeating_time_intervals = ["R/2024-06-10T00:00:00+00:00/P1D"] # Backup will be taken every day at 00:00:00 UTC
  default_retention_duration      = "P30D"
  time_zone                       = "Romance Standard Time"
  retention_rule = [{
    name     = "retention-FirstOfDay"
    duration = "P7D"
    priority = 1
    criteria = {
      absolute_criteria = "FirstOfDay"

    }

  }]
}]

#AKS

kubernetes_cluster_backup_policy = [
  {
    kubernetes_cluster_backup_policy_name = "k8s-cluster-backup"
    resource_group_name                   = "my-resource-group"
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
  // {
  //   kubernetes_cluster_backup_policy_name = "k8s-cluster-backup"
  //   resource_group_name                   = "axso-np-appl-ssp-test-rg"
  //   kubernetes_cluster_name               = "axso-np-appl-ssp-test-aks"
  //   kubernetes_cluster_id                 = "/subscriptions/77116f35-6e77-4f5f-b82f-49e50812cc75/resourceGroups/axso-np-appl-ssp-test-rg/providers/Microsoft.ContainerService/managedClusters/axso-np-appl-ssp-test-aks"
  //   backup_datasource_parameters = {
  //     excluded_namespaces              = []
  //     included_namespaces              = [] # Empty list means all namespaces
  //     excluded_resource_types          = []
  //     cluster_scoped_resources_enabled = true
  //     included_resource_types          = []
  //     label_selectors                  = []
  //     volume_snapshot_enabled          = true
  //   }
  // }
]

kubernetes_cluster_storage_account_config = {
  kubernetes_cluster_backup_storage_account_name                = "axso4p4ssp4np4testsa"
  kubernetes_cluster_backup_storage_account_resource_group_name = "axso-np-appl-ssp-test-rg"
  kubernetes_cluster_backup_storage_account_blob_name           = "aks-backup-test"
  create_cluster_backup_storage_account_blob                    = true

}

#PSQL Flexible Server
psql_flexible_server_backup_config = [
  # {
  #   psql_flexible_server_backup_policy_name = "mypolicy"
  #   psql_flexible_server_name               = "axso-np-appl-cloudinfra-dev-pgsql-flexi-server"
  #   resource_group_name                     = "axso-np-appl-ssp-test-rg"
  # }
]

psql_flexible_server_backup_policy = [
  {
    psql_flexible_server_backup_policy_name = "mypolicy"
    backup_repeating_time_intervals         = ["R/2024-06-10T00:00:00+00:00/P1D"]

    time_zone = "Romance Standard Time"
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

```

## variables.tf

```hcl
# Purpose: Define the variables that will be used in the terraform configuration
variable "project_name" {
  type        = string
  description = "The name of the project. e.g. MDS"
  default     = "project"
}

variable "subscription" {
  type        = string
  description = "The subscription type e.g. 'p' for prod or 'np' for nonprod"
  default     = "np"
}

variable "environment" {
  type        = string
  description = "The environment. e.g. dev, qa, uat, prod"
  default     = "dev"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the data factory"
}

variable "location" {
  description = "Azure location."
  type        = string
  default     = "West Europe"
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

variable "snapshot_resource_group_id" {
  type        = string
  description = "The id of the resource group where the snapshot resides."

}

variable "blob_storage_backup_policy" {
  type = list(object({
    blob_storage_backup_policy_name        = string
    backup_repeating_time_intervals        = optional(list(string))
    operational_default_retention_duration = string
    vault_default_retention_duration       = optional(string)
    time_zone                              = optional(string)
    retention_rule = optional(list(object({
      name     = string
      duration = string
      priority = number
      criteria = optional(object({
        absolute_criteria      = optional(string)
        days_of_month          = optional(list(number))
        days_of_week           = optional(list(string))
        months_of_year         = optional(list(string))
        scheduled_backup_times = optional(list(string))
        weeks_of_month         = optional(list(string))
      }))
      lifecycle = object({
        data_store_type = string
        duration        = string
      })
    })))
  }))
  default     = []
  description = <<EOF
Specifies the backup policy for blob storage. This variable allows you to define a list of backup policies with detailed attributes. Changing any of these attributes forces the creation of a new Backup Policy for the blob storage.

Attributes:
- **blob_storage_backup_policy_name** (Required): The name of the backup policy. Changing this forces a new Backup Policy to be created.
- **backup_repeating_time_intervals** (Optional): A list of repeating time intervals for backups. These intervals must adhere to the ISO 8601 repeating interval format. Changing this forces a new Backup Policy to be created.
- **operational_default_retention_duration** (Required): The duration of the operational default retention rule. This must follow the ISO 8601 duration format. Changing this forces a new Backup Policy to be created.
- **vault_default_retention_duration** (Optional): The vault's default retention duration. Changing this forces a new Backup Policy to be created.
- **time_zone** (Optional): Specifies the time zone to be used by the backup schedule. Changing this forces a new Backup Policy to be created.
- **retention_rule** (Optional): Defines the retention rules for the backup policy, including:
  - **name** (Required): The name of the retention rule.
  - **duration** (Required): The duration of the retention rule, following the ISO 8601 duration format.
  - **priority** (Required): The priority of the retention rule.
  - **criteria** (Optional): Additional criteria for the retention rule, including:
    - **absolute_criteria** (Optional): An optional absolute criteria string.
    - **days_of_month** (Optional): A list of days of the month for the backup schedule.
    - **days_of_week** (Optional): A list of days of the week for the backup schedule.
    - **months_of_year** (Optional): A list of months of the year for the backup schedule.
    - **scheduled_backup_times** (Optional): A list of specific backup times in HH:mm:ss format.
    - **weeks_of_month** (Optional): A list of weeks of the month for the backup schedule.
  - **lifecycle** (Required): Specifies lifecycle management settings for the retention rule, including:
    - **data_store_type** (Required): The type of data store for lifecycle management.
    - **duration** (Required): The duration for lifecycle management, following the ISO 8601 duration format.

Note: Changing any of these attributes forces a new Backup Policy to be created for the specified blob storage.
EOF
}



variable "blob_storage_backup_config" {
  type = list(object({
    storage_account_name            = string
    resource_group_name             = string
    blob_storage_backup_policy_name = string
    storage_account_container_names = list(string)
  }))
  default = []

  description = <<EOF
Specifies the configuration for blob storage backups. This variable defines a list of backup configurations, associating blob storage resources with their respective backup policies.

Attributes:
- **storage_account_name** (Required): The name of the blob storage account. This must be unique within the context of your Terraform configuration.
- **resource_group_name** (Required): The name of the Azure Resource Group where the blob storage resides.
- **blob_storage_backup_policy_name** (Required): The name of the backup policy to be applied to the blob storage. This should correspond to an existing backup policy defined within your Azure environment.

Default: An empty list, meaning no backup configurations are defined unless explicitly specified.

Note: Changing the attributes in this variable will force updates to the associated backup configurations.
EOF
}


#Disk

variable "managed_disk_backup_policy" {
  type = list(object({
    managed_disk_backup_policy_name = string
    backup_repeating_time_intervals = optional(list(string))
    default_retention_duration      = string
    time_zone                       = optional(string)
    retention_rule = optional(list(object({
      name     = string
      duration = string
      priority = number
      criteria = optional(object({
        absolute_criteria = optional(string)
      }))
    })))
  }))
  default     = []
  description = <<EOF
Specifies the backup policy for managed disks. This variable allows you to define a list of backup policies with detailed attributes. Changing the attributes of a backup policy forces the creation of a new Backup Policy for the managed disks.

Attributes:
- **managed_disk_backup_policy_name** (Required): The name of the backup policy. Changing this forces a new Backup Policy to be created.
- **backup_repeating_time_intervals** (Optional): A list of repeating time intervals for backups. These intervals must adhere to the ISO 8601 repeating interval format. Changing this forces a new Backup Policy to be created.
- **default_retention_duration** (Required): The default retention duration for the backup policy. This must follow the ISO 8601 duration format. Changing this forces a new Backup Policy to be created.
- **time_zone** (Optional): Specifies the time zone to be used by the backup schedule. Changing this forces a new Backup Policy to be created.
- **retention_rule** (Optional): Defines the retention rules for the backup policy. This includes:
  - **name** (Required): The name of the retention rule.
  - **duration** (Required): The duration of the retention rule, following the ISO 8601 duration format.
  - **priority** (Required): The priority of the retention rule.
  - **criteria** (Optional): Specifies additional criteria for the retention rule, including:
    - **absolute_criteria** (Optional): An optional absolute criteria string.

Note: Changing any of these attributes forces a new Backup Policy to be created for the specified managed disks.
EOF
}



variable "managed_disk_backup_config" {
  type = list(object({
    disk_name                       = string
    resource_group_name             = string
    managed_disk_backup_policy_name = string
  }))
  default = []

  description = <<EOF
Specifies the configuration for managed disk backups. This variable defines a list of backup configurations, associating managed disk resources with their respective backup policies.

Attributes:
- **disk_name** (Required): The name of the managed disk. This must be unique within the context of your Terraform configuration.
- **resource_group_name** (Required): The name of the Azure Resource Group where the managed disk resides.
- **managed_disk_backup_policy_name** (Required): The name of the backup policy to be applied to the managed disk. This should correspond to an existing backup policy defined within your Azure environment.

Default: An empty list, meaning no backup configurations are defined unless explicitly specified.

Note: Changing the attributes in this variable will force updates to the associated backup configurations.
EOF
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
  default     = []
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
    resource_group_name                     = string
    kubernetes_cluster_backup_policy_name   = string
    kubernetes_cluster_name                 = string
    kubernetes_cluster_id                   = string
    kubernetes_cluster_identity_data_object = optional(bool, true)
    kubernetes_cluster_identity_object_id   = optional(string)
    kubernetes_cluster_resource_group_name  = optional(string)
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
  default     = []
  description = <<EOF
Defines the backup configuration for Kubernetes clusters, specifying backup policies and parameters.

### Attributes:
- **resource_group_name** (Required): The name of the Azure Resource Group where the Kubernetes cluster is deployed.
- **kubernetes_cluster_name** (Required): The name of the Kubernetes cluster. It must be unique within your Terraform configuration.
- **kubernetes_cluster_backup_policy_name** (Required): The name of the backup policy applied to the Kubernetes cluster. This must reference an existing backup policy in Azure.

### Backup Data Source Parameters:
- **excluded_namespaces** (Required): A list of namespaces to exclude from the backup.
- **excluded_resource_types** (Required): A list of Kubernetes resource types to exclude from the backup.
- **cluster_scoped_resources_enabled** (Required): Boolean flag indicating whether cluster-scoped resources should be included in the backup.
- **included_namespaces** (Optional): A list of namespaces to include in the backup. If not specified, all namespaces except those explicitly excluded are included.
- **included_resource_types** (Required): A list of Kubernetes resource types to include in the backup.
- **label_selectors** (Required): A list of label selectors to filter resources for backup.
- **volume_snapshot_enabled** (Required): Boolean flag indicating whether volume snapshots should be included in the backup.

### Default:
The default value is an empty list (`[]`), meaning no backup configurations are defined unless explicitly provided.

### Note:
Modifying any attribute in this variable will trigger updates to the associated backup configurations.
EOF
}



variable "kubernetes_cluster_storage_account_config" {
  type = object({
    kubernetes_cluster_backup_storage_account_name                = optional(string)
    kubernetes_cluster_backup_storage_account_resource_group_name = optional(string)
    kubernetes_cluster_backup_storage_account_blob_name           = optional(string)
    create_cluster_backup_storage_account_blob                    = optional(bool)
  })
  default = {}

  description = <<EOF
Specifies the configuration for Kubernetes cluster storage accounts used for backups. This variable defines the necessary attributes to associate Kubernetes cluster resources with their respective Azure storage accounts for backup purposes.

Attributes:
- **kubernetes_cluster_backup_storage_account_name** (Required): The name of the Azure Storage Account used for Kubernetes cluster backups.
- **kubernetes_cluster_backup_storage_account_resource_group_name** (Required): The name of the Azure Resource Group where the storage account is located.
- **kubernetes_cluster_backup_storage_account_blob_name** (Required): The name of the blob container within the storage account where the backups will be stored.
- **create_cluster_backup_storage_account_blob** (Required): Indicate whether the Blob Storage needs to be created. If not, it is assumed that it already exists.

Default: An empty object, indicating no storage account configurations are defined unless explicitly specified.

Note: Modifying these attributes will trigger updates to the associated Kubernetes cluster backup configurations in Terraform.
EOF
}


variable "psql_flexible_server_backup_config" {
  type = list(object({
    resource_group_name                     = string
    psql_flexible_server_name               = string
    psql_flexible_server_backup_policy_name = string
  }))
  default = []

  description = <<EOF
Specifies the configuration for PSQL Flexible Server backups. This variable defines a list of backup configurations, associating PSQL Flexible Server resources with their respective backup policies.

Attributes:
- **resource_group_name** (Required): The name of the Azure Resource Group where the PSQL Flexible Server resides.
- **psql_flexible_server_name** (Required): The name of the PSQL Flexible Server to be backed up.
- **psql_flexible_server_backup_policy_name** (Required): The name of the backup policy to be applied to the PSQL Flexible Server. This should correspond to an existing backup policy defined within your Azure environment.

Default: An empty list, meaning no backup configurations are defined unless explicitly specified.

Note: Changing the attributes in this variable will force updates to the associated backup configurations.
EOF
}

variable "psql_flexible_server_backup_policy" {
  type = list(object({
    psql_flexible_server_backup_policy_name = string
    backup_repeating_time_intervals         = optional(list(string))
    time_zone                               = optional(string)
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
  default     = []
  description = <<EOF
Specifies the backup policy for PSQL Flexible Servers. This variable allows you to define a list of backup policies with detailed attributes. Changing any of these attributes forces the creation of a new Backup Policy for the PSQL Flexible Server.

Attributes:
- **psql_flexible_server_backup_policy_name** (Required): The name of the backup policy. Changing this forces a new Backup Policy to be created.
- **backup_repeating_time_intervals** (Optional): A list of repeating time intervals for backups. These intervals must adhere to the ISO 8601 repeating interval format. Changing this forces a new Backup Policy to be created.
- **time_zone** (Optional): Specifies the time zone to be used by the backup schedule. Changing this forces a new Backup Policy to be created.
- **default_retention_rule** (Optional): Specifies the default lifecycle retention rule for the backup policy, including:
  - **lifecycle** (Required): Specifies lifecycle management settings, including:
    - **duration** (Required): The duration for lifecycle management, following the ISO 8601 duration format.
- **retention_rule** (Optional): Defines additional retention rules for the backup policy, including:
  - **name** (Required): The name of the retention rule.
  - **priority** (Required): The priority of the retention rule.
  - **criteria** (Optional): Specifies additional criteria for the retention rule, including:
    - **absolute_criteria** (Optional): Specifies an optional absolute criteria string.
    - **days_of_week** (Optional): A list of days of the week for the backup schedule.
    - **months_of_year** (Optional): A list of months of the year for the backup schedule.
    - **scheduled_backup_times** (Optional): A list of specific backup times in RFC3339 format.
    - **weeks_of_month** (Optional): A list of weeks of the month for the backup schedule.
  - **lifecycle** (Required): Specifies lifecycle management settings for the retention rule, including:
    - **duration** (Required): The duration for lifecycle management, following the ISO 8601 duration format.

Note: Changing any of these attributes forces a new Backup Policy to be created for the specified PSQL Flexible Server.
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
      version = "4.22.0"
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

```

----------------------------

# Input Description

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |  

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | n/a |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |  

## Modules

No modules.  

## Resources

| Name | Type |
|------|------|
| [azurerm_data_protection_backup_instance_blob_storage.data_protection_backup_instance_blob_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_instance_blob_storage) | resource |
| [azurerm_data_protection_backup_instance_disk.data_protection_backup_instance_disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_instance_disk) | resource |
| [azurerm_data_protection_backup_instance_kubernetes_cluster.data_protection_backup_instance_kubernetes_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_instance_kubernetes_cluster) | resource |
| [azurerm_data_protection_backup_instance_mysql_flexible_server.data_protection_backup_instance_mysql_flexible_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_instance_mysql_flexible_server) | resource |
| [azurerm_data_protection_backup_instance_postgresql_flexible_server.data_protection_backup_instance_postgresql_flexible_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_instance_postgresql_flexible_server) | resource |
| [azurerm_data_protection_backup_policy_blob_storage.data_protection_backup_policy_blob_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_policy_blob_storage) | resource |
| [azurerm_data_protection_backup_policy_disk.data_protection_backup_policy_disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_policy_disk) | resource |
| [azurerm_data_protection_backup_policy_kubernetes_cluster.data_protection_backup_policy_kubernetes_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_policy_kubernetes_cluster) | resource |
| [azurerm_data_protection_backup_policy_mysql_flexible_server.data_protection_backup_policy_mysql_flexible_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_policy_mysql_flexible_server) | resource |
| [azurerm_data_protection_backup_policy_postgresql_flexible_server.data_protection_backup_policy_postgresql_flexible_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_policy_postgresql_flexible_server) | resource |
| [azurerm_data_protection_backup_vault.data_protection_backup_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_vault) | resource |
| [azurerm_kubernetes_cluster_extension.kubernetes_cluster_extension](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_extension) | resource |
| [azurerm_kubernetes_cluster_trusted_access_role_binding.aks_cluster_trusted_access](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_trusted_access_role_binding) | resource |
| [azurerm_role_assignment.aks_reader_on_snap_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.role_assignment_disk_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.role_assignment_disk_snapshot_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.role_assignment_sa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.vault_account_contributor_on_mysql_flexible_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.vault_account_contributor_on_psql_flexible_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.vault_account_contributor_on_sa_aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.vault_data_contributor_on_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.vault_data_operator_on_snap_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.vault_reader_on_aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.vault_reader_on_snap_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_container.storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [time_sleep.wait_30_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_30_seconds_container](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_30_seconds_mysql_flexible_server](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_30_seconds_psql_flexible_server](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [azuread_service_principal.aks_application](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azurerm_managed_disk.managed_disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/managed_disk) | data source |
| [azurerm_mysql_flexible_server.mysql_flexible_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/mysql_flexible_server) | data source |
| [azurerm_postgresql_flexible_server.postgresql_flexible_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/postgresql_flexible_server) | data source |
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_storage_account.storage_account_aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_blob_storage_backup_config"></a> [blob\_storage\_backup\_config](#input\_blob\_storage\_backup\_config) | Specifies the configuration for blob storage backups. This variable defines a list of backup configurations, associating blob storage resources with their respective backup policies.<br><br>Attributes:<br>- **storage\_account\_name** (Required): The name of the blob storage account. This must be unique within the context of your Terraform configuration.<br>- **resource\_group\_name** (Required): The name of the Azure Resource Group where the blob storage resides.<br>- **blob\_storage\_backup\_policy\_name** (Required): The name of the backup policy to be applied to the blob storage. This should correspond to an existing backup policy defined within your Azure environment.<br><br>Default: An empty list, meaning no backup configurations are defined unless explicitly specified.<br><br>Note: Changing the attributes in this variable will force updates to the associated backup configurations. | <pre>list(object({<br>    storage_account_name            = string<br>    resource_group_name             = string<br>    blob_storage_backup_policy_name = string<br>    storage_account_container_names = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_blob_storage_backup_policy"></a> [blob\_storage\_backup\_policy](#input\_blob\_storage\_backup\_policy) | Specifies the backup policy for blob storage. This variable allows you to define a list of backup policies with detailed attributes. Changing any of these attributes forces the creation of a new Backup Policy for the blob storage.<br><br>Attributes:<br>- **blob\_storage\_backup\_policy\_name** (Required): The name of the backup policy. Changing this forces a new Backup Policy to be created.<br>- **backup\_repeating\_time\_intervals** (Optional): A list of repeating time intervals for backups. These intervals must adhere to the ISO 8601 repeating interval format. Changing this forces a new Backup Policy to be created.<br>- **operational\_default\_retention\_duration** (Required): The duration of the operational default retention rule. This must follow the ISO 8601 duration format. Changing this forces a new Backup Policy to be created.<br>- **vault\_default\_retention\_duration** (Optional): The vault's default retention duration. Changing this forces a new Backup Policy to be created.<br>- **time\_zone** (Optional): Specifies the time zone to be used by the backup schedule. Changing this forces a new Backup Policy to be created.<br>- **retention\_rule** (Optional): Defines the retention rules for the backup policy, including:<br>  - **name** (Required): The name of the retention rule.<br>  - **duration** (Required): The duration of the retention rule, following the ISO 8601 duration format.<br>  - **priority** (Required): The priority of the retention rule.<br>  - **criteria** (Optional): Additional criteria for the retention rule, including:<br>    - **absolute\_criteria** (Optional): An optional absolute criteria string.<br>    - **days\_of\_month** (Optional): A list of days of the month for the backup schedule.<br>    - **days\_of\_week** (Optional): A list of days of the week for the backup schedule.<br>    - **months\_of\_year** (Optional): A list of months of the year for the backup schedule.<br>    - **scheduled\_backup\_times** (Optional): A list of specific backup times in HH:mm:ss format.<br>    - **weeks\_of\_month** (Optional): A list of weeks of the month for the backup schedule.<br>  - **lifecycle** (Required): Specifies lifecycle management settings for the retention rule, including:<br>    - **data\_store\_type** (Required): The type of data store for lifecycle management.<br>    - **duration** (Required): The duration for lifecycle management, following the ISO 8601 duration format.<br><br>Note: Changing any of these attributes forces a new Backup Policy to be created for the specified blob storage. | <pre>list(object({<br>    blob_storage_backup_policy_name        = string<br>    backup_repeating_time_intervals        = optional(list(string))<br>    operational_default_retention_duration = string<br>    vault_default_retention_duration       = optional(string)<br>    time_zone                              = optional(string)<br>    retention_rule = optional(list(object({<br>      name     = string<br>      duration = string<br>      priority = number<br>      criteria = optional(object({<br>        absolute_criteria      = optional(string)<br>        days_of_month          = optional(list(number))<br>        days_of_week           = optional(list(string))<br>        months_of_year         = optional(list(string))<br>        scheduled_backup_times = optional(list(string))<br>        weeks_of_month         = optional(list(string))<br>      }))<br>      lifecycle = object({<br>        data_store_type = string<br>        duration        = string<br>      })<br>    })))<br>  }))</pre> | `[]` | no |
| <a name="input_cross_region_restore_enabled"></a> [cross\_region\_restore\_enabled](#input\_cross\_region\_restore\_enabled) | (Optional) Specifies whether cross-region restore is enabled. Changing this forces a new Backup Vault to be created. | `bool` | `false` | no |
| <a name="input_datastore_type"></a> [datastore\_type](#input\_datastore\_type) | (Required) Specifies the type of the data store. Possible values are ArchiveStore, OperationalStore, and VaultStore. Changing this forces a new resource to be created<br>  *VaultStore*: It stores backups in the Azure Blob service,It's designed to provide high availability for backup data. Vault Store provides good performance for backup and recovery operations.<br>  *SnapshotStore*: It is used for frequent backups and is crucial when the ability to quickly capture and recover from point-in-time changes is important.<br>  *ArchiveStore*: It is used for a long time, especially for data that is rarely accessed and has extended retention periods, ArchiveStore is a cost-effective option. | `string` | `"VaultStore"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"dev"` | no |
| <a name="input_kubernetes_cluster_backup_config"></a> [kubernetes\_cluster\_backup\_config](#input\_kubernetes\_cluster\_backup\_config) | Defines the backup configuration for Kubernetes clusters, specifying backup policies, cluster details, and backup parameters.<br><br>### Attributes:<br>- **resource\_group\_name** (Required): The name of the Azure Resource Group where the Kubernetes cluster is deployed.<br>- **kubernetes\_cluster\_name** (Required): The name of the Kubernetes cluster. It must be unique within your Terraform configuration.<br>- **kubernetes\_cluster\_backup\_policy\_name** (Required): The name of the backup policy applied to the Kubernetes cluster. This must reference an existing backup policy in Azure.<br>- **kubernetes\_cluster\_id** (Required): The full resource ID of the Kubernetes cluster.<br>- **kubernetes\_cluster\_identity\_data\_object** (Optional, default = `true`): Indicates whether the identity object should be automatically derived using a data source. Set to `false` to skip lookup and use a provided identity ID directly.<br>- **kubernetes\_cluster\_identity\_object\_id** (Optional): The object ID of the managed identity assigned to the Kubernetes cluster. Required if `kubernetes_cluster_identity_data_object` is `false`.<br>- **kubernetes\_cluster\_resource\_group\_name** (Optional): The resource group name where the Kubernetes cluster resides. Required if using a data source to fetch cluster identity and the cluster is not in the default resource group.<br><br>### Backup Data Source Parameters:<br>- **excluded\_namespaces** (Required): A list of namespaces to exclude from the backup.<br>- **excluded\_resource\_types** (Required): A list of Kubernetes resource types to exclude from the backup.<br>- **cluster\_scoped\_resources\_enabled** (Required): Boolean flag indicating whether cluster-scoped resources should be included in the backup.<br>- **included\_namespaces** (Optional): A list of namespaces to include in the backup. If not specified, all namespaces except those explicitly excluded are included.<br>- **included\_resource\_types** (Required): A list of Kubernetes resource types to include in the backup.<br>- **label\_selectors** (Required): A list of label selectors to filter resources for backup.<br>- **volume\_snapshot\_enabled** (Required): Boolean flag indicating whether volume snapshots should be included in the backup.<br><br>### Default:<br>The default value is an empty list (`[]`), meaning no backup configurations are defined unless explicitly provided.<br><br>### Note:<br>Modifying any attribute in this variable will trigger updates to the associated backup configurations. Use caution when overriding optional fields like identity information. | <pre>list(object({<br>    resource_group_name                     = string<br>    kubernetes_cluster_backup_policy_name   = string<br>    kubernetes_cluster_name                 = string<br>    kubernetes_cluster_id                   = string<br>    kubernetes_cluster_identity_data_object = optional(bool, true)<br>    kubernetes_cluster_identity_object_id   = optional(string)<br>    kubernetes_cluster_resource_group_name  = optional(string)<br>    backup_datasource_parameters = object({<br>      excluded_namespaces              = list(string)<br>      excluded_resource_types          = list(string)<br>      cluster_scoped_resources_enabled = bool<br>      included_namespaces              = optional(list(string))<br>      included_resource_types          = list(string)<br>      label_selectors                  = list(string)<br>      volume_snapshot_enabled          = bool<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_kubernetes_cluster_backup_policy"></a> [kubernetes\_cluster\_backup\_policy](#input\_kubernetes\_cluster\_backup\_policy) | Specifies the backup policy for Kubernetes clusters. This variable allows you to define a list of backup policies with detailed attributes. Changing any of these attributes forces the creation of a new Backup Policy for the Kubernetes cluster.<br><br>Attributes:<br>- **kubernetes\_cluster\_backup\_policy\_name** (Required): The name of the backup policy. Changing this forces a new Backup Policy to be created.<br>- **resource\_group\_name** (Required): The name of the Azure Resource Group where the Kubernetes cluster resides.<br>- **vault\_name** (Required): The name of the backup vault associated with the policy.<br>- **backup\_repeating\_time\_intervals** (Optional): A list of repeating time intervals for backups. These intervals must adhere to the ISO 8601 repeating interval format. Changing this forces a new Backup Policy to be created.<br>- **time\_zone** (Optional): Specifies the time zone to be used by the backup schedule. Changing this forces a new Backup Policy to be created.<br>- **retention\_rule** (Optional): Defines the retention rules for the backup policy, including:<br>  - **name** (Required): The name of the retention rule.<br>  - **priority** (Required): The priority of the retention rule.<br>  - **criteria** (Optional): Specifies additional criteria for the retention rule, including:<br>    - **absolute\_criteria** (Optional): Specifies an optional absolute criteria string.<br>    - **days\_of\_week** (Optional): A list of days of the week for the backup schedule.<br>    - **months\_of\_year** (Optional): A list of months of the year for the backup schedule.<br>    - **scheduled\_backup\_times** (Optional): A list of specific backup times in HH:mm:ss format.<br>    - **weeks\_of\_month** (Optional): A list of weeks of the month for the backup schedule.<br>  - **lifecycle** (Required): Specifies lifecycle management settings for the retention rule, including:<br>    - **duration** (Required): The duration for lifecycle management, following the ISO 8601 duration format.<br><br>Note: Changing any of these attributes forces a new Backup Policy to be created for the specified Kubernetes cluster. | <pre>list(object({<br>    kubernetes_cluster_backup_policy_name = string<br>    resource_group_name                   = string<br>    vault_name                            = string<br>    backup_repeating_time_intervals       = optional(list(string))<br>    time_zone                             = optional(string)<br>    default_retention_rule = optional(object({<br>      lifecycle = object({<br>        duration = string<br>      })<br>    }))<br>    retention_rule = optional(list(object({<br>      name     = string<br>      priority = number<br>      criteria = optional(object({<br>        absolute_criteria      = optional(string)<br>        days_of_week           = optional(list(string))<br>        months_of_year         = optional(list(string))<br>        scheduled_backup_times = optional(list(string))<br>        weeks_of_month         = optional(list(string))<br>      }))<br>      lifecycle = object({<br>        duration = string<br>      })<br>    })))<br>  }))</pre> | `[]` | no |
| <a name="input_kubernetes_cluster_storage_account_config"></a> [kubernetes\_cluster\_storage\_account\_config](#input\_kubernetes\_cluster\_storage\_account\_config) | Specifies the configuration for Kubernetes cluster storage accounts used for backups. This variable defines the necessary attributes to associate Kubernetes cluster resources with their respective Azure storage accounts for backup purposes.<br><br>Attributes:<br>- **kubernetes\_cluster\_backup\_storage\_account\_name** (Required): The name of the Azure Storage Account used for Kubernetes cluster backups.<br>- **kubernetes\_cluster\_backup\_storage\_account\_resource\_group\_name** (Required): The name of the Azure Resource Group where the storage account is located.<br>- **kubernetes\_cluster\_backup\_storage\_account\_blob\_name** (Required): The name of the blob container within the storage account where the backups will be stored.<br>- **create\_cluster\_backup\_storage\_account\_blob** (Required): Indicate whether the Blob Storage needs to be created. If not, it is assumed that it already exists.<br><br>Default: An empty object, indicating no storage account configurations are defined unless explicitly specified.<br><br>Note: Modifying these attributes will trigger updates to the associated Kubernetes cluster backup configurations in Terraform. | <pre>object({<br>    kubernetes_cluster_backup_storage_account_name                = optional(string)<br>    kubernetes_cluster_backup_storage_account_resource_group_name = optional(string)<br>    kubernetes_cluster_backup_storage_account_blob_name           = optional(string)<br>    create_cluster_backup_storage_account_blob                    = optional(bool)<br>  })</pre> | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure location. | `string` | `"West Europe"` | no |
| <a name="input_managed_disk_backup_config"></a> [managed\_disk\_backup\_config](#input\_managed\_disk\_backup\_config) | Specifies the configuration for managed disk backups. This variable defines a list of backup configurations, associating managed disk resources with their respective backup policies.<br><br>Attributes:<br>- **disk\_name** (Required): The name of the managed disk. This must be unique within the context of your Terraform configuration.<br>- **resource\_group\_name** (Required): The name of the Azure Resource Group where the managed disk resides.<br>- **managed\_disk\_backup\_policy\_name** (Required): The name of the backup policy to be applied to the managed disk. This should correspond to an existing backup policy defined within your Azure environment.<br><br>Default: An empty list, meaning no backup configurations are defined unless explicitly specified.<br><br>Note: Changing the attributes in this variable will force updates to the associated backup configurations. | <pre>list(object({<br>    disk_name                       = string<br>    resource_group_name             = string<br>    managed_disk_backup_policy_name = string<br>  }))</pre> | `[]` | no |
| <a name="input_managed_disk_backup_policy"></a> [managed\_disk\_backup\_policy](#input\_managed\_disk\_backup\_policy) | Specifies the backup policy for managed disks. This variable allows you to define a list of backup policies with detailed attributes. Changing the attributes of a backup policy forces the creation of a new Backup Policy for the managed disks.<br><br>Attributes:<br>- **managed\_disk\_backup\_policy\_name** (Required): The name of the backup policy. Changing this forces a new Backup Policy to be created.<br>- **backup\_repeating\_time\_intervals** (Optional): A list of repeating time intervals for backups. These intervals must adhere to the ISO 8601 repeating interval format. Changing this forces a new Backup Policy to be created.<br>- **default\_retention\_duration** (Required): The default retention duration for the backup policy. This must follow the ISO 8601 duration format. Changing this forces a new Backup Policy to be created.<br>- **time\_zone** (Optional): Specifies the time zone to be used by the backup schedule. Changing this forces a new Backup Policy to be created.<br>- **retention\_rule** (Optional): Defines the retention rules for the backup policy. This includes:<br>  - **name** (Required): The name of the retention rule.<br>  - **duration** (Required): The duration of the retention rule, following the ISO 8601 duration format.<br>  - **priority** (Required): The priority of the retention rule.<br>  - **criteria** (Optional): Specifies additional criteria for the retention rule, including:<br>    - **absolute\_criteria** (Optional): An optional absolute criteria string.<br><br>Note: Changing any of these attributes forces a new Backup Policy to be created for the specified managed disks. | <pre>list(object({<br>    managed_disk_backup_policy_name = string<br>    backup_repeating_time_intervals = optional(list(string))<br>    default_retention_duration      = string<br>    time_zone                       = optional(string)<br>    retention_rule = optional(list(object({<br>      name     = string<br>      duration = string<br>      priority = number<br>      criteria = optional(object({<br>        absolute_criteria = optional(string)<br>      }))<br>    })))<br>  }))</pre> | `[]` | no |
| <a name="input_mysql_flexible_server_backup_config"></a> [mysql\_flexible\_server\_backup\_config](#input\_mysql\_flexible\_server\_backup\_config) | Specifies the configuration for MySQL Flexible Server backups. This variable defines a list of backup configurations, associating MySQL Flexible Server resources with their respective backup policies.<br><br>Attributes:<br>- **resource\_group\_name** (Required): The name of the Azure Resource Group where the MySQL Flexible Server resides.<br>- **mysql\_flexible\_server\_name** (Required): The name of the MySQL Flexible Server to be backed up.<br>- **mysql\_flexible\_server\_backup\_policy** (Required): The name of the backup policy to be applied to the MySQL Flexible Server. This should correspond to an existing backup policy defined within your Azure environment.<br><br>Default: An empty list, meaning no backup configurations are defined unless explicitly specified.<br><br>Note: Changing the attributes in this variable will force updates to the associated backup configurations. | <pre>list(object({<br>    resource_group_name                 = string<br>    mysql_flexible_server_name          = string<br>    mysql_flexible_server_backup_policy = string<br>  }))</pre> | `[]` | no |
| <a name="input_mysql_flexible_server_backup_policy"></a> [mysql\_flexible\_server\_backup\_policy](#input\_mysql\_flexible\_server\_backup\_policy) | Specifies the backup policy for MySQL Flexible Servers. This variable allows you to define a list of backup policies with detailed attributes. Changing any of these attributes forces the creation of a new Backup Policy for the MySQL Flexible Server.<br><br>Attributes:<br>- **mysql\_flexible\_server\_backup\_policy** (Required): The name of the backup policy. Changing this forces a new Backup Policy to be created.<br>- **backup\_repeating\_time\_intervals** (Optional): A list of repeating time intervals for backups. These intervals must adhere to the ISO 8601 repeating interval format. Changing this forces a new Backup Policy to be created.<br>- **time\_zone** (Optional): Specifies the time zone to be used by the backup schedule. Changing this forces a new Backup Policy to be created.<br>- **default\_retention\_rule** (Optional): Specifies the default lifecycle retention rule for the backup policy, including:<br>  - **lifecycle** (Required): Specifies lifecycle management settings, including:<br>    - **duration** (Required): The duration for lifecycle management, following the ISO 8601 duration format.<br>- **retention\_rule** (Optional): Defines additional retention rules for the backup policy, including:<br>  - **name** (Required): The name of the retention rule.<br>  - **priority** (Required): The priority of the retention rule.<br>  - **criteria** (Optional): Specifies additional criteria for the retention rule, including:<br>    - **absolute\_criteria** (Optional): Specifies an optional absolute criteria string.<br>    - **days\_of\_week** (Optional): A list of days of the week for the backup schedule.<br>    - **months\_of\_year** (Optional): A list of months of the year for the backup schedule.<br>    - **scheduled\_backup\_times** (Optional): A list of specific backup times in RFC3339 format.<br>    - **weeks\_of\_month** (Optional): A list of weeks of the month for the backup schedule.<br>  - **lifecycle** (Required): Specifies lifecycle management settings for the retention rule, including:<br>    - **duration** (Required): The duration for lifecycle management, following the ISO 8601 duration format.<br><br>Note: Changing any of these attributes forces a new Backup Policy to be created for the specified MySQL Flexible Server. | <pre>list(object({<br>    mysql_flexible_server_backup_policy = string<br>    backup_repeating_time_intervals     = optional(list(string))<br>    time_zone                           = optional(string)<br>    default_retention_rule = optional(object({<br>      lifecycle = object({<br>        duration = string<br>      })<br>    }))<br>    retention_rule = optional(list(object({<br>      name     = string<br>      priority = number<br>      criteria = optional(object({<br>        absolute_criteria      = optional(string)<br>        days_of_week           = optional(list(string))<br>        months_of_year         = optional(list(string))<br>        scheduled_backup_times = optional(list(string))<br>        weeks_of_month         = optional(list(string))<br>      }))<br>      lifecycle = object({<br>        duration = string<br>      })<br>    })))<br>  }))</pre> | `[]` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS | `string` | `"project"` | no |
| <a name="input_psql_flexible_server_backup_config"></a> [psql\_flexible\_server\_backup\_config](#input\_psql\_flexible\_server\_backup\_config) | Specifies the configuration for PSQL Flexible Server backups. This variable defines a list of backup configurations, associating PSQL Flexible Server resources with their respective backup policies.<br><br>Attributes:<br>- **resource\_group\_name** (Required): The name of the Azure Resource Group where the PSQL Flexible Server resides.<br>- **psql\_flexible\_server\_name** (Required): The name of the PSQL Flexible Server to be backed up.<br>- **psql\_flexible\_server\_backup\_policy\_name** (Required): The name of the backup policy to be applied to the PSQL Flexible Server. This should correspond to an existing backup policy defined within your Azure environment.<br><br>Default: An empty list, meaning no backup configurations are defined unless explicitly specified.<br><br>Note: Changing the attributes in this variable will force updates to the associated backup configurations. | <pre>list(object({<br>    resource_group_name                     = string<br>    psql_flexible_server_name               = string<br>    psql_flexible_server_backup_policy_name = string<br>  }))</pre> | `[]` | no |
| <a name="input_psql_flexible_server_backup_policy"></a> [psql\_flexible\_server\_backup\_policy](#input\_psql\_flexible\_server\_backup\_policy) | Specifies the backup policy for PSQL Flexible Servers. This variable allows you to define a list of backup policies with detailed attributes. Changing any of these attributes forces the creation of a new Backup Policy for the PSQL Flexible Server.<br><br>Attributes:<br>- **psql\_flexible\_server\_backup\_policy\_name** (Required): The name of the backup policy. Changing this forces a new Backup Policy to be created.<br>- **backup\_repeating\_time\_intervals** (Optional): A list of repeating time intervals for backups. These intervals must adhere to the ISO 8601 repeating interval format. Changing this forces a new Backup Policy to be created.<br>- **time\_zone** (Optional): Specifies the time zone to be used by the backup schedule. Changing this forces a new Backup Policy to be created.<br>- **default\_retention\_rule** (Optional): Specifies the default lifecycle retention rule for the backup policy, including:<br>  - **lifecycle** (Required): Specifies lifecycle management settings, including:<br>    - **duration** (Required): The duration for lifecycle management, following the ISO 8601 duration format.<br>- **retention\_rule** (Optional): Defines additional retention rules for the backup policy, including:<br>  - **name** (Required): The name of the retention rule.<br>  - **priority** (Required): The priority of the retention rule.<br>  - **criteria** (Optional): Specifies additional criteria for the retention rule, including:<br>    - **absolute\_criteria** (Optional): Specifies an optional absolute criteria string.<br>    - **days\_of\_week** (Optional): A list of days of the week for the backup schedule.<br>    - **months\_of\_year** (Optional): A list of months of the year for the backup schedule.<br>    - **scheduled\_backup\_times** (Optional): A list of specific backup times in RFC3339 format.<br>    - **weeks\_of\_month** (Optional): A list of weeks of the month for the backup schedule.<br>  - **lifecycle** (Required): Specifies lifecycle management settings for the retention rule, including:<br>    - **duration** (Required): The duration for lifecycle management, following the ISO 8601 duration format.<br><br>Note: Changing any of these attributes forces a new Backup Policy to be created for the specified PSQL Flexible Server. | <pre>list(object({<br>    psql_flexible_server_backup_policy_name = string<br>    backup_repeating_time_intervals         = optional(list(string))<br>    time_zone                               = optional(string)<br>    default_retention_rule = optional(object({<br>      lifecycle = object({<br>        duration = string<br>      })<br>    }))<br>    retention_rule = optional(list(object({<br>      name     = string<br>      priority = number<br>      criteria = optional(object({<br>        absolute_criteria      = optional(string)<br>        days_of_week           = optional(list(string))<br>        months_of_year         = optional(list(string))<br>        scheduled_backup_times = optional(list(string))<br>        weeks_of_month         = optional(list(string))<br>      }))<br>      lifecycle = object({<br>        duration = string<br>      })<br>    })))<br>  }))</pre> | `[]` | no |
| <a name="input_redundancy"></a> [redundancy](#input\_redundancy) | (Required) Specifies the backup storage redundancy. Possible values are GeoRedundant, LocallyRedundant and ZoneRedundant. Changing this forces a new Backup Vault to be created. | `string` | `"GeoRedundant"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group that contains the data factory | `string` | n/a | yes |
| <a name="input_retention_duration_in_days"></a> [retention\_duration\_in\_days](#input\_retention\_duration\_in\_days) | (Optional) Specifies the retention duration for the backup data in days. Changing this forces a new Backup Vault to be created. | `number` | `14` | no |
| <a name="input_snapshot_resource_group_id"></a> [snapshot\_resource\_group\_id](#input\_snapshot\_resource\_group\_id) | The id of the resource group where the snapshot resides. | `string` | n/a | yes |
| <a name="input_soft_delete"></a> [soft\_delete](#input\_soft\_delete) | (Optional) Specifies whether soft delete is enabled. Changing this forces a new Backup Vault to be created. | `string` | `"Off"` | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' for prod or 'np' for nonprod | `string` | `"np"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
