# Releases

## v1.0.0 - 13/10/2023

* Initial release

## v1.1.0 - 27/11/2023

* README File fixed
* Subnet added to locals
* Infrastructure encryption enabled by default
* Public network access disabled by default
* Shared access key disabled by default

## v1.2.0 - 06/12/2023

* parametrise public network access allowed
* Changed to infrastructure team SPI and subscription (for testing)
* Updated documentation

## v1.3.0 - 06/02/2024

* Major refactor to the module to combine storage containers and private endpoints into main module
* Add automatic creation of private endpoint for storage account as part of deployment

## v1.3.1 - 06/02/2024

* Bump azurerm provider version 3.75.0 -> 3.90.0
* Bump terraform version 1.6.0 -> 1.7.0

## v1.4.0 - 19/03/2024

* Removed tagging from code

## v1.4.1 - 04/04/2024

* Bump azurerm provider version 3.90.0 -> 3.97.1
* Added main.tf to README.md

## v1.4.2 - 23/04/2024

* Dependencies updated - Provider versions updated

## v1.4.3 - 25/04/2024

* Dependencies updated - Provider versions updated

## v1.4.4 - 24/05/2024

* Dependencies updated - Provider versions updated

## v1.4.5 - 31/05/2024

* Dependencies updated - Provider versions updated

## v1.4.6 - 24/06/2024

* Dependencies updated - Provider versions updated

## v1.5.0 - 25/06/2024

* Added support for nfsv3
* Fix network rules
* Fix bug in naming length

## v1.5.1 - 05/08/2024

* Dependencies updated - Provider versions updated

## v2.0.0 - 06/09/2024

* AzureRM Provider v4 compatibility fixes

## v2.0.1 - 24/09/2024

* Dependencies updated - Provider versions updated

## v2.0.2 - 28/10/2024

* Dependencies updated - Provider versions updated

## v3.0.0 - 29/10/2024

* Added support for multiple PE
* Added variable validation
* Changed variable var.storage_type to var.is_hns_enabled
* Fixed dependency issues

## v4.0.0 - 15/11/2024

* Removed random string generation for storage account name and replaced with custom numbering via var.storage_account_number

## v4.0.1 - 24/11/2024

* Dependencies updated - Provider versions updated

## v5.0.0 - 28/11/2024

* Added support for CMK encryption

## v5.0.1 - 24/12/2024

* Dependencies updated - Provider versions updated

## v5.0.2 - 24/01/2025

* Dependencies updated - Provider versions updated

## v5.0.3 - 24/02/2025

* Dependencies updated - Provider versions updated

## v5.0.4 - 24/03/2025

* Dependencies updated - Provider versions updated
