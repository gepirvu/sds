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