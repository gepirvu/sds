resource_group_name = "axso-np-appl-ssp-test-rg"
location            = "westeurope"
project_name        = "cloudinfra"
subscription        = "np"
environment         = "dev"
ca_umids = {
  "umid-1" = {
    umid_name    = "axso-np-appl-ssp-test-umid"
    umid_rg_name = "axso-np-appl-ssp-test-rg"
  }
}
container_registry_server = null # The Container Registry server. If not provided, the container registry will not be used.
acr_umid_name             = null # The name of the user assigned identity that can access the container registry.
acr_umid_resource_group   = null # The resource group where the user assigned identity is located that can access the container registry.


#-----------------------------------------------------------------------------------------------------------------#
#   Container App Configuration - Container app environment, Container app environment storage and Container apps #
#-----------------------------------------------------------------------------------------------------------------#

dns_zone_name  = "nonprod.cloudinfra.axpo.cloud"
key_vault_name = "kv-ssp-0-nonprod-axso"

container_app_configs = {
  "ca-app-config-1" = {
    usecase = "buildagent"

    infra_subnet_configs = {
      infra_subnet_name    = "cae"
      infra_vnet_name      = "vnet-cloudinfra-nonprod-axso-e3og"
      infra_subnet_rg_name = "rg-cloudinfra-nonprod-axso-ymiw"
    }

    cae_workload_profiles = {
      "ca-wp-1" = {
        name                  = "ca-wp"
        workload_profile_type = "D4"
        maximum_count         = 2
        minimum_count         = 1
      }
    } # Container app environment - Workload profile configuration ends here.


    cae_custom_certificates = {
      "cae-c-1" = {
        key_vault_name                = "kv-ssp-0-nonprod-axso"
        keyvault_certificate_name     = "front-nonprod-cloudinfra-axpo-cloud" # The name of your certificate store in the KV
        cae_certificate_friendly_name = "front.nonprod.cloudinfra.axpo.cloud"
      },
      "cae-c-12" = {
        key_vault_name                = "kv-ssp-0-nonprod-axso"              # The name of your certificate store in the KV
        keyvault_certificate_name     = "back-nonprod-cloudinfra-axpo-cloud" # Your second certificate
        cae_certificate_friendly_name = "back.nonprod.cloudinfra.axpo.cloud"
      }
    }

    ca_custom_domains = {
      "webapp1-domain1" = {
        ca_name                       = "webapp1" #The name of the webapp, same as the container_apps name
        cae_certificate_friendly_name = "front.nonprod.cloudinfra.axpo.cloud"
        ca_custom_domain_name         = "@" # The domain will be added, so this is front.nonprod.cloudinfra.axpo.cloud, if you want only nonprod.cloudinfra.axpo.cloud, use "@""
      },
      "webapp1-domain2" = {
        ca_name                       = "webapp1" #The name of the webapp, same as the container_apps name
        cae_certificate_friendly_name = "front.nonprod.cloudinfra.axpo.cloud"
        ca_custom_domain_name         = "www.front" #The domain will be added, so this is www.frontend.nonprod.cloudinfra.axpo.cloud
      },
      "userapp1-domain1" = {
        ca_name                       = "userapp1" #The name of the webapp that will have the custom domain, same as the container_apps name
        cae_certificate_friendly_name = "back.nonprod.cloudinfra.axpo.cloud"
        ca_custom_domain_name         = "backend" #The domain will be added, so this is backend.nonprod.cloudinfra.axpo.cloud
      }
    }

    log_analytics_workspace_name = null

    # Container app environment - Storage

    cae_storage_configs = {
      "config-1" = {
        storage_config_name     = "agent-storage"
        storage_account_name    = "axso4p4ssp4np4testsa"
        storage_account_rg_name = "axso-np-appl-ssp-test-rg"
        share_name              = "container-app-test-share-1"
        access_mode             = "ReadOnly"
      },
      "config-2" = {
        storage_config_name     = "agent-storage-2"
        storage_account_name    = "axso4p4ssp4np4testsa"
        storage_account_rg_name = "axso-np-appl-ssp-test-rg"
        share_name              = "container-app-test-share-2"
        access_mode             = "ReadWrite"
      }

    } # Container app environment - Storage configuration ends here.

    # Container Apps

    container_apps = {
      "app1" = {
        name                  = "webapp1"
        workload_profile_name = "ca-wp"
        revision_mode         = "Single"
        identity_type         = "UserAssigned"

        secrets = [
          {
            name                = "secret1"
            identity_type       = "UserAssigned"
            umid_name           = "axso-np-appl-ssp-test-umid"
            key_vault_secret_id = "https://kv-ssp-0-nonprod-axso.vault.azure.net/secrets/ca-test"
          },
          {
            name                = "secret2"
            identity_type       = "UserAssigned"
            umid_name           = "axso-np-appl-ssp-test-umid"
            key_vault_secret_id = "https://kv-ssp-0-nonprod-axso.vault.azure.net/secrets/ca-test-2"
          }
        ] # Container app - Secrets configuration ends here.

        template = {
          containers = [
            {
              name   = "app1-container"
              image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
              cpu    = 0.25
              memory = "0.5Gi"
              args   = []

              volume_mounts = [
                # {
                #   name       = "data-volume"
                #   mount_path = "/data"
                #   read_only  = false
                # }
              ]

              startup_probe = {
                port      = 80
                transport = "HTTP"
              }

              readiness_probe = {
                port      = 80
                transport = "TCP"
              }

              liveness_probe = {
                port      = 80
                transport = "HTTP"
              }

              env = [
                {
                  name  = "MY_NON_PASSWORD_ENV_VARIABLE"
                  value = "Example"
                },
                {
                  name        = "SECRET_PASSWORD"
                  secret_name = "secret1" # The name of the secret in the secrets list 
                },
                {
                  name        = "SECRET_PASSWORD_2"
                  secret_name = "secret2" # The name of the secret in the secrets list 
                }
              ]
            }
          ] # Container app - Template >> Containers configuration ends here.

          min_replicas    = 1
          max_replicas    = 5
          revision_suffix = "v1"

          azure_queue_scale_rules = null

          http_scale_rules = [
            {
              name                = "test"
              concurrent_requests = 80
            }
          ]

          volume = null
          # {
          #   name         = "data-volume"
          #   storage_name = "mystorage"
          #   storage_type = "AzureFile"
          # }
        } # Container app - Template configuration ends here.

        ingress = {
          allow_insecure_connections = false
          external_enabled           = true
          target_port                = 80
          transport                  = "http"

          ip_security_restriction = [ # If you leave this empty, the container will accept all the private traffic
            # {
            #   name             = "Rule-1"
            #   action           = "Allow"
            #   ip_address_range = "10.82.54.0/24"
            # }
          ]
          traffic_weight = [
            {
              label           = "version-v1"
              latest_revision = true
              revision_suffix = null
              percentage      = 100
            }
          ] # Container app - Ingress >> Traffic weight configuration ends here.

        }

      }, # Container app - App1 configuration ends here.

      "app2" = {
        name                  = "userapp1"
        workload_profile_name = "ca-wp"
        revision_mode         = "Single"
        identity_type         = "UserAssigned"

        secrets = [
        ] # Container app - Secrets configuration ends here.

        template = {
          containers = [
            {
              name   = "app1-container"
              image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
              cpu    = 0.25
              memory = "0.5Gi"
              args   = [] #["arg1", "arg2"]

              volume_mounts = [
                # {
                #   name       = "data-volume"
                #   mount_path = "/data"
                #   read_only  = false
                # }
              ]

              env = [
                # {
                #   name        = "ENV_VARIABLE_1"
                #   secret_name = "secret1"
                #   value       = "value1"
                # }
              ]
            }
          ] # Container app - Template >> Containers configuration ends here.

          min_replicas    = 1
          max_replicas    = 5
          revision_suffix = null

          azure_queue_scale_rules = [
            {
              name         = "test"
              queue_name   = "test"
              queue_length = 1
              authentication = {
                trigger_parameter = "test"
                secret_name       = "test"
              }
            }
          ]

          volume = null
          # {
          #   name         = "data-volume"
          #   storage_name = "mystorage"
          #   storage_type = "AzureFile"
          # }
        } # Container app - Template configuration ends here.

        ingress = {
          allow_insecure_connections = false
          external_enabled           = false
          target_port                = 80
          transport                  = "http"

          ip_security_restriction = [
            {
              name             = "Rule-1"
              action           = "Allow"
              ip_address_range = "159.168.125.252/30"
            },
            {
              name             = "Rule-2"
              action           = "Allow"
              ip_address_range = "159.168.126.252/30"
            },
            {
              name             = "Rule-3"
              action           = "Allow"
              ip_address_range = "159.168.7.144/29"
            },
            {
              name             = "Rule-4"
              action           = "Allow"
              ip_address_range = "195.235.153.182/32"
            }
          ]

          traffic_weight = [
            {
              label           = "version-v1"
              latest_revision = true
              revision_suffix = null
              percentage      = 100
            }
          ] # Container app - Ingress >> Traffic weight configuration ends here.
        }
      },

      "app3" = {
        name                  = "rbit1"
        workload_profile_name = "ca-wp"
        revision_mode         = "Single"
        identity_type         = "UserAssigned"

        secrets = [
        ] # Container app - Secrets configuration ends here.

        template = {
          containers = [
            {
              name   = "rabbitmq-container"
              image  = "docker.io/rabbitmq:3-management"
              cpu    = 0.25
              memory = "0.5Gi"
              args   = [] #["arg1", "arg2"]

              volume_mounts = [
                # {
                #   name       = "data-volume"
                #   mount_path = "/data"
                #   read_only  = false
                # }
              ]

              env = [
                # {
                #   name        = "ENV_VARIABLE_1"
                #   secret_name = "secret1"
                #   value       = "value1"
                # }
              ]
            }
          ] # Container app - Template >> Containers configuration ends here.

          min_replicas    = 1
          max_replicas    = 5
          revision_suffix = null

          tcp_scale_rules = [
            {
              name                = "test"
              concurrent_requests = 80
            }
          ]

          volume = null
          # {
          #   name         = "data-volume"
          #   storage_name = "mystorage"
          #   storage_type = "AzureFile"
          # }
        } # Container app - Template configuration ends here.

        ingress = {
          allow_insecure_connections = false
          external_enabled           = true
          target_port                = 5672
          exposed_port               = 5672
          transport                  = "tcp"

          ip_security_restriction = [ # If you leave this empty, the container will accept all the private traffic
            # {
            #   name             = "Rule-1"
            #   action           = "Allow"
            #   ip_address_range = "10.82.54.0/24"
            # }
          ]

          traffic_weight = [
            {
              latest_revision = true
              percentage      = 100
            }
          ]
        }
      }
    } # Container Apps (ALL) configuration ends here.

    container_apps_jobs = {
      "app-job1" = {
        name                       = "wejb1"
        workload_profile_name      = "ca-wp"
        replica_timeout_in_seconds = 10
        replica_retry_limit        = 3
        revision_mode              = "Single"
        identity_type              = "UserAssigned"
        manual_trigger_config = {
          parallelism              = 2
          replica_completion_count = 1
        }

        secrets = [
          {
            name                = "secret1"
            identity_type       = "UserAssigned"
            umid_name           = "axso-np-appl-ssp-test-umid"
            key_vault_secret_id = "https://kv-ssp-0-nonprod-axso.vault.azure.net/secrets/ca-test"
          },
          {
            name                = "secret2"
            identity_type       = "UserAssigned"
            umid_name           = "axso-np-appl-ssp-test-umid"
            key_vault_secret_id = "https://kv-ssp-0-nonprod-axso.vault.azure.net/secrets/ca-test-2"
          }
        ] # Container app - Secrets configuration ends here.

        template = {
          containers = [
            {
              name   = "app1-container"
              image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
              cpu    = 0.25
              memory = "0.5Gi"
              args   = []

              volume_mounts = [
                # {
                #   name       = "data-volume"
                #   mount_path = "/data"
                #   read_only  = false
                # }
              ]

              startup_probe = {
                port      = 80
                transport = "HTTP"
              }

              readiness_probe = {
                port      = 80
                transport = "TCP"
              }

              liveness_probe = {
                port      = 80
                transport = "HTTP"
              }

              env = [
                {
                  name  = "MY_NON_PASSWORD_ENV_VARIABLE"
                  value = "Example"
                },
                {
                  name        = "SECRET_PASSWORD"
                  secret_name = "secret1" # The name of the secret in the secrets list 
                },
                {
                  name        = "SECRET_PASSWORD_2"
                  secret_name = "secret2" # The name of the secret in the secrets list 
                }
              ]
            }
          ] # Container app - Template >> Containers configuration ends here.

          volume = null
          # {
          #   name         = "data-volume"
          #   storage_name = "mystorage"
          #   storage_type = "AzureFile"
          # }
        } # Container app - Template configuration ends here.

      },
      "app-job2" = {
        name                       = "wejb2"
        workload_profile_name      = "ca-wp"
        replica_timeout_in_seconds = 10
        replica_retry_limit        = 3
        revision_mode              = "Single"
        identity_type              = "UserAssigned"
        schedule_trigger_config = {
          cron_expression          = "0 0 * * *" # Every day at midnight
          parallelism              = 2
          replica_completion_count = 1
        }

        secrets = [
          {
            name                = "secret1"
            identity_type       = "UserAssigned"
            umid_name           = "axso-np-appl-ssp-test-umid"
            key_vault_secret_id = "https://kv-ssp-0-nonprod-axso.vault.azure.net/secrets/ca-test"
          },
          {
            name                = "secret2"
            identity_type       = "UserAssigned"
            umid_name           = "axso-np-appl-ssp-test-umid"
            key_vault_secret_id = "https://kv-ssp-0-nonprod-axso.vault.azure.net/secrets/ca-test-2"
          }
        ] # Container app - Secrets configuration ends here.

        template = {
          containers = [
            {
              name   = "app1-container"
              image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
              cpu    = 0.25
              memory = "0.5Gi"
              args   = []

              volume_mounts = [
                # {
                #   name       = "data-volume"
                #   mount_path = "/data"
                #   read_only  = false
                # }
              ]

              startup_probe = {
                port      = 80
                transport = "HTTP"
              }

              readiness_probe = {
                port      = 80
                transport = "TCP"
              }

              liveness_probe = {
                port      = 80
                transport = "HTTP"
              }

              env = [
                {
                  name  = "MY_NON_PASSWORD_ENV_VARIABLE"
                  value = "Example"
                },
                {
                  name        = "SECRET_PASSWORD"
                  secret_name = "secret1" # The name of the secret in the secrets list 
                },
                {
                  name        = "SECRET_PASSWORD_2"
                  secret_name = "secret2" # The name of the secret in the secrets list 
                }
              ]
            }
          ] # Container app - Template >> Containers configuration ends here.

          volume = null
          # {
          #   name         = "data-volume"
          #   storage_name = "mystorage"
          #   storage_type = "AzureFile"
          # }
        } # Container app - Template configuration ends here.

      },
      "app-job3" = {
        name                       = "wejb3"
        workload_profile_name      = "ca-wp"
        replica_timeout_in_seconds = 10
        replica_retry_limit        = 3
        revision_mode              = "Single"
        identity_type              = "UserAssigned"
        event_trigger_config = {
          parallelism              = 2
          replica_completion_count = 1
          scale = {
            min_executions              = 1
            max_executions              = 5
            polling_interval_in_seconds = 60
            rules = {
              name             = "azure-pipelines"
              custom_rule_type = "azure-pipelines"
              metadata = {
                poolName                   = "GEN-CA-TCI"
                targetPipelinesQueueLength = "1"
              }
              authentication = [{
                trigger_parameter = "peersonalaaccesstoken"
                secret_name       = "secret1"
                },
                {
                  trigger_parameter = "organizationURL"
                  secret_name       = "secret2"
                }
              ]
            }
          }
        }
        secrets = [
          {
            name                = "secret1"
            identity_type       = "UserAssigned"
            umid_name           = "axso-np-appl-ssp-test-umid"
            key_vault_secret_id = "https://kv-ssp-0-nonprod-axso.vault.azure.net/secrets/ca-test"
          },
          {
            name                = "secret2"
            identity_type       = "UserAssigned"
            umid_name           = "axso-np-appl-ssp-test-umid"
            key_vault_secret_id = "https://kv-ssp-0-nonprod-axso.vault.azure.net/secrets/ca-test-2"
          }
        ] # Container app - Secrets configuration ends here.

        template = {
          containers = [
            {
              name   = "app1-container"
              image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
              cpu    = 0.25
              memory = "0.5Gi"
              args   = []

              volume_mounts = [
                # {
                #   name       = "data-volume"
                #   mount_path = "/data"
                #   read_only  = false
                # }
              ]

              startup_probe = {
                port      = 80
                transport = "HTTP"
              }

              readiness_probe = {
                port      = 80
                transport = "TCP"
              }

              liveness_probe = {
                port      = 80
                transport = "HTTP"
              }

              env = [
                {
                  name  = "MY_NON_PASSWORD_ENV_VARIABLE"
                  value = "Example"
                },
                {
                  name        = "SECRET_PASSWORD"
                  secret_name = "secret1" # The name of the secret in the secrets list 
                },
                {
                  name        = "SECRET_PASSWORD_2"
                  secret_name = "secret2" # The name of the secret in the secrets list 
                }
              ]
            }
          ] # Container app - Template >> Containers configuration ends here.

          volume = null
          # {
          #   name         = "data-volume"
          #   storage_name = "mystorage"
          #   storage_type = "AzureFile"
          # }
          # Container app - Template configuration ends here.
        }
      }

    }
  }
}