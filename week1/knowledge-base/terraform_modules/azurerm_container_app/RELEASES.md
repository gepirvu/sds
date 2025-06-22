# Releases

## v1.0.0 - 12/12/2023

* Initial release

## v1.1.0 - 26/01/2024

* Added ability to select all possible combinations for Identity type
* Added new block 'volume_mounts' for container templates
* `hashicorp/azurerm` version **3.75.0** -> **3.87.0**

## v1.2.0 - 09/02/2024

* All resources related to Container App have been merged in a single module
* worker_profile_name parameter has been added in the Container Apps resource
* Terraform version has been upgraded to **3.90.0**

## v1.2.1 - 23/02/2024

* This adjustment addresses a bug within the ContainerApps - UMIDs configuration. The 'ca_umids' variable has been separated from the 'container_apps' variable to streamline the data source block and reduce complexity.

## v1.2.2 - 06/03/2024

Terraform version bumped from **3.90.0** -> **3.94.0**

## v1.3.0 - 12/03/2024

* Fix for workload_profile_name in the Container_App resource.
* Updated locals.tf to fix naming convention for both Container app environment and container app.

## v1.4.0 - 11/04/2024

* Fixed naming convention for ContainerApps.
* Introduced new feature - azure_queue_scale_rules
* Terraform version bumped from **3.97.1** -> **3.98.0**

## v1.5.0 - 12/04/2024

* Fixed issues with scaling rules
* Simplified the module by separating the container registry configuration
* Simplified the module by using a data source for the container registry UMID configuration

## v1.6.0 - 24/04/2024

* Fixed issues with scaling rules

## v1.6.1 - 23/04/2024

* Dependencies updated - Provider versions updated

## v1.6.2 - 25/04/2024

* Dependencies updated - Provider versions updated

## v1.6.3 - 24/05/2024

* Dependencies updated - Provider versions updated

## v1.6.4 - 31/05/2024

* Dependencies updated - Provider versions updated

## v1.6.5 - 24/06/2024

* Dependencies updated - Provider versions updated

## v1.6.6 - 29/07/2024

* Dependencies updated - Provider versions updated

## v1.7.0 - 05/08/2024

* Added support for system managed identity for CAE
* Added support for custom certificates for CAE
* Added support for custom domains for CA
* Added support for A record creation in private dns zone for CA custom domains

## v1.8.0 - 05/09/2024

* Dependencies updated - Provider versions updated
* Added support for startup, readiness and liveness probe
* Added support to use environment variables from secrets stored in a keyvault

## v1.9.0 - 16/09/2024

* Dependencies updated - Provider versions updated
* Added support for http and tcp scale rules
* Added support to create container app jobs
* Added support to create TCP ingress

## v1.10.0 - 16/09/2024

* Fixed issues with Container App resource group

## v1.10.1 - 24/09/2024

* Dependencies updated - Provider versions updated

## v1.10.1 - 24/09/2024

* Dependencies updated - Provider versions updated

## v1.11.0 - 24/10/2024

* Added default DNS entries for the default container apps domains.

## v1.11.1 - 25/11/2024

* Dependencies updated - Provider versions updated

## v1.11.2 - 09/01/2025

* Dependencies updated - Provider versions updated

## v1.11.3 - 24/01/2025

* Dependencies updated - Provider versions updated

## v1.11.4 - 24/02/2025

* Dependencies updated - Provider versions updated

## v1.11.5 - 24/03/2025

* Dependencies updated - Provider versions updated
