output "aks_id" {
  value       = azurerm_kubernetes_cluster.aks.id
  description = "The ID of the Azure Kubernetes Service (AKS) cluster."
}

output "azurerm_kubernetes_cluster_fqdn" {
  value       = azurerm_kubernetes_cluster.aks.fqdn
  description = "The fully qualified domain name (FQDN) of the AKS cluster."
}

output "azurerm_kubernetes_cluster_node_resource_group" {
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
  description = "The name of the Azure Resource Group where the AKS cluster's nodes are deployed."
}

output "azurerm_kubernetes_cluster_oidc_issuer_url" {
  value       = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  description = "The URL of the OpenID Connect (OIDC) issuer for the AKS cluster."
}
