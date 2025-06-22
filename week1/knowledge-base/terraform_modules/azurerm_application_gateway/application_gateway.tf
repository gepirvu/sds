

resource "azurerm_user_assigned_identity" "agw" {
  location            = var.location
  resource_group_name = var.resource_group_name
  name                = local.user_assigned_identity_name

}

resource "azurerm_key_vault_access_policy" "agw" {
  count        = var.key_vault_rbac ? 0 : 1
  key_vault_id = local.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.agw.principal_id

  secret_permissions = [
    "Get"
  ]

}

resource "azurerm_role_assignment" "agw" {
  depends_on = [azurerm_user_assigned_identity.agw]
  count      = var.key_vault_rbac ? 1 : 0

  scope                = local.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.agw.principal_id
  principal_type       = "ServicePrincipal"

}


resource "azurerm_public_ip" "public_ip" {
  count = var.appgw_public != false ? 1 : 0

  name                = local.public_ip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = [1, 2, 3]
  lifecycle {
    ignore_changes = [tags]
  }

}


resource "azurerm_application_gateway" "agw" {
  depends_on          = [azurerm_user_assigned_identity.agw, azurerm_key_vault_access_policy.agw, azurerm_role_assignment.agw]
  name                = local.application_gateway_name
  resource_group_name = var.resource_group_name
  location            = var.location
  zones               = var.zones
  firewall_policy_id  = var.firewall_policy_id

  autoscale_configuration {
    min_capacity = var.capacity.min
    max_capacity = var.capacity.max
  }

  sku {
    name = var.sku_name
    tier = var.sku_tier
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.agw.id]
  }

  # Certificates from local



  dynamic "trusted_root_certificate" {
    for_each = var.trusted_root_certificates
    content {
      name = trusted_root_certificate.value["name"]
      data = filebase64("${var.certificates_path}${trusted_root_certificate.value["certificate"]}")
    }
  }

  dynamic "ssl_certificate" {
    for_each = title(lower(var.certificates_load_type)) == "Keyvault" ? var.ssl_certificates_keyvault : []
    content {
      name                = ssl_certificate.value["name"]
      key_vault_secret_id = ssl_certificate.value["key_vault_secret_or_certificate_id"]
    }
  }


  # Configuration 

  gateway_ip_configuration {
    name      = "gateway-ip-configuration"
    subnet_id = local.azurerm_subnet_id
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.appgw_public != false ? ["1"] : []
    content {
      name                 = format("%s-public", local.frontend_ip_configuration_name)
      public_ip_address_id = azurerm_public_ip.public_ip[0].id
    }
  }

  frontend_ip_configuration {
    name                          = format("%s-private", local.frontend_ip_configuration_name)
    subnet_id                     = local.azurerm_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.private_ip
  }

  dynamic "frontend_port" {
    for_each = var.frontend_port
    content {
      name = "${local.frontend_port_name}_${frontend_port.value}"
      port = frontend_port.value
    }
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools
    content {
      name         = backend_address_pool.value["name"]
      ip_addresses = length(backend_address_pool.value["ip"]) > 0 ? backend_address_pool.value["ip"] : null
      fqdns        = length(backend_address_pool.value["fqdns"]) > 0 ? backend_address_pool.value["fqdns"] : null
    }
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_pools_associate_nics
    content {
      name = backend_address_pool.key
    }
  }

  dynamic "backend_http_settings" {

    for_each = var.backend_http_settings

    content {

      cookie_based_affinity               = backend_http_settings.value["cookie_based_affinity"]
      name                                = backend_http_settings.value["name"]
      path                                = backend_http_settings.value["path"]
      port                                = backend_http_settings.value["port"]
      protocol                            = backend_http_settings.value["protocol"]
      request_timeout                     = backend_http_settings.value["request_timeout"]
      probe_name                          = backend_http_settings.value["probe_name"] == "" ? null : backend_http_settings.value["probe_name"]
      pick_host_name_from_backend_address = backend_http_settings.value["pick_hostname"]
      host_name                           = backend_http_settings.value["pick_hostname"] == true ? null : backend_http_settings.value["host_name"]
      trusted_root_certificate_names      = backend_http_settings.value["trusted_root_certificate_names"]

      connection_draining {
        enabled           = backend_http_settings.value["connection_draining_enabled"]
        drain_timeout_sec = backend_http_settings.value["connection_draining_timeout_sec"]
      }
    }

  }

  dynamic "http_listener" {
    for_each = var.http_listeners

    content {
      name                           = http_listener.value["name"]
      frontend_ip_configuration_name = var.appgw_public == true ? format("%s-public", local.frontend_ip_configuration_name) : format("%s-private", local.frontend_ip_configuration_name)
      frontend_port_name             = "${local.frontend_port_name}_${http_listener.value["frontend_port_number"]}"
      host_name                      = http_listener.value["host_name"]
      protocol                       = http_listener.value["protocol"]
      require_sni                    = http_listener.value["require_sni"]
      ssl_certificate_name           = http_listener.value["ssl_certificate_name"]
    }
  }


  dynamic "probe" {
    for_each = var.probes

    content {
      interval                                  = probe.value["interval"]
      name                                      = probe.value["name"]
      protocol                                  = probe.value["protocol"]
      path                                      = probe.value["path"]
      timeout                                   = probe.value["timeout"]
      unhealthy_threshold                       = probe.value["unhealthy_threshold"]
      host                                      = probe.value["pick_hostname_backend"] == true ? null : probe.value["host"]
      pick_host_name_from_backend_http_settings = probe.value["pick_hostname_backend"]
      match {
        status_code = probe.value["match_status_code"]
        body        = ""
      }
    }
  }

  dynamic "redirect_configuration" {
    for_each = var.redirect_configurations
    content {
      name                 = redirect_configuration.value["name"]
      redirect_type        = redirect_configuration.value["redirect_type"]
      target_url           = redirect_configuration.value["target_url"]
      include_path         = redirect_configuration.value["include_path"]
      include_query_string = redirect_configuration.value["include_query_string"]
    }
  }

  dynamic "url_path_map" {
    for_each = var.url_path_map
    content {
      name = url_path_map.value["name"]

      dynamic "path_rule" {
        for_each = url_path_map.value["path_rule"]
        content {
          name                        = path_rule.value["name"]
          paths                       = path_rule.value["paths"]
          backend_http_settings_name  = path_rule.value["backend_http_settings_name"]
          backend_address_pool_name   = path_rule.value["backend_address_pool_name"]
          redirect_configuration_name = (path_rule.value["redirect_configuration_name"] == "") || (path_rule.value["backend_address_pool_name"] != "") || (path_rule.value["backend_http_settings_name"] != "") ? null : path_rule.value["redirect_configuration_name"]
        }
      }

      dynamic "path_rule" {
        for_each = url_path_map.value["redirect_setting"]
        content {
          name                        = path_rule.value["name"]
          paths                       = path_rule.value["paths"]
          backend_http_settings_name  = path_rule.value["backend_http_settings_name"]
          backend_address_pool_name   = path_rule.value["backend_address_pool_name"]
          redirect_configuration_name = (path_rule.value["redirect_configuration_name"] == "") || (path_rule.value["backend_address_pool_name"] != "") || (path_rule.value["backend_http_settings_name"] != "") ? null : path_rule.value["redirect_configuration_name"]
        }
      }

      default_backend_address_pool_name   = (url_path_map.value["default_backend_address_pool_name"] == "") || (url_path_map.value["default_redirect_configuration_name"] != "") ? null : url_path_map.value["default_backend_address_pool_name"]
      default_backend_http_settings_name  = (url_path_map.value["backend_settings_name"] == "") || (url_path_map.value["default_redirect_configuration_name"] != "") ? null : url_path_map.value["backend_settings_name"]
      default_redirect_configuration_name = (url_path_map.value["default_backend_address_pool_name"] != "") || (url_path_map.value["backend_settings_name"] != "") || (url_path_map.value["default_redirect_configuration_name"] == "") ? null : url_path_map.value["default_redirect_configuration_name"]
    }
  }

  dynamic "rewrite_rule_set" {
    for_each = var.rewrite_rule_sets

    content {
      name = rewrite_rule_set.value["name"]

      dynamic "rewrite_rule" {
        for_each = rewrite_rule_set.value["rewrite_rules"]

        content {
          name          = rewrite_rule.value["name"]
          rule_sequence = rewrite_rule.value["rule_sequence"]

          dynamic "condition" {
            for_each = rewrite_rule.value["conditions"]

            content {
              variable    = condition.value["variable"]
              pattern     = condition.value["pattern"]
              ignore_case = condition.value["ignore_case"]
              negate      = condition.value["negate"]
            }
          }

          dynamic "request_header_configuration" {
            for_each = rewrite_rule.value["request_header_configurations"]

            content {
              header_name  = request_header_configuration.value["header_name"]
              header_value = request_header_configuration.value["header_value"]
            }
          }

          dynamic "response_header_configuration" {
            for_each = rewrite_rule.value["response_header_configurations"]

            content {
              header_name  = response_header_configuration.value["header_name"]
              header_value = response_header_configuration.value["header_value"]
            }
          }

          dynamic "url" {
            for_each = rewrite_rule.value["urls"]

            content {
              path         = url.value["path"]
              query_string = url.value["query_string"]
              reroute      = url.value["reroute"]
            }
          }
        }
      }
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rules

    content {
      name                        = request_routing_rule.value["name"]
      priority                    = request_routing_rule.value["priority"]
      rule_type                   = request_routing_rule.value["rule_type"]
      http_listener_name          = request_routing_rule.value["http_listener_name"]
      backend_address_pool_name   = (request_routing_rule.value["backend_address_pool_name"] == "") || (title(lower(request_routing_rule.value["rule_type"])) != "Basic") || (request_routing_rule.value["redirect_configuration_name"] != "") ? null : request_routing_rule.value["backend_address_pool_name"]
      url_path_map_name           = request_routing_rule.value["url_path_map_name"] == "" ? null : request_routing_rule.value["url_path_map_name"]
      backend_http_settings_name  = (request_routing_rule.value["backend_http_settings_name"] == "") || (title(lower(request_routing_rule.value["rule_type"])) != "Basic") || (request_routing_rule.value["redirect_configuration_name"] != "") ? null : request_routing_rule.value["backend_http_settings_name"]
      redirect_configuration_name = (request_routing_rule.value["redirect_configuration_name"] == "") || (request_routing_rule.value["backend_address_pool_name"] != "") || (request_routing_rule.value["backend_http_settings_name"] != "") || title(lower(request_routing_rule.value["rule_type"])) != "Basic" ? null : request_routing_rule.value["redirect_configuration_name"]
    }
  }

  ssl_policy {
    policy_type          = "Custom"
    min_protocol_version = "TLSv1_2"
    cipher_suites        = var.cipher_suites
  }

  dynamic "waf_configuration" {
    for_each = var.waf_enabled == true ? [1] : []
    content {
      enabled                  = var.waf_enabled
      firewall_mode            = var.waf_mode
      rule_set_type            = "OWASP"
      rule_set_version         = var.waf_rule_version
      file_upload_limit_mb     = var.waf_file_upload_limit_mb
      request_body_check       = true
      max_request_body_size_kb = var.waf_max_request_body_size_kb


      dynamic "disabled_rule_group" {
        for_each = var.waf_disabled_rule_group
        content {
          rule_group_name = waf_disabled_rule_group.value["rule_group_name"]
        }
      }
    }
  }
  lifecycle {
    ignore_changes = [tags]
  }


}

resource "azurerm_network_interface" "endpoint_backend_nic" {
  count               = length(var.backend_address_pools) > 0 && var.create_backend_nic == true ? length(var.backend_address_pools) : 0
  location            = var.location
  name                = element(var.network_interfaces, count.index)
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = format("ipconf-%s", element(var.network_interfaces, count.index))
    subnet_id                     = element(var.subnet_ids_nic_association, count.index)
    private_ip_address            = var.private_ip_address_allocation == "Static" ? var.private_ip_addresses_nic_association[count.index] : null
    private_ip_address_allocation = var.private_ip_address_allocation
  }
  lifecycle {
    ignore_changes = [tags]
  }

}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "agw_nic" {
  count                   = length(var.backend_address_pools) > 0 && var.create_backend_nic == true ? length(var.backend_address_pools) : 0
  network_interface_id    = azurerm_network_interface.endpoint_backend_nic[count.index].id
  ip_configuration_name   = format("ipconf-%s", element(var.network_interfaces, count.index))
  backend_address_pool_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/applicationGateways/${local.application_gateway_name}/backendAddressPools/${var.backend_address_pools[count.index].name}"
  depends_on              = [azurerm_application_gateway.agw, azurerm_network_interface.endpoint_backend_nic]
}


