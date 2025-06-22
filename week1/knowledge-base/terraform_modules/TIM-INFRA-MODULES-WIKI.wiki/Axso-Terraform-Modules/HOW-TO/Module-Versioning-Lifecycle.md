# Module Versioning Lifecycle

## Introduction

Modules are versioned using [Semantic Versioning](https://semver.org/). The following is a summary of the versioning lifecycle:

- **Major:** Breaking changes to the module that will require consumers to update their code to use the new version of the module.  
- **Minor:** New Features added to the module that will require consumers to update their code with **new parameters (optionally)** only for **new features** developed.  
- **Patch:** Provider version upgrades ensuring the latest API of the provider is used in the module. Non-breaking changes that will not require consumers to update their code.  

|**Major** |**Minor** |**Patch** |**Description**|
|:---------|:---------|:---------|:--------------|
|**v1**    |**.0**    |**.0**    | Initial release of the module. |
|**v1**    |**.1**    |**.0**    | New features added to the module. E.g. a new parameter is added to the module to allow a new feature requested |
|**v1**    |**.1**    |**.1**    | Provider version upgrade. E.g. The version of the Azure API has changed from v3.79.0 --> v3.80.0 |
|**v1**    |**.1**    |**.2**    | Provider version upgrade. E.g. The version of the Azure API has changed from v3.80.0 --> v3.81.0 |
|**v2**    |**.0**    |**.0**    | Breaking changes to the module. E.g. Azure/Provider has fundamentally changed its API that causes breaking changes |
|**v2**    |**.0**    |**.1**    | Provider version upgrade. E.g. The version of the Azure API has changed from v3.81.0 --> v3.82.0 |
|**v2**    |**.0**    |**.2**    | Provider version upgrade. E.g. The version of the Azure API has changed from v3.82.0 --> v3.83.0 |
|**v2**    |**.1**    |**.0**    | New features added to the module. E.g. a new parameter is added to the module to allow a new feature requested |

---

## How to upgrade Module Versioning and Lifecycle

The following is an example of how to version a module:

```hcl
module "example" {
  source                          = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_private_endpoint?ref=v1.0.0"

  # Module Parameters
  argument1                       = "value1"
  argument2                       = "value2"
}
```

To upgrade the module to the latest version. We can do this by changing the `ref` parameter to the latest version of the module when **new features** have been added to the module:

```hcl
module "example" {
  source                          = "git::ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_private_endpoint?ref=v1.1.0"

  # Module Parameters
  argument1                        = "value1"
  argument2                        = "value2"
  new_feature_argument1            = "new_value"
  new_feature_argument2            = "new_value"
}
```

Similarly, if the module requires a provider version upgrade, we can do this by changing the `ref` parameter to the latest version of the module when **provider version upgrades** have been added to the module:

```hcl
module "example" {
  source                          = "git::ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_private_endpoint?ref=v1.1.1"

  # Module Parameters
  argument1                        = "value1"
  argument2                        = "value2"
  new_feature_argument1            = "new_value"
  new_feature_argument2            = "new_value"
}
```

For breaking changes to the module, we can do this by changing the `ref` parameter to the latest version of the module when **breaking changes** have been added to the module. This will typically require a major rewrite of the module and will require consumers to update their code to use the new parameters and remove old parameters:

```hcl
module "example" {
  source                          = "git::ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_private_endpoint?ref=v2.0.0"

  # Module Parameters
  new_feature_argument1            = "new_value"
  new_feature_argument2            = "new_value"
}
```
