# Releases

## v1.0.0 - 19/12/2024

* Initial release

## v1.0.1 - 23/12/2024

* Dependencies updated - Provider versions updated

## v1.1.0 - 05/02/2025

* Allow empty varaibles for different backup configurations

## v1.2.0 - 13/03/2025

* Allow the creation of a blob container to store backup details if required

## v2.0.0 - 27/03/2025

* Removed data sources to avoid unintended recreation of the backup vault.
* Renamed variable `var.snapshot_resource_group_name` to `var.snapshot_resource_group_id`.
* Added mandatory parameter `kubernetes_cluster_id` to the `var.kubernetes_cluster_backup_config` variable.
* Corrected the behavior of `cross_region_restore_enabled` when redundancy is not set to `GeoRedundant`.

