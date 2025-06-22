# New Service Onboarding

When a new service is required or requested to be onboarded to the platform, the following steps should be followed to ensure that the service is onboarded in a consistent and repeatable manner:

- Create a new git repository for the service using the following naming convention: `<Provider>_<service_name>` (E.g. `azurerm_storage_account`).
- Create the git repository from the following template: [Axso-Terraform-Modules/Service-Template](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_git/new_module_template)
- Create a `dev` branch in the repository and push the initial code to the `dev` branch
- Also set the `dev` branch as the compare branch in the repository settings

Update each of the pipeline variable files **new** repository:

Change the following variables in the `testing-feature/dev/main-vars.yml` file:

```yml
  - name: repo
    value: 'AZURE_DEVOPS_REPO_NAME'
```

to (example for Storage):

```yml
  - name: repo
    value: 'AZURERM_STORAGE_ACCOUNT'
```
