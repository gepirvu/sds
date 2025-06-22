#Groups RBAC Namespace

resource "azurerm_role_assignment" "rbac_aks_writer" {
  for_each = {
    for combination in toset(local.role_group_combinations_writer) :
    "${combination.namespace}-${combination.group_name}" => {
      namespace  = combination.namespace
      group_name = combination.group_name
    } if combination.group_name != null
  }

  scope                = "${azurerm_kubernetes_cluster.aks.id}/namespaces/${each.value.namespace}"
  principal_id         = data.azuread_group.group_objects_writer["${each.value.namespace}-${each.value.group_name}"].object_id
  role_definition_name = "Azure Kubernetes Service RBAC Writer"
}

resource "azurerm_role_assignment" "rbac_aks_reader" {
  for_each = {
    for combination in toset(local.role_group_combinations_reader) :
    "${combination.namespace}-${combination.group_name}" => {
      namespace  = combination.namespace
      group_name = combination.group_name
    } if combination.group_name != null
  }

  scope                = "${azurerm_kubernetes_cluster.aks.id}/namespaces/${each.value.namespace}"
  principal_id         = data.azuread_group.group_objects_reader["${each.value.namespace}-${each.value.group_name}"].object_id
  role_definition_name = "Azure Kubernetes Service RBAC Reader"
}

#Groups RBAC Generic

resource "azurerm_role_assignment" "aks-reader" {
  for_each                         = toset(flatten([for g in data.azuread_group.azuread_group_readers : g.object_id]))
  principal_id                     = each.value
  scope                            = azurerm_kubernetes_cluster.aks.id
  role_definition_name             = "Azure Kubernetes Service RBAC Reader"
  skip_service_principal_aad_check = false
}

resource "azurerm_role_assignment" "aks-admin" {
  for_each                         = toset(flatten([for g in data.azuread_group.azuread_group_admin : g.object_id]))
  principal_id                     = each.value
  scope                            = azurerm_kubernetes_cluster.aks.id
  role_definition_name             = "Azure Kubernetes Service RBAC Admin"
  skip_service_principal_aad_check = false
}


#-----------------------------------------------------------------------------------------------
# Kubernetes cluster - RBACs
#-----------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "aks-admin-spi" {
  principal_id                     = data.azurerm_client_config.current.object_id
  scope                            = azurerm_kubernetes_cluster.aks.id
  role_definition_name             = "Azure Kubernetes Service RBAC Admin"
  skip_service_principal_aad_check = false
}

resource "azurerm_role_assignment" "acr" {
  count                            = var.acr_name != null ? 1 : 0
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  scope                            = local.acr_id
  role_definition_name             = "AcrPull"
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "aks-vnet" {
  principal_id                     = azurerm_user_assigned_identity.user_assigned_identity.principal_id
  scope                            = data.azurerm_virtual_network.aks_vnet.id
  role_definition_name             = "Network Contributor"
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "loga" {
  principal_id                     = azurerm_user_assigned_identity.user_assigned_identity.principal_id
  scope                            = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
  role_definition_name             = "Log Analytics Contributor"
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "aks_uai_route_table_contributor" {
  scope                = data.azurerm_subnet.subnet.route_table_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id
}

# Secret Provider

resource "azurerm_role_assignment" "aks_secretprovider_keyvault_certificates" {
  scope                = data.azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Certificate User"
  principal_id         = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].object_id
}

resource "azurerm_role_assignment" "aks_secretprovider_keyvault_secrets" {
  scope                = data.azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].object_id
}

