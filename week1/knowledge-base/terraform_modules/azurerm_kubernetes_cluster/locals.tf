locals {
  cluster_name                    = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-aks")
  node_resource_group             = lower("MC_axso-${var.subscription}-appl-${var.project_name}-${var.environment}-aks")
  disk_encryption_set_name        = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-aks-des")
  disk_encryption_key_name        = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-aks-key-${random_string.string.result}")
  user_assigned_identity_name     = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-aks-identity")
  des_user_assigned_identity_name = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-des-identity")
  private_dns_zone_id             = "/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/resourceGroups/rg-privatedns-k8s-pe-prod-axpo/providers/Microsoft.Network/privateDnsZones/${var.project_name}.privatelink.westeurope.azmk8s.io"
  acr_id                          = var.acr_name != null ? "/subscriptions/${var.acr_subscription_id}/resourceGroups/${var.acr_resource_group_name}/providers/Microsoft.ContainerRegistry/registries/${var.acr_name}" : null

  #Container Insights
  data_collection_rule_name_msci                             = lower("${local.cluster_name}-msci-dcr")
  azurerm_monitor_data_collection_rule_association_name_msci = lower("${local.cluster_name}-msci-dcra")

  #Prometheus
  data_collection_endpoint_name_prometheus                         = lower("${local.cluster_name}-prometheus-dce")
  data_collection_rule_name_prometheus                             = lower("${local.cluster_name}-prometheus-dcr")
  azurerm_monitor_data_collection_rule_association_name_prometheus = lower("${local.cluster_name}-prometheus-dcra")


}


# Expiration days for the keyvault key
locals {
  days_to_hours = 365 * 24
  // expiration date need to be in a specific format as well
  expiration_date = timeadd(formatdate("YYYY-MM-DD'T'HH:mm:ssZ", timestamp()), "${local.days_to_hours}h")
}

resource "random_string" "string" {
  length      = 4
  upper       = false
  min_numeric = 1
  special     = false
}

locals {
  role_group_combinations_writer = flatten([
    for policy in var.role_assignments_writer :
    [
      for namespace in policy.namespaces :
      [
        for group_name in policy.group_names :
        {
          namespace  = namespace
          group_name = group_name
        }
      ]
    ]
  ])

}
locals {
  role_group_combinations_reader = flatten([
    for policy in var.role_assignments_reader :
    [
      for namespace in policy.namespaces :
      [
        for group_name in policy.group_names :
        {
          namespace  = namespace
          group_name = group_name
        }
      ]
    ]
  ])

}
