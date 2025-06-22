#-------------------------------------------------------------------------------------------#
# Azure Container App                                                                       #
#-------------------------------------------------------------------------------------------#

resource "azurerm_container_app_job" "ca_job" {
  for_each                     = { for config in var.container_apps_jobs : config.name => config }
  name                         = lower("axso-${var.subscription}-appl-${substr(var.project_name, 0, 5)}-${var.environment}-${substr(each.value.name, 0, 5)}-ca")
  location                     = var.location
  resource_group_name          = var.resource_group_name
  container_app_environment_id = azurerm_container_app_environment.cae.id
  workload_profile_name        = each.value.workload_profile_name
  replica_timeout_in_seconds   = each.value.replica_timeout_in_seconds
  replica_retry_limit          = each.value.replica_retry_limit

  dynamic "manual_trigger_config" {
    for_each = each.value.manual_trigger_config != null ? [each.value.manual_trigger_config] : []
    content {
      parallelism              = manual_trigger_config.value.parallelism
      replica_completion_count = manual_trigger_config.value.replica_completion_count
    }
  }
  dynamic "schedule_trigger_config" {
    for_each = each.value.schedule_trigger_config != null ? [each.value.schedule_trigger_config] : []
    content {
      cron_expression          = schedule_trigger_config.value.cron_expression
      parallelism              = schedule_trigger_config.value.parallelism
      replica_completion_count = schedule_trigger_config.value.replica_completion_count
    }
  }
  dynamic "event_trigger_config" {
    for_each = each.value.event_trigger_config != null ? [each.value.event_trigger_config] : []
    content {
      parallelism              = event_trigger_config.value.parallelism
      replica_completion_count = event_trigger_config.value.replica_completion_count
      scale {
        max_executions              = event_trigger_config.value.scale.max_executions
        min_executions              = event_trigger_config.value.scale.min_executions
        polling_interval_in_seconds = event_trigger_config.value.scale.polling_interval_in_seconds
        rules {
          name             = event_trigger_config.value.scale.rules.name
          custom_rule_type = event_trigger_config.value.scale.rules.custom_rule_type
          metadata         = event_trigger_config.value.scale.rules.metadata
          dynamic "authentication" {
            for_each = event_trigger_config.value.scale.rules.authentication != null ? event_trigger_config.value.scale.rules.authentication : []
            content {
              secret_name       = authentication.value.secret_name
              trigger_parameter = authentication.value.trigger_parameter
            }
          }
        }
      }
    }
  }



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

    dynamic "volume" {
      for_each = each.value.template.volume != null ? [each.value.template.volume] : []
      content {
        name         = volume.value.name
        storage_name = volume.value.storage_name
        storage_type = volume.value.storage_type
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


