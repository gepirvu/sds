#-----------------------------------------------------------------------------------------#
# Azure container app environment                                                         #
#-----------------------------------------------------------------------------------------#

resource "azurerm_container_app_environment" "cae" {
  resource_group_name = var.resource_group_name
  location            = var.location

  # General
  name                               = local.ca_env_name
  infrastructure_resource_group_name = local.infrastructure_resource_group_name


  # Workload Profile
  dynamic "workload_profile" {
    for_each = var.cae_workload_profiles != null && var.cae_workload_profiles != {} ? { for config in var.cae_workload_profiles : config.name => config } : {}
    content {
      name                  = workload_profile.value.name
      workload_profile_type = workload_profile.value.workload_profile_type
      maximum_count         = workload_profile.value.maximum_count
      minimum_count         = workload_profile.value.minimum_count
    }
  }

  # Networking
  infrastructure_subnet_id       = var.infra_subnet_configs != null ? data.azurerm_subnet.cae_subnet[0].id : null
  internal_load_balancer_enabled = data.azurerm_subnet.cae_subnet[0].id != null ? true : false
  zone_redundancy_enabled        = data.azurerm_subnet.cae_subnet[0].id != null ? true : false

  # Monitoring
  log_analytics_workspace_id = var.log_analytics_workspace_name != null ? data.azurerm_log_analytics_workspace.law[0].id : null

  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}


resource "time_sleep" "wait_30_seconds" {
  depends_on = [azurerm_container_app_environment.cae]

  create_duration = "30s"
}



#-----------------------------------------------------------------------------------------#
# Custom domain and certificates                                                          #
#-----------------------------------------------------------------------------------------#


resource "azapi_resource_action" "azurerm_container_app_environment_identities" {
  type                   = "Microsoft.App/managedEnvironments@2024-02-02-preview"
  resource_id            = azurerm_container_app_environment.cae.id
  method                 = "PATCH"
  response_export_values = ["identity"]
  body = {
    identity = {
      type = "systemassigned"
    }
  }
}

resource "azurerm_role_assignment" "cae_role_assignment" {
  for_each             = var.cae_custom_certificates != null ? { for config in var.cae_custom_certificates : config.keyvault_certificate_name => config } : {}
  scope                = data.azurerm_key_vault_secret.key_vault_secret[each.value.keyvault_certificate_name].resource_id
  role_definition_name = "Key Vault Certificate User"
  principal_id         = azapi_resource_action.azurerm_container_app_environment_identities.output.identity.principalId
}

resource "azurerm_container_app_environment_certificate" "container_app_environment_certificate" {
  for_each                     = var.cae_custom_certificates != null ? { for config in var.cae_custom_certificates : config.cae_certificate_friendly_name => config } : {}
  name                         = each.value.cae_certificate_friendly_name
  container_app_environment_id = azurerm_container_app_environment.cae.id
  certificate_blob_base64      = data.azurerm_key_vault_secret.key_vault_secret[each.value.keyvault_certificate_name].value
  certificate_password         = ""
  depends_on                   = [azurerm_role_assignment.cae_role_assignment]

}


resource "time_sleep" "wait_30_seconds_destroy" {
  depends_on = [azurerm_container_app_environment_certificate.container_app_environment_certificate]

  destroy_duration = "30s"
}

