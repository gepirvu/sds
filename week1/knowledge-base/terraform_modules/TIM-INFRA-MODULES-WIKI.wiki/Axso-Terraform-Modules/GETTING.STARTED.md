# Getting Started

## New Project On-boarding Prerequisites

To start using the Axso self service terraform modules you will need the following:  

|**Prerequisites** | **Ownership** |
|:-----------------|:--------------|
| 1. An Azure DevOps service connection/App registration to your Azure subscription (Federated) | Cloud Platform Team |
| 2. App Registration read/write RBAC access: **Private DNS Zones** (Private Endpoint integration) | Group IT |
| 3. An Azure subscription with Virtual Network Address Space and Peering Including Route Table with Route to Axso Azure Firewall | Group IT |
| 4. Virtual Machine for Azure DevOps Build Agents / Agent Pool (Windows or Linux) | Aveniq |
| 5. Ensure that the Build agent has the **AzureDevOps Agent** and **Powershell 7** installed (and/or any other additional tooling) | Cloud Platform Team |
| 6. An Azure DevOps project, Environments and Agent Pool (Optional) | Cloud Platform Team |
| 7. Enable **Generic Contribute** access to **Project Collection Build Service (Axpo-AXSO)** on the repository used for Front End Terraform Code | Cloud Platform Team |
| 8. **Terraform_rsa** secure file in project library (SSH integration). Public key is kept in `axso-prod-appl-tim-kv` | Cloud Platform Team |
| 9. App Registration RBAC access level: **Storage Blob Data Contributor** to state file storage account: **axso4prod4appl4tim4sa** (Backend State File) | Cloud Platform Team |
| 10. Ensure **Blob Container** exists that matches the container name passed into the pipeline parameters | Cloud Platform Team |
| 11. App Registration RBAC access level: **Key Vault Secrets User** to SSH KeyVault: **axso-prod-appl-tim-kv** (SSH integration) | Cloud Platform Team |
| 12. Import Axso Usecase Template: **[Standard Axso Usecase Template](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_git/axso_usecase_template)** | Cloud Platform Team |

## Access to the Axso Terraform Self Service Project

Once you have completed the above prerequisites, you will also need access to the **Axso Terraform Self Service** project in order to use the modules and also access useful information in the wiki such as **How-To Guides** and gain access to **Production Ready Modules, Services and Blueprints** and valuable information on how to deploy them:

|**Prerequisites** | **Ownership** |
|:-----------------|:--------------|
| 1. Order a **Visual Studio/MSDN License** | Group IT |
| 2. Be added as a User to the Axso DevOps Organisation with the assigned **Visual Studio License** | Cloud Platform Team |
| 3. Reader Access Permission to the **[TIM INFRA MODULES](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3860/TIM-INFRA-MODULES)** Project | Cloud Platform Team |

---