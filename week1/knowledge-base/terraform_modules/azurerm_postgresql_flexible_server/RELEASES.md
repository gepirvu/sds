# Releases

## v1.0.0 - 06/12/2023

* Initial release

## v1.1.0 - 07/12/2023

* Secret expiration enabled for secrets being created and stored for PostgreSQL flexible admin.
* High Availability configuration for PostgreSQL flexible server made optional.

## v1.2.0 - 02/02/2024

* PostgreSQL flexible server and related all resources merged into a single module.
* Azurerm version upgraded from 3.75.0 to 3.90.0.
* Terraform version upgraded from 1.6.0 to 1.7.0.

## v1.2.1 - 23/04/2024

* Dependencies updated - Provider versions updated

## v1.2.2 - 25/04/2024

* Dependencies updated - Provider versions updated

## v1.2.3 - 25/05/2024

* Dependencies updated - Provider versions updated

## v1.2.4 - 04/06/2024

* Dependencies updated - Provider versions updated

## v1.2.5 - 05/06/2024

* Dependencies updated - Provider versions updated

## v1.3.0 - 05/06/2024

* Fix networking bug

## v1.3.1 - 25/06/2024

* Dependencies updated - Provider versions updated

## v1.4.0 - 16/07/2024

* Removed Tags

## v1.4.1 - 25/07/2024

* Dependencies updated - Provider versions updated

## v1.5.0 - 07/08/2024

* Added SKU Variable 
* Readme Formated

## v1.5.1 - 28/08/2024

* Dependencies updated - Provider versions updated

## v1.6.0 - 23/09/2024

* Dependencies updated - Provider versions updated
* Removed group creation 

## v1.6.1 - 25/09/2024

* Dependencies updated - Provider versions updated

## v1.6.2 - 25/10/2024

* Dependencies updated - Provider versions updated

## v1.6.3 - 25/11/2024

* Dependencies updated - Provider versions updated

## v1.7.0 - 27/11/2024

* Added variable var.geo_redundant_backup_enabled

## v1.7.1 - 07/01/2025

* Dependencies updated - Provider versions updated

## v1.7.2 - 27/01/2025

* Dependencies updated - Provider versions updated

## v1.8.0 - 03/02/2025

* Added support to public PSQL with private endpoint. (var.vnet_integration_enable = false)
* Changed variable var.delegated_subnet_name for var.psql_subnet_name
* Added support for password authentication in exceptional use cases (var.password_auth_enabled)
* Removed unnecessary variable (var.postgresql_flexible_server_firewall_rules)

## v1.8.1 - 26/02/2025

* Dependencies updated - Provider versions updated

## v1.8.2 - 25/03/2025

* Dependencies updated - Provider versions updated
