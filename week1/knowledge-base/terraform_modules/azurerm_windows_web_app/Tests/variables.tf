variable "location" {
  type        = string
  default     = "westeurope"
  description = "Specifies azure region/location where resources will be created."
}

variable "subscription" {
  type        = string
  description = "The short name of the subscription type e.g.  'p' or 'np'"
}

variable "environment" {
  type        = string
  description = "The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod'"
  default     = "dev"
}

variable "project_name" {
  type        = string
  description = "The short name of the project e.g. 'mds'"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the existing resource group to create the Resources"
}

variable "service_plan_sku_name" {
  type        = string
  description = "The SKU for the plan. Possible values include B1, I3, P1v2"
}

variable "service_plan_usage" {
  type        = string
  description = "Short description to identify or diferentiate your App services plans"
}

variable "service_plan_os_type" {
  type        = string
  default     = "Windows"
  description = "Type of the for the App Service Plan i.e Windows, Linux"
}

variable "zone_balancing_enabled" {
  type        = bool
  description = "Enable or disable the web zone balancing"
  default     = false
}

variable "umid_names" {
  description = "(Optional)List of User Assigned Managed Identity Names"
  type        = list(string)
  default     = []
}

variable "service_plan_usage_windows_container" {
  type        = string
  description = "Short description to identify or diferentiate your App services plans for Windows Containers"
}

variable "service_plan_os_type_windows_container" {
  type        = string
  default     = "Windows"
  description = "Type of the for the App Service Plan for Windows Containers"
}

variable "umid_names_windows_container" {
  description = "(Optional)List of User Assigned Managed Identity Names"
  type        = list(string)
  default     = []
}

variable "docker_registry_url" {
  type        = string
  default     = ""
  description = "(Optional)URL of the docker registry"
}

variable "acr_name" {
  type        = string
  default     = null
  description = "(Optional)Azure COntainer Registry name"
}

variable "app_services" {
  description = "Add details for your App services"
  type = list(object({
    appservice_short_description         = string,
    app_settings_name                    = string,
    use_acr                              = bool, # If true give var.acr_name
    acr_use_managed_identity_credentials = bool,
    identity_type                        = string,
    client_affinity_enabled              = bool,
    worker_count                         = number,
    always_on                            = bool,
    websockets_enabled                   = bool,
    health_check_path                    = string,
    health_check_eviction_time_in_min    = number,
    vnet_route_all_enabled               = bool,
    subnetname                           = string,
    application_stack                    = string,
    docker_image_name                    = string,
    node_version                         = string,
    dotnet_version                       = string,
    python_app                           = bool
  }))
}

variable "app_settings" {
  type        = map(any)
  description = "values for the app settings"
}

variable "virtual_network_name" {
  type    = string
  default = "Name of the virtual Network"
}

variable "vint_subnet_name" {
  type    = string
  default = "Subnet name for Integrating in Webapps"
}

variable "pe_subnet_name" {
  type    = string
  default = "Subnet name for the private endpoint"
}

variable "network_resource_group_name" {
  type        = string
  description = "The name of the resource group where the virtual network is created"

}

variable "default_documents" {
  type        = list(string)
  default     = ["Default.htm", "Default.html", "Default.asp", "index.htm", "index.html", "iisstart.htm", "default.aspx", "index.php", "hostingstart.html"]
  description = "Default documents to be added"
}

variable "deployment_slots" {
  description = "Add details for your App services Slots"
  type = list(object({
    deployment_slot_name                 = string,
    appservice_short_description         = string,
    client_affinity_enabled              = bool,
    worker_count                         = number,
    app_settings_name                    = string,
    use_acr                              = bool, # If true give var.acr_name
    acr_use_managed_identity_credentials = bool
    identity_type                        = string,
    always_on                            = bool,
    websockets_enabled                   = bool,
    health_check_path                    = string,
    health_check_eviction_time_in_min    = number,
    vnet_route_all_enabled               = bool,
    subnetname                           = string,
    application_stack                    = string,
    docker_image_name                    = string,
    node_version                         = string,
    dotnet_version                       = string,
    python_app                           = bool
  }))
  default = []
}

variable "private_dns_zone_name" {
  type        = string
  description = "(Optional) The domain name for the custom private domain dns zone."
  default     = "nonprod.cloudinfra.axpo.cloud"
}

variable "public_dns_zone_name" {
  type        = string
  description = "(Optional) The domain name for the custom public domain dns zone."
  default     = "cloudinfra.axpo.cloud"
}

variable "app_services2" {
  description = "Add details for your App services"
  type = list(object({
    appservice_short_description         = string,
    app_settings_name                    = string,
    use_acr                              = bool, # If true give var.acr_name
    acr_use_managed_identity_credentials = bool,
    identity_type                        = string,
    client_affinity_enabled              = bool,
    worker_count                         = number,
    always_on                            = bool,
    websockets_enabled                   = bool,
    health_check_path                    = string,
    health_check_eviction_time_in_min    = number,
    vnet_route_all_enabled               = bool,
    subnetname                           = string,
    application_stack                    = string,
    docker_image_name                    = string,
    node_version                         = string,
    dotnet_version                       = string,
    python_app                           = bool
  }))
}

variable "webapp_custom_certificates_key_vault" {
  type        = string
  description = "(Optional) The name of the Key Vault where the custom certificates are stored."
  default     = null
}

variable "webapp_custom_certificates" {
  type = map(object({
    keyvault_certificate_name        = string
    webapp_certificate_friendly_name = string
  }))
  description = "(Optional) The list of Custom certificates to use in the web apps stored in the webapp_custom_certificates_key_vault."
  default     = {}
}

variable "webapp_custom_domains" {
  type = map(object({
    webapp_description               = string
    webapp_certificate_friendly_name = string
    webapp_custom_domain_name        = string
  }))
  description = "(Optional) The list of Custom domains to use in the web apps."
  default     = {}
}