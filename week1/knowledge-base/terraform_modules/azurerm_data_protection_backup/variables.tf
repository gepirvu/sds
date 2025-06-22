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
Defines the backup configuration for Kubernetes clusters, specifying backup policies, cluster details, and backup parameters.

### Attributes:
- **resource_group_name** (Required): The name of the Azure Resource Group where the Kubernetes cluster is deployed.
- **kubernetes_cluster_name** (Required): The name of the Kubernetes cluster. It must be unique within your Terraform configuration.
- **kubernetes_cluster_backup_policy_name** (Required): The name of the backup policy applied to the Kubernetes cluster. This must reference an existing backup policy in Azure.
- **kubernetes_cluster_id** (Required): The full resource ID of the Kubernetes cluster.
- **kubernetes_cluster_identity_data_object** (Optional, default = `true`): Indicates whether the identity object should be automatically derived using a data source. Set to `false` to skip lookup and use a provided identity ID directly.
- **kubernetes_cluster_identity_object_id** (Optional): The object ID of the managed identity assigned to the Kubernetes cluster. Required if `kubernetes_cluster_identity_data_object` is `false`.
- **kubernetes_cluster_resource_group_name** (Optional): The resource group name where the Kubernetes cluster resides. Required if using a data source to fetch cluster identity and the cluster is not in the default resource group.

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
Modifying any attribute in this variable will trigger updates to the associated backup configurations. Use caution when overriding optional fields like identity information.
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



variable "mysql_flexible_server_backup_config" {
  type = list(object({
    resource_group_name                 = string
    mysql_flexible_server_name          = string
    mysql_flexible_server_backup_policy = string
  }))
  default = []

  description = <<EOF
Specifies the configuration for MySQL Flexible Server backups. This variable defines a list of backup configurations, associating MySQL Flexible Server resources with their respective backup policies.

Attributes:
- **resource_group_name** (Required): The name of the Azure Resource Group where the MySQL Flexible Server resides.
- **mysql_flexible_server_name** (Required): The name of the MySQL Flexible Server to be backed up.
- **mysql_flexible_server_backup_policy** (Required): The name of the backup policy to be applied to the MySQL Flexible Server. This should correspond to an existing backup policy defined within your Azure environment.

Default: An empty list, meaning no backup configurations are defined unless explicitly specified.

Note: Changing the attributes in this variable will force updates to the associated backup configurations.
EOF
}

variable "mysql_flexible_server_backup_policy" {
  type = list(object({
    mysql_flexible_server_backup_policy = string
    backup_repeating_time_intervals     = optional(list(string))
    time_zone                           = optional(string)
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
  default = []

  description = <<EOF
Specifies the backup policy for MySQL Flexible Servers. This variable allows you to define a list of backup policies with detailed attributes. Changing any of these attributes forces the creation of a new Backup Policy for the MySQL Flexible Server.

Attributes:
- **mysql_flexible_server_backup_policy** (Required): The name of the backup policy. Changing this forces a new Backup Policy to be created.
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

Note: Changing any of these attributes forces a new Backup Policy to be created for the specified MySQL Flexible Server.
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
