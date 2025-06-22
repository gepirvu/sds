#SA
data "azurerm_storage_account" "storage_account" {
  for_each            = { for idx, storage_account in var.blob_storage_backup_config : storage_account.storage_account_name => storage_account }
  name                = each.value.storage_account_name
  resource_group_name = each.value.resource_group_name
}

#DISK

data "azurerm_managed_disk" "managed_disk" {
  for_each            = { for idx, managed_disk in var.managed_disk_backup_config : managed_disk.disk_name => managed_disk }
  name                = each.value.disk_name
  resource_group_name = each.value.resource_group_name
}

#AKS


data "azuread_service_principal" "aks_application" {
  for_each     = { for idx, kubernetes_cluster in var.kubernetes_cluster_backup_config : kubernetes_cluster.kubernetes_cluster_name => kubernetes_cluster if kubernetes_cluster.kubernetes_cluster_identity_data_object == true }
  display_name = "${each.value.kubernetes_cluster_name}-identity"
}


#Storage Account 

data "azurerm_storage_account" "storage_account_aks" {
  count               = length(var.kubernetes_cluster_storage_account_config) > 0 ? 1 : 0
  name                = var.kubernetes_cluster_storage_account_config.kubernetes_cluster_backup_storage_account_name
  resource_group_name = var.kubernetes_cluster_storage_account_config.kubernetes_cluster_backup_storage_account_resource_group_name
}

#MYSQL
data "azurerm_mysql_flexible_server" "mysql_flexible_server" {
  for_each            = { for idx, mysql_flexible_server in var.mysql_flexible_server_backup_config : mysql_flexible_server.mysql_flexible_server_name => mysql_flexible_server }
  name                = each.value.mysql_flexible_server_name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_postgresql_flexible_server" "postgresql_flexible_server" {
  for_each            = { for idx, psql_flexible_server in var.psql_flexible_server_backup_config : psql_flexible_server.psql_flexible_server_name => psql_flexible_server }
  name                = each.value.psql_flexible_server_name
  resource_group_name = each.value.resource_group_name
}