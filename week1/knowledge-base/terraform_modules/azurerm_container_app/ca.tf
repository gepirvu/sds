#-------------------------------------------------------------------------------------------#
# Azure Container App                                                                       #
#-------------------------------------------------------------------------------------------#

resource "azurerm_container_app" "ca" {
  for_each                     = { for config in var.container_apps : config.name => config }
  name                         = lower("axso-${var.subscription}-appl-${substr(var.project_name, 0, 5)}-${var.environment}-${substr(each.value.name, 0, 5)}-ca")
  resource_group_name          = var.resource_group_name
  container_app_environment_id = azurerm_container_app_environment.cae.id
  revision_mode                = each.value.revision_mode
  workload_profile_name        = each.value.workload_profile_name

  #-------------------------------------------------------------------------------------------#
  # Container app - registry settings                                                         #
  #-------------------------------------------------------------------------------------------#

  dynamic "registry" {
    for_each = var.container_registry_server != null ? { registry = true } : {}
    content {
      server   = var.container_registry_server
      identity = data.azurerm_user_assigned_identity.acr[0].id
    }
  }

  #-------------------------------------------------------------------------------------------#
  # Container App - Identity settings                                                         #
  #-------------------------------------------------------------------------------------------#

  dynamic "identity" {
    for_each = each.value.identity_type != null ? { identity = true } : {}
    content {
      type         = can(regex("SystemAssigned", each.value.identity_type)) && can(regex("UserAssigned", each.value.identity_type)) ? "SystemAssigned, UserAssigned" : can(regex("SystemAssigned", each.value.identity_type)) ? "SystemAssigned" : can(regex("UserAssigned", each.value.identity_type)) ? "UserAssigned" : null
      identity_ids = can(regex("UserAssigned", each.value.identity_type)) ? values(data.azurerm_user_assigned_identity.umids)[*].id : null
    }
  }

  #-------------------------------------------------------------------------------------------#
  # Container App - Secrets                                                                   #
  #-------------------------------------------------------------------------------------------#

  dynamic "secret" {
    for_each = each.value.secrets
    content {
      name                = secret.value.name
      identity            = each.value.identity_type != "SystemAssigned" || each.value.identity_type == null ? (secret.value.umid_name == null ? null : data.azurerm_user_assigned_identity.umids[secret.value.umid_name].id) : "System"
      key_vault_secret_id = secret.value.key_vault_secret_id
      value               = secret.value.value
    }
  }


  #-------------------------------------------------------------------------------------------#
  # Container App - Templates                                                                 #
  #-------------------------------------------------------------------------------------------#

  template {
    dynamic "container" {
      for_each = each.value.template.containers
      content {
        name   = container.value.name
        image  = container.value.image
        args   = container.value.args
        cpu    = container.value.cpu
        memory = container.value.memory

        dynamic "volume_mounts" {
          for_each = container.value.volume_mounts
          content {
            name = volume_mounts.value.name
            path = volume_mounts.value.path
          }
        }

        dynamic "env" {
          for_each = container.value.env
          content {
            name        = env.value.name
            secret_name = env.value.secret_name
            value       = env.value.value
          }
        }

        dynamic "startup_probe" {
          for_each = container.value.startup_probe != null ? [container.value.startup_probe] : []
          content {
            failure_count_threshold = startup_probe.value.failure_count_threshold

            dynamic "header" {
              for_each = startup_probe.value.header != null ? [startup_probe.value.header] : []
              content {
                name  = header.value.name
                value = header.value.value
              }
            }

            host                             = startup_probe.value.host
            interval_seconds                 = startup_probe.value.interval_seconds
            path                             = startup_probe.value.path
            port                             = startup_probe.value.port
            termination_grace_period_seconds = startup_probe.value.termination_grace_period_seconds
            timeout                          = startup_probe.value.timeout
            transport                        = startup_probe.value.transport
          }
        }

        dynamic "liveness_probe" {
          for_each = container.value.liveness_probe != null ? [container.value.liveness_probe] : []
          content {
            failure_count_threshold = liveness_probe.value.failure_count_threshold

            dynamic "header" {
              for_each = liveness_probe.value.header != null ? [liveness_probe.value.header] : []
              content {
                name  = header.value.name
                value = header.value.value
              }
            }

            host                             = liveness_probe.value.host
            initial_delay                    = liveness_probe.value.initial_delay_seconds
            interval_seconds                 = liveness_probe.value.interval_seconds
            path                             = liveness_probe.value.path
            port                             = liveness_probe.value.port
            termination_grace_period_seconds = liveness_probe.value.termination_grace_period_seconds
            timeout                          = liveness_probe.value.timeout
            transport                        = liveness_probe.value.transport
          }
        }

        dynamic "readiness_probe" {
          for_each = container.value.readiness_probe != null ? [container.value.readiness_probe] : []
          content {
            failure_count_threshold = readiness_probe.value.failure_count_threshold

            dynamic "header" {
              for_each = readiness_probe.value.header != null ? [readiness_probe.value.header] : []
              content {
                name  = header.value.name
                value = header.value.value
              }
            }

            host                    = readiness_probe.value.host
            interval_seconds        = readiness_probe.value.interval_seconds
            path                    = readiness_probe.value.path
            port                    = readiness_probe.value.port
            success_count_threshold = readiness_probe.value.success_count_threshold
            timeout                 = readiness_probe.value.timeout
            transport               = readiness_probe.value.transport
          }
        }
      }
    }

    min_replicas    = each.value.template.min_replicas
    max_replicas    = each.value.template.max_replicas
    revision_suffix = each.value.template.revision_suffix

    dynamic "azure_queue_scale_rule" {
      for_each = each.value.template.azure_queue_scale_rules != null ? each.value.template.azure_queue_scale_rules : []
      content {
        name         = azure_queue_scale_rule.value["name"]
        queue_name   = azure_queue_scale_rule.value["queue_name"]
        queue_length = azure_queue_scale_rule.value["queue_length"]

        dynamic "authentication" {
          for_each = azure_queue_scale_rule.value["authentication"] != null ? [azure_queue_scale_rule.value["authentication"]] : []
          content {
            trigger_parameter = authentication.value["trigger_parameter"]
            secret_name       = authentication.value["secret_name"]
          }
        }
      }
    }

    dynamic "tcp_scale_rule" {
      for_each = each.value.template.tcp_scale_rules != null ? each.value.template.tcp_scale_rules : []
      content {
        name                = tcp_scale_rule.value["name"]
        concurrent_requests = tcp_scale_rule.value["concurrent_requests"]
        dynamic "authentication" {
          for_each = tcp_scale_rule.value["authentication"] != null ? [tcp_scale_rule.value["authentication"]] : []
          content {
            trigger_parameter = authentication.value["trigger_parameter"]
            secret_name       = authentication.value["secret_name"]
          }
        }
      }
    }

    dynamic "http_scale_rule" {
      for_each = each.value.template.http_scale_rules != null ? each.value.template.http_scale_rules : []
      content {
        name                = http_scale_rule.value["name"]
        concurrent_requests = http_scale_rule.value["concurrent_requests"]
        dynamic "authentication" {
          for_each = http_scale_rule.value["authentication"] != null ? [http_scale_rule.value["authentication"]] : []
          content {
            trigger_parameter = authentication.value["trigger_parameter"]
            secret_name       = authentication.value["secret_name"]
          }
        }
      }
    }

    dynamic "volume" {
      for_each = each.value.template.volume != null ? [each.value.template.volume] : []
      content {
        name         = volume.value.name
        storage_name = volume.value.storage_name
        storage_type = volume.value.storage_type
      }
    }
  }

  #-------------------------------------------------------------------------------------------#
  # Container App - Ingress                                                                   #
  #-------------------------------------------------------------------------------------------#

  dynamic "ingress" {
    for_each = each.value.ingress != null ? [each.value.ingress] : []
    content {
      allow_insecure_connections = ingress.value.allow_insecure_connections
      external_enabled           = ingress.value.external_enabled
      target_port                = ingress.value.target_port
      exposed_port               = ingress.value.exposed_port
      transport                  = ingress.value.transport

      dynamic "ip_security_restriction" {
        for_each = ingress.value.ip_security_restriction
        content {
          name             = ip_security_restriction.value.name
          ip_address_range = ip_security_restriction.value.ip_address_range
          action           = ip_security_restriction.value.action
        }
      }

      dynamic "traffic_weight" {
        for_each = ingress.value.traffic_weight
        content {
          label           = traffic_weight.value.label
          latest_revision = traffic_weight.value.latest_revision
          revision_suffix = traffic_weight.value.revision_suffix
          percentage      = traffic_weight.value.percentage
        }
      }

    }
  }

  depends_on = [azurerm_container_app_environment.cae, azurerm_container_app_environment_storage.cae_storage, time_sleep.wait_30_seconds]

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}

#-------------------------------------------------------------------------------------------#

resource "azurerm_container_app_custom_domain" "container_app_custom_domain" {
  for_each                                 = var.ca_custom_domains != null ? { for config in var.ca_custom_domains : config.ca_custom_domain_name => config } : {}
  name                                     = each.value.ca_custom_domain_name != "@" ? "${each.value.ca_custom_domain_name}.${var.dns_zone_name}" : var.dns_zone_name
  container_app_id                         = azurerm_container_app.ca[each.value.ca_name].id
  container_app_environment_certificate_id = azurerm_container_app_environment_certificate.container_app_environment_certificate[each.value.cae_certificate_friendly_name].id
  certificate_binding_type                 = "SniEnabled"
  depends_on                               = [azurerm_container_app_environment_certificate.container_app_environment_certificate, time_sleep.wait_30_seconds_destroy]

}

# Custom dns record
resource "azurerm_private_dns_a_record" "pe_record" {
  for_each            = var.ca_custom_domains != null ? { for config in var.ca_custom_domains : config.ca_custom_domain_name => config } : {}
  name                = each.value.ca_custom_domain_name != "@" ? each.value.ca_custom_domain_name : "@"
  zone_name           = var.dns_zone_name
  resource_group_name = local.private_dns_resource_group_name
  ttl                 = 300
  records             = [azurerm_container_app_environment.cae.static_ip_address]
  provider            = azurerm.dns
}

#### RBAC ####
resource "azurerm_role_assignment" "ca_role_assignment" {
  for_each             = var.ca_umids != null && var.ca_umids != {} && var.key_vault_name != null ? { for config in var.ca_umids : config.umid_name => config } : {}
  scope                = data.azurerm_key_vault.key_vault_secrets[0].id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azurerm_user_assigned_identity.umids[each.value.umid_name].principal_id
}

resource "azurerm_private_dns_a_record" "ca_record" {
  for_each            = { for config in var.container_apps : config.name => config }
  name                = replace(azurerm_container_app.ca[each.key].ingress[0].fqdn, ".${local.standard_private_dns_zone}", "")
  zone_name           = local.standard_private_dns_zone
  resource_group_name = local.private_endpoint_dns_resource_group_name
  ttl                 = 300
  records             = [azurerm_container_app_environment.cae.static_ip_address]
  provider            = azurerm.dns
}

