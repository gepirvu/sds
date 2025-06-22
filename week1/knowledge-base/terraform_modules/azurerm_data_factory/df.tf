
resource "azurerm_data_factory" "data_factory" {
  name                = local.data_factory_name
  location            = var.location
  resource_group_name = var.resource_group_name

  managed_virtual_network_enabled = var.managed_virtual_network_enabled
  public_network_enabled          = false

  purview_id = var.purview_id



  dynamic "identity" {
    for_each = var.identity_type == null ? [] : ["enabled"]
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" || var.identity_type == "SystemAssigned,UserAssigned" ? [for identity in data.azurerm_user_assigned_identity.umids : identity.id] : []
    }
  }

  dynamic "global_parameter" {
    for_each = var.global_parameters

    content {
      name  = global_parameter.value.name
      type  = global_parameter.value.type
      value = global_parameter.value.value
    }
  }


  dynamic "vsts_configuration" {
    for_each = var.vsts_configuration == null ? [] : ["enabled"]

    content {
      account_name       = var.vsts_configuration.account_name
      project_name       = var.vsts_configuration.project_name
      repository_name    = var.vsts_configuration.repository
      branch_name        = var.vsts_configuration.branch
      root_folder        = var.vsts_configuration.root_folder
      tenant_id          = var.vsts_configuration.tenant_id
      publishing_enabled = var.vsts_configuration.publishing_enabled
    }

  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}

resource "azurerm_private_endpoint" "private_endpoint" {

  name                = "${local.data_factory_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.pe_subnets.id

  private_service_connection {
    name                           = "${local.data_factory_name}-pe-sc"
    private_connection_resource_id = azurerm_data_factory.data_factory.id
    is_manual_connection           = false
    subresource_names              = ["dataFactory"]
  }

  private_dns_zone_group {
    name                 = "privatelink.datafactory.azure.net"
    private_dns_zone_ids = [local.private_dns_zone_id]
  }

  lifecycle {
    ignore_changes = [tags]
  }

}


resource "azurerm_data_factory_integration_runtime_azure" "data_factory_integration_runtime_azure" {
  for_each = var.azure_integration_runtimes != null ? { for runtime in var.azure_integration_runtimes : runtime.name => runtime } : {}

  name                    = substr("${local.data_factory_name}-ir-${each.key}", 0, 63)
  location                = var.location
  data_factory_id         = azurerm_data_factory.data_factory.id
  description             = each.value.description
  cleanup_enabled         = each.value.cleanup_enabled
  compute_type            = each.value.compute_type
  core_count              = each.value.core_count
  time_to_live_min        = each.value.time_to_live_min
  virtual_network_enabled = each.value.virtual_network_enabled


}

resource "azurerm_data_factory_integration_runtime_self_hosted" "data_factory_integration_runtime_self_hosted" {
  for_each = var.self_hosted_integration_runtimes != null ? { for runtime in var.self_hosted_integration_runtimes : runtime.name => runtime } : {}

  name            = substr("${local.data_factory_name}-ir-${each.key}", 0, 63)
  data_factory_id = azurerm_data_factory.data_factory.id
  description     = each.value.description

}