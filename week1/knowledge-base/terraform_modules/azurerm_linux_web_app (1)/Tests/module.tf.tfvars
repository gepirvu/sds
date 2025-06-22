location                    = "West Europe"
environment                 = "dev"
project_name                = "ssp"
subscription                = "np"
resource_group_name         = "axso-np-appl-ssp-test-rg"
network_resource_group_name = "rg-cloudinfra-nonprod-axso-ymiw"
virtual_network_name        = "vnet-cloudinfra-nonprod-axso-e3og"
vint_subnet_name            = "app-linux-subnet"
pe_subnet_name              = "pe"
docker_registry_url         = "https://axso4np4ssp4shared4acr01.azurecr.io"
acr_name                    = "axso4np4ssp4shared4acr01"

service_plan_sku_name = "P1v3"
service_plan_usage    = "billing"
service_plan_os_type  = "Linux"

umid_names = [
  "axso-np-appl-ssp-test-umid"
]

app_settings = {
  developers_settings = {
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
    WEBSITE_NODE_DEFAULT_VERSION               = "16.16.0"
  },

  testers_settings = {
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"

  },

  quality_settings = {
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"

  }
}

app_services = [
  {
    appservice_short_description         = "builders",
    app_settings_name                    = "builders_settings",
    use_acr                              = false,
    acr_use_managed_identity_credentials = false,
    identity_type                        = null
    ftps_state                           = "FtpsOnly",
    client_affinity_enabled              = true,
    worker_count                         = 1,
    always_on                            = true,
    websockets_enabled                   = true,
    health_check_path                    = "/health",
    health_check_eviction_time_in_min    = 2,
    vnet_route_all_enabled               = true,
    vnet_integ_required                  = true,
    subnetname                           = "app-linux-subnet",
    application_stack                    = "python",
    docker_image_name                    = "",
    dotnet_version                       = "",
    python_version                       = "3.11"

  },

  {
    appservice_short_description         = "producers",
    app_settings_name                    = "producers_settings",
    use_acr                              = false,
    acr_use_managed_identity_credentials = false,
    identity_type                        = "UserAssigned",
    ftps_state                           = "FtpsOnly",
    client_affinity_enabled              = true,
    worker_count                         = 1,
    always_on                            = true,
    websockets_enabled                   = true,
    health_check_path                    = "/health",
    health_check_eviction_time_in_min    = 2,
    vnet_route_all_enabled               = true,
    vnet_integ_required                  = true,
    subnetname                           = "app-linux-subnet",
    application_stack                    = "dotnet",
    docker_image_name                    = "",
    dotnet_version                       = "6.0",
    python_version                       = ""

  },

  {
    appservice_short_description         = "checkers",
    app_settings_name                    = "checkers_settings",
    use_acr                              = true,
    acr_use_managed_identity_credentials = true,
    identity_type                        = "SystemAssigned",
    ftps_state                           = "FtpsOnly",
    client_affinity_enabled              = true,
    worker_count                         = 1,
    always_on                            = true,
    websockets_enabled                   = true,
    health_check_path                    = "/health",
    health_check_eviction_time_in_min    = 2,
    vnet_route_all_enabled               = true,
    vnet_integ_required                  = true,
    subnetname                           = "app-linux-subnet",
    application_stack                    = "docker",
    docker_image_name                    = "samples/helloworld",
    dotnet_version                       = "",
    python_version                       = ""

  }
]

deployment_slots = [
  {
    deployment_slot_name                 = "stage",
    appservice_short_description         = "builders",
    client_affinity_enabled              = true,
    worker_count                         = 1,
    app_settings_name                    = "builders_settings",
    use_acr                              = false,
    acr_use_managed_identity_credentials = false,
    identity_type                        = "SystemAssigned",
    ftps_state                           = "FtpsOnly"
    always_on                            = true,
    websockets_enabled                   = true,
    health_check_path                    = "/health",
    health_check_eviction_time_in_min    = 2,
    vnet_route_all_enabled               = true,
    subnetname                           = "app-linux-subnet",
    application_stack                    = "python",
    docker_image_name                    = "",
    dotnet_version                       = "",
    python_version                       = "3.11"
  },
  {
    deployment_slot_name                 = "stage2",
    appservice_short_description         = "builders",
    client_affinity_enabled              = true,
    worker_count                         = 1,
    app_settings_name                    = "builders_settings",
    use_acr                              = false,
    acr_use_managed_identity_credentials = false,
    identity_type                        = null
    ftps_state                           = "FtpsOnly"
    always_on                            = true,
    websockets_enabled                   = true,
    health_check_path                    = "/health",
    health_check_eviction_time_in_min    = 2,
    vnet_route_all_enabled               = true,
    subnetname                           = "app-linux-subnet",
    application_stack                    = "dotnet",
    docker_image_name                    = "",
    dotnet_version                       = "6.0",
    python_version                       = ""
  }
]

private_dns_zone_name = "nonprod.cloudinfra.axpo.cloud"
public_dns_zone_name  = "cloudinfra.axpo.cloud"

webapp_custom_certificates_key_vault = "kv-ssp-0-nonprod-axso"

webapp_custom_certificates = {
  "webapp-c-1" = {
    keyvault_certificate_name        = "nonprod-cloudinfra-axpo-cloud" # The name of your certificate store in the KV
    webapp_certificate_friendly_name = "nonprod-cloudinfra-axpo-cloud"
  },
  "webapp-c-2" = {
    keyvault_certificate_name        = "front-nonprod-cloudinfra-axpo-cloud" # The name of your certificate store in the KV
    webapp_certificate_friendly_name = "front-nonprod-cloudinfra-axpo-cloud"
  }
}

webapp_custom_domains = {
  "builders" = {
    webapp_description               = "builders" #The description of the webapp, same as in app_services
    webapp_certificate_friendly_name = "nonprod-cloudinfra-axpo-cloud"
    webapp_custom_domain_name        = "builders" # The domain will be added, so this is developers.nonprod.cloudinfra.axpo.cloud, if you want only nonprod.cloudinfra.axpo.cloud, use "@""
  },
  "producers" = {
    webapp_description               = "producers" #The description of the webapp, same as in app_services
    webapp_certificate_friendly_name = "nonprod-cloudinfra-axpo-cloud"
    webapp_custom_domain_name        = "producers" # The domain will be added, so this is testers.nonprod.cloudinfra.axpo.cloud, if you want only nonprod.cloudinfra.axpo.cloud, use "@""
  },                                               #, #This is an example just for reference
  "checkers" = {
    webapp_description               = "checkers" #The description of the webapp, same as in app_services
    webapp_certificate_friendly_name = "front-nonprod-cloudinfra-axpo-cloud"
    webapp_custom_domain_name        = "front" # The domain will be added, so this is performance.nonprod.cloudinfra.axpo.cloud, if you want only nonprod.cloudinfra.axpo.cloud, use "@""
  }
}

