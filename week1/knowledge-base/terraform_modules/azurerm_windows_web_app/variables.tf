### App Services - General ###
variable "location" {
  type        = string
  description = "The default location where the App service will be created"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where your resources should reside"
}

variable "environment" {
  type        = string
  description = "The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod'"
  default     = "dev"
}

variable "subscription" {
  type        = string
  description = "The short name of the subscription type e.g.  'p' or 'np'"
}

variable "project_name" {
  type        = string
  description = "The short name of the project e.g. 'mds'"
}

variable "service_plan_usage" {
  type        = string
  description = "Short description to identify or diferentiate your App services plans"
}

variable "service_plan_sku_name" {
  type        = string
  description = "The SKU for the plan. Possible values include B1, I3, P1v2"
}

variable "service_plan_os_type" {
  type        = string
  description = "Type of the for the App Service Plan i.e Windows, Linux"
}

variable "zone_balancing_enabled" {
  type        = bool
  description = "Enable or disable the web zone balancing"
  default     = false
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

variable "app_services" {
  description = "Add details for your App services"
  type = list(object({
    appservice_short_description         = string,
    app_settings_name                    = string,
    use_acr                              = bool, # If true give var.acr_name 
    acr_use_managed_identity_credentials = bool
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

### App Services - Site Config ###
variable "default_documents" {
  type        = list(string)
  default     = ["Default.htm", "Default.html", "Default.asp", "index.htm", "index.html", "iisstart.htm", "default.aspx", "index.php", "hostingstart.html", "client/build/index.html"]
  description = "Default documents to be added"
}

variable "umids" {
  description = "(Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Web App."
  type        = list(string)
  default     = []
}

variable "app_settings" {
  type        = map(any)
  description = "values for the app settings"
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

variable "acr_name" {
  description = "(Optional) name of the ACR if ACR is enabled per app"
  default     = null
  type        = string
}

variable "docker_registry_url" {
  description = "(Optional) Name of the Docker Registry URL"
  type        = string
  default     = ""
}

variable "private_dns_zone_name" {
  type        = string
  description = "(Optional) The domain name for the custom private domain dns zone."
  default     = ""
}

variable "public_dns_zone_name" {
  type        = string
  description = "(Optional) The domain name for the custom public domain dns zone."
  default     = ""
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