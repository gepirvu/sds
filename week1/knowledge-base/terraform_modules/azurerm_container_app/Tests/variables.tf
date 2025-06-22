# General
variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which the Container App Environment is to be created. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the Container App Environment is to exist. Changing this forces a new resource to be created."
}

variable "project_name" {
  type        = string
  description = "The name of the project. e.g. MDS"
  default     = "prj"
}

variable "subscription" {
  type        = string
  description = "The subscription type e.g. 'p' for prod or 'np' for nonprod"
  default     = "np"
}

variable "environment" {
  type        = string
  description = "The environment. e.g. dev, qa, uat, prod"
  default     = "dev"
}

variable "key_vault_name" {
  type        = string
  description = "The name of the key vault to use for the secrets"

}

variable "ca_umids" {
  type = map(object({
    umid_name    = string
    umid_rg_name = string
  }))
  description = "values for the user managed identities"
}

# User managed identity for ACR
variable "container_registry_server" {
  type        = string
  description = "The name of the container registry server to connect to"
  default     = null
}

variable "acr_umid_name" {
  type        = string
  description = "The name of the user managed identity that has access to the container registry"
  default     = null
}

variable "acr_umid_resource_group" {
  type        = string
  description = "The name for the resource group where the managed identity is located"
  default     = null
}

# Container app configurations
variable "container_app_configs" {
  type = map(object({
    usecase = string

    # Infrastructure Subnet Configurations
    infra_subnet_configs = object({
      infra_subnet_name    = string
      infra_vnet_name      = string
      infra_subnet_rg_name = string
    })

    # Container App Environment- workload profile
    cae_workload_profiles = map(object({
      name                  = string
      workload_profile_type = string
      maximum_count         = number
      minimum_count         = number
    }))

    cae_custom_certificates = map(object({
      key_vault_name                = string
      keyvault_certificate_name     = string
      cae_certificate_friendly_name = string
    }))

    ca_custom_domains = map(object({
      ca_name                       = string
      cae_certificate_friendly_name = string
      ca_custom_domain_name         = string
    }))

    log_analytics_workspace_name = string

    # Container App Environment - Storage Configurations
    cae_storage_configs = map(object({
      storage_config_name     = string
      storage_account_name    = string
      storage_account_rg_name = string
      share_name              = string
      access_mode             = string
    }))

    # Container Apps
    container_apps = map(object({
      name                  = string
      revision_mode         = string
      workload_profile_name = string
      identity_type         = string

      template = object({
        containers = list(object({
          name   = string
          image  = string
          cpu    = number
          memory = string
          args   = list(string)
          volume_mounts = list(object({
            name = string
            path = string
          }))
          env = list(object({
            name        = string
            secret_name = optional(string)
            value       = optional(string)
          }))
          startup_probe = optional(object({
            failure_count_threshold = optional(number, 3)
            header = optional(object({
              name  = string
              value = number
            }), null)
            host                             = optional(string, null)
            interval_seconds                 = optional(number, 10)
            path                             = optional(string, "/")
            port                             = number
            termination_grace_period_seconds = optional(number)
            timeout                          = optional(number, 1)
            transport                        = string
          }), null)
          liveness_probe = optional(object({
            failure_count_threshold = optional(number, 3)
            header = optional(object({
              name  = string
              value = number
            }), null)
            host                             = optional(string, null)
            initial_delay_seconds            = optional(number, 10)
            interval_seconds                 = optional(number, 10)
            path                             = optional(string, "/")
            port                             = number
            termination_grace_period_seconds = optional(number)
            timeout                          = optional(number, 1)
            transport                        = string
          }), null)

          readiness_probe = optional(object({
            failure_count_threshold = optional(number, 3)
            header = optional(object({
              name  = string
              value = number
            }), null)
            host                    = optional(string, null)
            interval_seconds        = optional(number, 10)
            path                    = optional(string, null)
            port                    = number
            success_count_threshold = optional(number, 3)
            timeout                 = optional(number, 1)
            transport               = string
          }), null)

        }))
        min_replicas    = number
        max_replicas    = number
        revision_suffix = optional(string, null)

        azure_queue_scale_rules = optional(list(object({
          name         = string
          queue_name   = string
          queue_length = number
          authentication = object({
            trigger_parameter = string
            secret_name       = string
          })
        })))

        tcp_scale_rules = optional(list(object({
          name                = string
          concurrent_requests = string
          authentication = optional(object({
            trigger_parameter = string
            secret_name       = string
          }))
        })), null)

        http_scale_rules = optional(list(object({
          name                = string
          concurrent_requests = string
          authentication = optional(object({
            trigger_parameter = string
            secret_name       = string
          }))
        })), null)

        volume = object({
          name         = string
          storage_name = string
          storage_type = string
        })
      })

      secrets = optional(list(object({
        name                = string
        identity_type       = optional(string, null)
        umid_name           = optional(string, null)
        key_vault_secret_id = optional(string, null)
        value               = optional(string, null)

      })), [])

      ingress = object({
        allow_insecure_connections = bool
        external_enabled           = bool
        target_port                = number
        exposed_port               = optional(number, null)
        transport                  = string

        ip_security_restriction = list(object({
          name             = string
          ip_address_range = string
          action           = string
        }))

        traffic_weight = optional(list(object({
          label           = optional(string)
          latest_revision = optional(bool)
          revision_suffix = optional(string)
          percentage      = number
        })))

      })

    }))

    container_apps_jobs = map(object({
      name                       = string
      replica_timeout_in_seconds = number
      replica_retry_limit        = number
      workload_profile_name      = string
      identity_type              = string

      manual_trigger_config = optional(object({
        parallelism              = number
        replica_completion_count = number
      }), null)

      schedule_trigger_config = optional(object({
        cron_expression          = string
        parallelism              = number
        replica_completion_count = number
      }), null)

      event_trigger_config = optional(object({
        parallelism              = number
        replica_completion_count = number
        scale = object({
          max_executions              = number
          min_executions              = number
          polling_interval_in_seconds = number
          rules = object({
            name             = string
            custom_rule_type = string
            metadata         = map(string)
            authentication = optional(list(object({
              secret_name       = string
              trigger_parameter = string
            })), null)
          })
        })
      }), null)

      template = object({
        containers = list(object({
          name   = string
          image  = string
          cpu    = number
          memory = string
          args   = list(string)
          volume_mounts = list(object({
            name = string
            path = string
          }))
          env = list(object({
            name        = string
            secret_name = optional(string)
            value       = optional(string)
          }))
          startup_probe = optional(object({
            failure_count_threshold = optional(number, 3)
            header = optional(object({
              name  = string
              value = number
            }), null)
            host                             = optional(string, null)
            interval_seconds                 = optional(number, 10)
            path                             = optional(string, "/")
            port                             = number
            termination_grace_period_seconds = optional(number)
            timeout                          = optional(number, 1)
            transport                        = string
          }), null)
          liveness_probe = optional(object({
            failure_count_threshold = optional(number, 3)
            header = optional(object({
              name  = string
              value = number
            }), null)
            host                             = optional(string, null)
            initial_delay_seconds            = optional(number, 10)
            interval_seconds                 = optional(number, 10)
            path                             = optional(string, "/")
            port                             = number
            termination_grace_period_seconds = optional(number)
            timeout                          = optional(number, 1)
            transport                        = string
          }), null)

          readiness_probe = optional(object({
            failure_count_threshold = optional(number, 3)
            header = optional(object({
              name  = string
              value = number
            }), null)
            host                    = optional(string, null)
            interval_seconds        = optional(number, 10)
            path                    = optional(string, null)
            port                    = number
            success_count_threshold = optional(number, 3)
            timeout                 = optional(number, 1)
            transport               = string
          }), null)

        }))

        volume = object({
          name         = string
          storage_name = string
          storage_type = string
        })
      })

      secrets = optional(list(object({
        name                = string
        identity_type       = optional(string, null)
        umid_name           = optional(string, null)
        key_vault_secret_id = optional(string, null)
        value               = optional(string, null)

      })), [])
    }))

  }))
  description = "Container App configurations"
}

variable "dns_zone_name" {
  type        = string
  description = "The domain name for the custom domain dns zone."
  default     = "cloudinfra.axpo.cloud"

}