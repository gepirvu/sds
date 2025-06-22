# Releases

## v1.0.0 * 31/10/2023

* Initial release

## v2.0.0 * 04/03/2024

### Features and Fixes:

* **GIT Policies Fixes:** Resolved issues related to GIT Policies.
* **AKS Fully Private:** AKS (Azure Kubernetes Service) now operates in fully private mode, enhancing security.
* **Disk Encryption with CMK:** Data disks are now encrypted using Customer Managed Keys (CMK) for improved data security saved in a Keyvault.
* **Host Encryption Enabled:** Encryption is now enabled at the host level for heightened security measures.
* **Local Account Disabled:** Local account usage has been disabled to mitigate potential security risks.
* **Network Plugin Mode Change:** Network plugin mode has been switched to CNI overlay, improving network performance and management.
* **Microsoft Defender Enabled:** Enhanced security by enabling Microsoft Defender to protect against threats and malicious activities.
* **Azure API Version Update:**  Updated the version of the Azure API from v3.75.0 to v3.90.0 to utilize the latest functionalities and enhancements.
* **Azure AD API Version Update:** Updated the version of the Azure AD API from v2.43.0 to v2.47.0 to incorporate the latest security patches and features.
* **Terraform Version Update:** Updated Terraform from version 1.6.0 to 1.7.0 to benefit from bug fixes, performance enhancements, and new features.
* Integration of user node pool in the module

## v2.1.0 * 20/03/2024

### Features:

* **Add support for azure workload identity:** Allow the pod to asume a identity using the feature of workload identity
* **Container Insights:** Added support for the container insights feature
* **Grafana Integration:** Added grafana in case you need to deploy from the same module
* **Prometheus Integration:** Added promtheus rules in case you need to deploy from the same module

## v2.2.0 * 23/04/2024

### Features:

* **Add RBAC for namespaces:** Allow the assignment of writer and reader roles to different namespaces
* Provider versions updated to the latest * Dependency updates

## v2.3.0 * 25/04/2024

### Features:

* Added support for specifying ACR in another subscription.

## v2.4.0 * 29/04/2024

### Features:

* Added the owners of the admin and readers groups as members by default
* Fix error when nodecount changes with autoscale

## v2.5.0 * 09/05/2024

### Features:

* Added the option to include groups as members of the AKS admin and reader groups.
* Added support for using "temporary_name_for_rotation" to prevent disruption in case of changes in the default node pool.

## v2.6.0 * 01/07/2024

### Features:

* Dependencies updated - Provider versions updated
* This introduces logic to either create a new resource group for AKS or use an existing one if specified. This adds flexibility to the deployment process.
* This allows the use of a public fully qualified domain name (FQDN) instead of setting up a private DNS zone.
* A bug related to Azure Container Registry (ACR) has been fixed. This ensures that the setup works correctly  if ACR is not used.
* Change to a User Assigned Identity instead of a System Assigned Identity. This avoids potential issues with role assignments and provides better control over the identity's lifecycle

## v2.7.0 * 05/07/2024

### Features:

* Add Support plan

## v2.8.0 * 16/07/2024

### Features:

*  Allow rbac access from secret provider identity to Keyvault

## v3.0.0 * 07/11/2024

### Features:

* Remove creation of AD groups (var.create_aks_groups, var.owners)
* Remove unused variables (var.aks_role_entity_type, var.aks_role_ref_kind)
* Fix typo in var.environment
* Add support for image cleaner (var.image_cleaner_enabled, var.image_cleaner_interval_hours)
* Add support for ContainerLogV2
* Add support to reuse existing user-managed identity (UMID) for federated identity credential
* Add support for sysctl_config to change kernel values of the nodes
* Update Prometheus and Grafana dependencies
* Update README 2.0

## v3.1.0 * 07/11/2024

* Removed unnecessary variables (var.aad_group_owners, var.mail_enabled, var.security_enabled).
* Updated the default Kubernetes version.
* Added integration with Azure Backup using the new variable (var.enable_azure_backup).
* Updated provider versions to the latest.
* Updated dependencies.
* Fixed the ID of Azure AD groups, changing it to object_id.

