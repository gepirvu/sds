resource "azurerm_service_plan" "azure_serviceplan" {
  name                = local.serviceplan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.service_plan_os_type
  sku_name            = var.service_plan_sku_name
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_linux_web_app" "lin" {

  for_each                      = { for n in var.app_services : n.appservice_short_description => n }
  name                          = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-${each.value.appservice_short_description}-as")
  resource_group_name           = var.resource_group_name
  location                      = var.location
  service_plan_id               = azurerm_service_plan.azure_serviceplan.id
  https_only                    = true
  client_affinity_enabled       = each.value.client_affinity_enabled
  public_network_access_enabled = false

  dynamic "site_config" {
    for_each = each.value.application_stack == "docker" ? [1] : []
    content {
      container_registry_use_managed_identity = true
      ftps_state                              = "FtpsOnly"
      application_stack {
        docker_image_name   = each.value.docker_image_name
        docker_registry_url = var.docker_registry_url
      }
      health_check_path                 = each.value.health_check_path
      health_check_eviction_time_in_min = each.value.health_check_eviction_time_in_min
      worker_count                      = each.value.worker_count
    }
  }

  dynamic "site_config" {
    for_each = each.value.application_stack == "dotnet" ? [1] : []
    content {
      application_stack {
        dotnet_version = each.value.dotnet_version
      }
      container_registry_use_managed_identity = each.value.acr_use_managed_identity_credentials
      always_on                               = each.value.always_on
      default_documents                       = var.default_documents
      ftps_state                              = "FtpsOnly"
      health_check_path                       = each.value.health_check_path
      health_check_eviction_time_in_min       = each.value.health_check_eviction_time_in_min
      http2_enabled                           = true
      vnet_route_all_enabled                  = each.value.vnet_route_all_enabled
      websockets_enabled                      = each.value.websockets_enabled
      use_32_bit_worker                       = false
      worker_count                            = each.value.worker_count
    }
  }

  dynamic "site_config" {
    for_each = each.value.application_stack == "python" ? [1] : []
    content {
      application_stack {
        python_version = each.value.python_version
      }
      container_registry_use_managed_identity = each.value.acr_use_managed_identity_credentials
      always_on                               = each.value.always_on
      default_documents                       = var.default_documents
      ftps_state                              = "FtpsOnly"
      health_check_path                       = each.value.health_check_path
      health_check_eviction_time_in_min       = each.value.health_check_eviction_time_in_min
      http2_enabled                           = true
      vnet_route_all_enabled                  = each.value.vnet_route_all_enabled
      websockets_enabled                      = each.value.websockets_enabled
      use_32_bit_worker                       = false
      worker_count                            = each.value.worker_count
    }
  }

  dynamic "identity" {
    for_each = each.value.identity_type != null ? { identity = true } : {}
    content {
      type         = can(regex("SystemAssigned", each.value.identity_type)) && can(regex("UserAssigned", each.value.identity_type)) ? "SystemAssigned, UserAssigned" : can(regex("SystemAssigned", each.value.identity_type)) ? "SystemAssigned" : can(regex("UserAssigned", each.value.identity_type)) ? "UserAssigned" : null
      identity_ids = can(regex("UserAssigned", each.value.identity_type)) ? values(data.azurerm_user_assigned_identity.webapp_umids)[*].id : null
    }
  }

  app_settings = lookup(var.app_settings, each.value.app_settings_name, null)

  lifecycle {
    ignore_changes = [
      tags, app_settings, site_config, virtual_network_subnet_id // Ignore changes to app_settings attribute
    ]
  }
}

resource "azurerm_role_assignment" "pull_image" {
  for_each = {
    for key, app in azurerm_linux_web_app.lin :
    key => app
    if lookup(local.app_services_with_acr, key, null) != null
  }
  role_definition_name = "AcrPull"
  scope                = data.azurerm_container_registry.acr_id[0].id
  principal_id         = each.value.identity[0].principal_id
}

resource "azurerm_role_assignment" "pull_image_umid" {
  for_each             = data.azurerm_user_assigned_identity.webapp_umids
  role_definition_name = "AcrPull"
  scope                = data.azurerm_container_registry.acr_id[0].id
  principal_id         = each.value.principal_id
}

resource "azurerm_linux_web_app_slot" "deployment_slot" {
  for_each                      = { for n in var.deployment_slots : n.deployment_slot_name => n }
  name                          = lower(each.value.deployment_slot_name)
  app_service_id                = azurerm_linux_web_app.lin[each.value.appservice_short_description].id
  https_only                    = true
  client_affinity_enabled       = each.value.client_affinity_enabled
  public_network_access_enabled = false
  app_settings                  = lookup(var.app_settings, each.value.app_settings_name, null)

  dynamic "site_config" {
    for_each = each.value.application_stack == "docker" ? [1] : []
    content {
      container_registry_use_managed_identity = true
      ftps_state                              = "FTPsOnly"
      worker_count                            = each.value.worker_count

      application_stack {
        docker_image_name   = each.value.docker_image_name
        docker_registry_url = var.docker_registry_url
      }
    }
  }

  dynamic "site_config" {
    for_each = each.value.application_stack == "dotnet" ? [1] : []
    content {
      application_stack {
        dotnet_version = each.value.dotnet_version
      }
      container_registry_use_managed_identity = each.value.acr_use_managed_identity_credentials
      always_on                               = each.value.always_on
      default_documents                       = var.default_documents
      ftps_state                              = "FtpsOnly"
      health_check_path                       = each.value.health_check_path
      health_check_eviction_time_in_min       = each.value.health_check_eviction_time_in_min
      http2_enabled                           = true
      vnet_route_all_enabled                  = each.value.vnet_route_all_enabled
      websockets_enabled                      = each.value.websockets_enabled
      use_32_bit_worker                       = false
      worker_count                            = each.value.worker_count
    }
  }

  dynamic "site_config" {
    for_each = each.value.application_stack == "python" ? [1] : []
    content {
      application_stack {
        python_version = each.value.python_version
      }
      container_registry_use_managed_identity = each.value.acr_use_managed_identity_credentials
      always_on                               = each.value.always_on
      ftps_state                              = "FtpsOnly"
      health_check_path                       = each.value.health_check_path
      health_check_eviction_time_in_min       = each.value.health_check_eviction_time_in_min
      http2_enabled                           = true
      vnet_route_all_enabled                  = each.value.vnet_route_all_enabled
      websockets_enabled                      = each.value.websockets_enabled
      use_32_bit_worker                       = false
      worker_count                            = each.value.worker_count
    }
  }

  dynamic "identity" {
    for_each = each.value.identity_type != null ? { identity = true } : {}

    content {
      type         = can(regex("SystemAssigned", each.value.identity_type)) && can(regex("UserAssigned", each.value.identity_type)) ? "SystemAssigned, UserAssigned" : can(regex("SystemAssigned", each.value.identity_type)) ? "SystemAssigned" : can(regex("UserAssigned", each.value.identity_type)) ? "UserAssigned" : null
      identity_ids = can(regex("UserAssigned", each.value.identity_type)) ? values(data.azurerm_user_assigned_identity.webapp_umids)[*].id : null
    }
  }

  lifecycle {
    ignore_changes = [
      app_settings, site_config, virtual_network_subnet_id // Ignore changes to app_settings attribute
    ]
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "azure_vnet_connection" {
  for_each       = azurerm_linux_web_app.lin
  app_service_id = each.value.id
  subnet_id      = data.azurerm_subnet.vint_subnets.id
}

resource "azurerm_private_endpoint" "private_endpoint" {
  for_each            = azurerm_linux_web_app.lin
  name                = lower("${each.value.name}-pe")
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.pe_subnets.id
  private_service_connection {
    name                           = lower("${each.value.name}-pe-sc")
    private_connection_resource_id = each.value.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }
  private_dns_zone_group {
    name                 = "privatelink.azurewebsites.net"
    private_dns_zone_ids = [local.private_dns_zone_id]
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_endpoint" "private_endpoint_slots" {
  for_each            = { for n in var.deployment_slots : n.deployment_slot_name => n }
  depends_on          = [azurerm_linux_web_app_slot.deployment_slot]
  name                = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-${each.value.appservice_short_description}-as-${each.value.deployment_slot_name}-pe")
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.pe_subnets.id

  private_service_connection {
    name                           = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-${each.value.appservice_short_description}-as-${each.value.deployment_slot_name}-pe-sc")
    private_connection_resource_id = azurerm_linux_web_app.lin[each.value.appservice_short_description].id
    is_manual_connection           = false
    subresource_names              = ["sites-${each.value.deployment_slot_name}"]
  }

  private_dns_zone_group {
    name                 = "privatelink.azurewebsites.net"
    private_dns_zone_ids = [local.private_dns_zone_id]
  }
  lifecycle {
    ignore_changes = [tags]
  }
}