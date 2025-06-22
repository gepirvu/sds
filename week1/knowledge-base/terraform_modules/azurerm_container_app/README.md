| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|----------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_container_app?repoName=azurerm_container_app&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2534&repoName=azurerm_container_app&branchName=main) | **v1.11.5** | **24/03/2025** |

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Container App Configuration](#container-app-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Container App Configuration

----------------------------

[Learn more about Container Apps in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/container-apps/overview/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------

A Container Apps environment is a secure boundary around one or more container apps and jobs. The Container Apps runtime manages each environment by handling OS upgrades, scale operations, failover procedures, and resource balancing.

This module deploys a Azure Container Environment with the respective Container apps.

These all resources will be deployed when using Container App module.

- azurerm_container_app_environment: Manages a Container App Environment
- azurerm_container_app_environment_certificate: Create the custom certificate for the Environment
- azurerm_container_app_custom_domain: Create the custom domains for the container apps
- azapi_resource_action: Used to create managed identity
- azurerm_container_app_environment_storage: Manages a Container App Environment Storage.
- azurerm_container_app: Manages a Container App.
- azurerm_private_dns_a_record: Create the dns record for the custom domain

:information_source: **Azure Container Apps DNS**

In Azure Container Apps, there are three different use cases for connecting to your app.

- Internal Communication: For internal communication within the environment, add .internal between the app name and the environment suffix. Example:
<https://axso-np-appl-cloud-dev-usera-ca.**internal**.delightfuldesert-81f905ba.westeurope.azurecontainerapps.io>

- External Communication: Use the application URL provided in the overview tab for external services.
Example:
<https://axso-np-appl-cloud-dev-usera-ca.delightfuldesert-81f905ba.westeurope.azurecontainerapps.io>

- External Communication with Custom Domains: If exposing the app to clients, request a custom domain (e.g., project.axpo.cloud) from the infra team. Upload the certificate to your Key Vault and reference it as shown in the examples below.

## Pre-requisites

----------------

- Resource Group
- Private DNS zone for your project in case you want to use custom domains
- Virtual Network
- Dedicated delegated subnet - Microsoft.App/environments (The Subnet must have a /21 or larger address space.)
- Log Analytics Workspace (Optional)
- Certificate stored in the KV in case you want to use custom domains
- Keyvault to mount Environment variable as secrets

## Axso Naming convention example

---------------------------------

The naming convention is derived from the following variables `subscription`, `project_name` , `environment` and `usecase`:

- project_name (First 5 characters will be used for container app environment and container apps)
- container_apps > name (First 5 characters will be used, make sure to use meaningful and unique names)

- **Construct - Container app environment:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-${var.usecase}-cae"`  
- **Construct - Container apps:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-${name}-ca"`

## Container app environment

- **NonProd:** `axso-np-appl-cloud-dev-buildagent-cae`
- **Prod:** `axso-p-appl-cloud-prod-buildagent-cae`

## Container app (32 Characters long)

- **NonProd:** `axso-np-appl-cloud-dev-webap-ca`
- **Prod:** `axso-p-appl-cloud-prod-webap-ca`

# Terraform Files

----------------------------

## module.tf

```hcl
module "axso_container_apps" {
  source   = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_container_app?ref=v1.11.5"
  providers = {
    azurerm.dns      = azurerm.dns
  }
  for_each = { for each in var.container_app_configs : each.usecase => each }

  # General
  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_name      = var.key_vault_name

  # Naming convention
  subscription = var.subscription
  project_name = var.project_name
  environment  = var.environment
  ca_umids     = var.ca_umids

  # Container App Environment
  usecase                      = each.value.usecase
  cae_workload_profiles        = each.value.cae_workload_profiles
  infra_subnet_configs         = each.value.infra_subnet_configs
  log_analytics_workspace_name = each.value.log_analytics_workspace_name
  cae_custom_certificates      = each.value.cae_custom_certificates
  ca_custom_domains            = each.value.ca_custom_domains
  # Container registry - optional
  container_registry_server = var.container_registry_server
  acr_umid_name             = var.acr_umid_name
  acr_umid_resource_group   = var.acr_umid_resource_group

  # Container App Environment - Storage Configurations
  cae_storage_configs = each.value.cae_storage_configs

  # Container Apps
  container_apps = each.value.container_apps
  dns_zone_name  = var.dns_zone_name

  # Container Apps Jobs
  container_apps_jobs = each.value.container_apps_jobs  

}

```

## module.tf.tfvars

```hcl
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

dns_zone_name = "nonprod.cloudinfra.axpo.cloud"
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
          {
            name  = "secret1"
            value = "value2"
          }
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
          revision_suffix = null # Random identifier will be created

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

```

## variables.tf

```hcl
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
  default     = null
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
            path                    = optional(string, "/")
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

      })))      

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
```

<!-- BEGIN_TF_DOCS -->
### main.tf

```hcl
terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.20.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "2.2.0"
    }
  }
}

provider "azuread" {}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}

provider "azurerm" {
  alias           = "dns"
  subscription_id = "36cae50e-ce2a-438f-bd97-216b7f682c77"
  features {}
}


```

----------------------------

# Input Description

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |  

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | ~> 2.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |
| <a name="provider_azurerm.dns"></a> [azurerm.dns](#provider\_azurerm.dns) | ~> 4.0 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |  

## Modules

No modules.  

## Resources

| Name | Type |
|------|------|
| [azapi_resource_action.azurerm_container_app_environment_identities](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource_action) | resource |
| [azurerm_container_app.ca](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app) | resource |
| [azurerm_container_app_custom_domain.container_app_custom_domain](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_custom_domain) | resource |
| [azurerm_container_app_environment.cae](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment) | resource |
| [azurerm_container_app_environment_certificate.container_app_environment_certificate](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment_certificate) | resource |
| [azurerm_container_app_environment_storage.cae_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment_storage) | resource |
| [azurerm_container_app_job.ca_job](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_job) | resource |
| [azurerm_private_dns_a_record.ca_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_a_record.pe_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_role_assignment.ca_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.cae_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [time_sleep.wait_30_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_30_seconds_destroy](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.key_vault_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.key_vault_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_log_analytics_workspace.law](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_storage_account.sa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_subnet.cae_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_user_assigned_identity.acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |
| [azurerm_user_assigned_identity.umids](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_umid_name"></a> [acr\_umid\_name](#input\_acr\_umid\_name) | The name of the user managed identity that has access to the container registry | `string` | `null` | no |
| <a name="input_acr_umid_resource_group"></a> [acr\_umid\_resource\_group](#input\_acr\_umid\_resource\_group) | The name for the resource group where the managed identity is located | `string` | `null` | no |
| <a name="input_ca_custom_domains"></a> [ca\_custom\_domains](#input\_ca\_custom\_domains) | (Optional) The list of Custom domains to assign to each container app. | <pre>map(object({<br/>    ca_name                       = string<br/>    cae_certificate_friendly_name = string<br/>    ca_custom_domain_name         = string<br/>  }))</pre> | `null` | no |
| <a name="input_ca_umids"></a> [ca\_umids](#input\_ca\_umids) | values for the user managed identity | <pre>map(object({<br/>    umid_name    = string<br/>    umid_rg_name = string<br/>  }))</pre> | n/a | yes |
| <a name="input_cae_custom_certificates"></a> [cae\_custom\_certificates](#input\_cae\_custom\_certificates) | (Optional) The list of Custom certificates to use in the container app environment. | <pre>map(object({<br/>    key_vault_name                = string<br/>    keyvault_certificate_name     = string<br/>    cae_certificate_friendly_name = string<br/>  }))</pre> | `null` | no |
| <a name="input_cae_storage_configs"></a> [cae\_storage\_configs](#input\_cae\_storage\_configs) | values for the storage configuration | <pre>map(object({<br/>    storage_config_name     = string<br/>    storage_account_name    = string<br/>    storage_account_rg_name = string<br/>    share_name              = string<br/>    access_mode             = string<br/>  }))</pre> | n/a | yes |
| <a name="input_cae_workload_profiles"></a> [cae\_workload\_profiles](#input\_cae\_workload\_profiles) | values for the workload profile | <pre>map(object({<br/>    name                  = string<br/>    workload_profile_type = string<br/>    maximum_count         = number<br/>    minimum_count         = number<br/>  }))</pre> | n/a | yes |
| <a name="input_container_apps"></a> [container\_apps](#input\_container\_apps) | values for the container app configuration | <pre>map(object({<br/>    name                  = string<br/>    revision_mode         = string<br/>    workload_profile_name = string<br/>    identity_type         = string<br/><br/>    template = object({<br/>      containers = list(object({<br/>        name   = string<br/>        image  = string<br/>        cpu    = number<br/>        memory = string<br/>        args   = list(string)<br/>        volume_mounts = list(object({<br/>          name = string<br/>          path = string<br/>        }))<br/>        env = list(object({<br/>          name        = string<br/>          secret_name = string<br/>          value       = string<br/>        }))<br/><br/>        startup_probe = optional(object({<br/>          failure_count_threshold = optional(number, 3)<br/>          header = optional(object({<br/>            name  = string<br/>            value = number<br/>          }), null)<br/>          host                             = optional(string, null)<br/>          interval_seconds                 = optional(number, 10)<br/>          path                             = optional(string, null)<br/>          port                             = number<br/>          termination_grace_period_seconds = optional(number)<br/>          timeout                          = optional(number, 1)<br/>          transport                        = string<br/>        }), null)<br/><br/>        liveness_probe = optional(object({<br/>          failure_count_threshold = optional(number, 3)<br/>          header = optional(object({<br/>            name  = string<br/>            value = number<br/>          }), null)<br/>          host                             = optional(string, null)<br/>          initial_delay_seconds            = optional(number, 10)<br/>          interval_seconds                 = optional(number, 10)<br/>          path                             = optional(string, null)<br/>          port                             = number<br/>          termination_grace_period_seconds = optional(number)<br/>          timeout                          = optional(number, 1)<br/>          transport                        = string<br/>        }), null)<br/><br/>        readiness_probe = optional(object({<br/>          failure_count_threshold = optional(number, 3)<br/>          header = optional(object({<br/>            name  = string<br/>            value = number<br/>          }), null)<br/>          host                    = optional(string, null)<br/>          interval_seconds        = optional(number, 10)<br/>          path                    = optional(string, null)<br/>          port                    = number<br/>          success_count_threshold = optional(number, 3)<br/>          timeout                 = optional(number, 1)<br/>          transport               = string<br/>        }), null)<br/>      }))<br/>      min_replicas    = number<br/>      max_replicas    = number<br/>      revision_suffix = optional(string, null)<br/><br/>      azure_queue_scale_rules = optional(list(object({<br/>        name         = string<br/>        queue_name   = string<br/>        queue_length = number<br/>        authentication = object({<br/>          trigger_parameter = string<br/>          secret_name       = string<br/>        })<br/>      })))<br/><br/>      tcp_scale_rules = optional(list(object({<br/>        name                = string<br/>        concurrent_requests = string<br/>        authentication = optional(object({<br/>          trigger_parameter = string<br/>          secret_name       = string<br/>        }))<br/>      })), null)<br/><br/>      http_scale_rules = optional(list(object({<br/>        name                = string<br/>        concurrent_requests = string<br/>        authentication = optional(object({<br/>          trigger_parameter = string<br/>          secret_name       = string<br/>        }))<br/>      })), null)<br/><br/>      volume = object({<br/>        name         = string<br/>        storage_name = string<br/>        storage_type = string<br/>      })<br/>    })<br/><br/>    secrets = optional(list(object({<br/>      name                = string<br/>      identity_type       = optional(string, null)<br/>      umid_name           = optional(string, null)<br/>      key_vault_secret_id = optional(string, null)<br/>      value               = optional(string, null)<br/><br/>    })), [])<br/><br/>    ingress = object({<br/>      allow_insecure_connections = bool<br/>      external_enabled           = bool<br/>      target_port                = number<br/>      exposed_port               = optional(number, null)<br/>      transport                  = string<br/><br/>      ip_security_restriction = list(object({<br/>        name             = string<br/>        ip_address_range = string<br/>        action           = string<br/>      }))<br/><br/>      traffic_weight = optional(list(object({<br/>        label           = optional(string)<br/>        latest_revision = optional(bool)<br/>        revision_suffix = optional(string)<br/>        percentage      = number<br/>      })))<br/><br/>    })<br/><br/>  }))</pre> | n/a | yes |
| <a name="input_container_apps_jobs"></a> [container\_apps\_jobs](#input\_container\_apps\_jobs) | values for the container app jobs configuration | <pre>map(object({<br/>    name                       = string<br/>    replica_timeout_in_seconds = number<br/>    replica_retry_limit        = number<br/>    workload_profile_name      = string<br/>    identity_type              = string<br/>    manual_trigger_config = optional(object({<br/>      parallelism              = number<br/>      replica_completion_count = number<br/>    }), null)<br/>    schedule_trigger_config = optional(object({<br/>      cron_expression          = string<br/>      parallelism              = number<br/>      replica_completion_count = number<br/>    }), null)<br/>    event_trigger_config = optional(object({<br/>      parallelism              = number<br/>      replica_completion_count = number<br/>      scale = object({<br/>        max_executions              = number<br/>        min_executions              = number<br/>        polling_interval_in_seconds = number<br/>        rules = object({<br/>          name             = string<br/>          custom_rule_type = string<br/>          metadata         = map(string)<br/>          authentication = optional(list(object({<br/>            secret_name       = string<br/>            trigger_parameter = string<br/>          })), null)<br/>        })<br/>      })<br/>    }), null)<br/><br/>    template = object({<br/>      containers = list(object({<br/>        name   = string<br/>        image  = string<br/>        cpu    = number<br/>        memory = string<br/>        args   = list(string)<br/>        volume_mounts = list(object({<br/>          name = string<br/>          path = string<br/>        }))<br/>        env = list(object({<br/>          name        = string<br/>          secret_name = string<br/>          value       = string<br/>        }))<br/><br/>        startup_probe = optional(object({<br/>          failure_count_threshold = optional(number, 3)<br/>          header = optional(object({<br/>            name  = string<br/>            value = number<br/>          }), null)<br/>          host                             = optional(string, null)<br/>          interval_seconds                 = optional(number, 10)<br/>          path                             = optional(string, null)<br/>          port                             = number<br/>          termination_grace_period_seconds = optional(number)<br/>          timeout                          = optional(number, 1)<br/>          transport                        = string<br/>        }), null)<br/><br/>        liveness_probe = optional(object({<br/>          failure_count_threshold = optional(number, 3)<br/>          header = optional(object({<br/>            name  = string<br/>            value = number<br/>          }), null)<br/>          host                             = optional(string, null)<br/>          initial_delay_seconds            = optional(number, 10)<br/>          interval_seconds                 = optional(number, 10)<br/>          path                             = optional(string, null)<br/>          port                             = number<br/>          termination_grace_period_seconds = optional(number)<br/>          timeout                          = optional(number, 1)<br/>          transport                        = string<br/>        }), null)<br/><br/>        readiness_probe = optional(object({<br/>          failure_count_threshold = optional(number, 3)<br/>          header = optional(object({<br/>            name  = string<br/>            value = number<br/>          }), null)<br/>          host                    = optional(string, null)<br/>          interval_seconds        = optional(number, 10)<br/>          path                    = optional(string, null)<br/>          port                    = number<br/>          success_count_threshold = optional(number, 3)<br/>          timeout                 = optional(number, 1)<br/>          transport               = string<br/>        }), null)<br/>      }))<br/><br/>      volume = object({<br/>        name         = string<br/>        storage_name = string<br/>        storage_type = string<br/>      })<br/>    })<br/><br/>    secrets = optional(list(object({<br/>      name                = string<br/>      identity_type       = optional(string, null)<br/>      umid_name           = optional(string, null)<br/>      key_vault_secret_id = optional(string, null)<br/>      value               = optional(string, null)<br/><br/>    })), [])<br/><br/>  }))</pre> | `{}` | no |
| <a name="input_container_registry_server"></a> [container\_registry\_server](#input\_container\_registry\_server) | The name of the container registry server to connect to | `string` | `null` | no |
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | The domain name for the custom domain dns zone. | `string` | `"cloudinfra.axpo.cloud"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"dev"` | no |
| <a name="input_infra_subnet_configs"></a> [infra\_subnet\_configs](#input\_infra\_subnet\_configs) | values for the subnet configuration | <pre>object({<br/>    infra_subnet_name    = string<br/>    infra_vnet_name      = string<br/>    infra_subnet_rg_name = string<br/>  })</pre> | n/a | yes |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | The name of the key vault to use for the secrets | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) Specifies the supported Azure location where the Container App Environment is to exist. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | (Optional) The ID for the Log Analytics Workspace to link this Container Apps Managed Environment to. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS | `string` | `"prj"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which the Container App Environment is to be created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' for prod or 'np' for nonprod | `string` | `"np"` | no |
| <a name="input_usecase"></a> [usecase](#input\_usecase) | The usecase of the container app environment. e.g. 'app', 'db', 'api' | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_app_custom_domains"></a> [container\_app\_custom\_domains](#output\_container\_app\_custom\_domains) | n/a |
| <a name="output_container_app_environment_static_ip_address"></a> [container\_app\_environment\_static\_ip\_address](#output\_container\_app\_environment\_static\_ip\_address) | n/a |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Container App Environment |
| <a name="output_name"></a> [name](#output\_name) | The name of the Container App Environment |
<!-- END_TF_DOCS -->
