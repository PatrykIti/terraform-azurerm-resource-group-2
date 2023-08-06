<!-- [START BADGES] -->
<!-- Please keep comment here to allow auto update -->
[![license GPL-3.0](https://img.shields.io/github/license/PatrykIti/terraform-azurerm-resource-group-2?style=flat-square)](https://github.com/PatrykIti/terraform-azurerm-resource-group-2/blob/main/LICENSE)
[![Language](https://img.shields.io/badge/language-HCL-purple.svg?style=flat-square)](https://www.hashicorp.org)
[![Ver. v1.0.0](https://img.shields.io/badge/Ver.-v1.0.0-brightgreen.svg?style=flat-square)](https://github.com/PatrykIti/testing-gitactions/releases/tag/v1.0.0)
<!-- [END BADGES] -->
<h1 align="center">Terraform module for managing Azure Resource Groups (2 approach)</h1>

<p>This is the second approach to this module and the module itself is a little more complext then in first approach but entire configuration is on the side of module execution. So your TFVARS will have less variables</p>

<p>All modules were tested on my private Azure subscription before merged here, so if you encountered some problems than please check twice your configuration ☺️ </p>

<p>You can look into another repository for <a href ="https://github.com/PatrykIti/terraform-azurerm-resource-group-1">terraform-azurerm-resource-group-1</a> module with different approach than it is here.</p>

<p>Another respository to look into is about <a href = "https://github.com/PatrykIti/terraform-environment-configurations/tree/main/azurerm-resource-group-2">executing module via Azure Pipelines within environment configuration</a>, together with backend configuration etc.</p>

<p>If you want to keep an eye on current changes made to modules than please look into <a href="https://github.com/users/PatrykIti/projects/1">Project section -> Terraform modules for Azure</a></p>
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.58.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Module Usage
More usage examples available in .\examples\ folder
### Simple Example
```hcl
locals{
    env_prefix      = "dev1eunc3d7d"
    resource_group  = "raw"
    tags = {
      environment               = "dev1"
      environmentType           = "Development"
      latestProvisioning        = "patryk.c@example.com"
      latesteProvisioningDate   = "29-07-2023 19:34:00+00"
      ProjectCode               = "2390-11-100"
    }
}

module "rg" {
    source = "git::https://github.com/PatrykIti/terraform-azurerm-resource-group-2.git?ref=v1.0.0"
    resource_group = [
      {
        name = join("-", [local.env_prefix, local.resource_group])
      }
    ]
    tags = local.tags
}

#Testing outputs from module
#Only for showing how to get them after module execution
#Outputs can be passed between modules of different resources
#Please be aware that in this approach all outputs will be type of list of strings
output "name" {
  value = module.rg.name
}
output "location" {
  value = module.rg.location
}
output "managed_by" {
  value = module.rg.managed_by
}
output "id" {
  value = module.rg.id
}
```
### Intermediate Example
```hcl
locals{
    env                       = "dev1"
    subscriptionInfix         = "c3d7d"
    locationAcronymPrimary    = "eun"
    locationPrimary           = "North Europe"
    locationAcronymSecondary  = "euw"
    locationSecondary         = "West Europe"
    env_prefix_primary        = join("",[local.env,local.locationAcronymPrimary,local.subscriptionInfix])
    env_prefix_secondary      = join("",[local.env,local.locationAcronymSecondary,local.subscriptionInfix])
    resource_group_raw        = "raw"
    resource_group_bi         = "bi"
    resource_group_inf        = "inf"
    tags = {
      environment               = "dev1"
      environmentType           = "Development"
      latestProvisioning        = "patryk.c@example.com"
      latesteProvisioningDate   = "29-07-2023 19:34:00+00"
      ProjectCode               = "2390-11-100"
    }
}

#Primary Location
module "rg_primary" {
    source = "git::https://github.com/PatrykIti/terraform-azurerm-resource-group-2.git?ref=v1.0.0"
    resource_group = [ 
      {
        name      = join("-",[local.env_prefix_primary, local.resource_group_raw])
        location  = local.locationPrimary

      },
      {
        name      = join("-",[local.env_prefix_primary, local.resource_group_bi])
        location  = local.locationPrimary

      },
      {
        name      = join("-",[local.env_prefix_primary, local.resource_group_inf])
        location  = local.locationPrimary

      }
    ]
    tags = local.tags
}

#Secondary Region
module "rg_secondary" {
    source = "git::https://github.com/PatrykIti/terraform-azurerm-resource-group-2.git?ref=v1.0.0"
    resource_group = [ 
      {
        name      = join("-",[local.env_prefix_secondary, local.resource_group_raw])
        location  = local.locationSecondary

      },
      {
        name      = join("-",[local.env_prefix_secondary, local.resource_group_bi])
        location  = local.locationSecondary

      },
      {
        name      = join("-",[local.env_prefix_secondary, local.resource_group_inf])
        location  = local.locationSecondary

      }
    ]
    tags = local.tags
}

#Testing outputs from module for Primary region
#Only for showing how to get them after module execution
#Outputs can be passed between modules of different resources
#Please be aware that in this approach all outputs will be type of list of strings
output "resource_group_primary_name" {
  value = module.rg_primary.name
}
output "resource_group_primary_location" {
  value = module.rg_primary.location
}
output "resource_group_primary_managed_by" {
  value = module.rg_primary.managed_by
}
output "resource_group_primary_id" {
  value = module.rg_primary.id
}

#Testing outputs from module for Secondary region
#Only for showing how to get them after module execution
#Outputs can be passed between modules of different resources
#Please be aware that in this approach all outputs will be type of list of strings
output "resource_group_secondary_name" {
  value = module.rg_secondary.name
}
output "resource_group_secondary_location" {
  value = module.rg_secondary.location
}
output "resource_group_secondary_managed_by" {
  value = module.rg_secondary.managed_by
}
output "resource_group_secondary_id" {
  value = module.rg_secondary.id
}
```
### Advanced Example
```hcl
locals{
    env                       = "dev1"
    subscriptionInfix         = "c3d7d"
    locationAcronymPrimary    = "eun"
    locationPrimary           = "North Europe"
    locationAcronymSecondary  = "euw"
    locationSecondary         = "West Europe"
    env_prefix_primary        = join("",[local.env,local.locationAcronymPrimary,local.subscriptionInfix])
    env_prefix_secondary      = join("",[local.env,local.locationAcronymSecondary,local.subscriptionInfix])

    list_of_resource_groups   = ["raw","snp","da","wda","ecs","ecw","db","bi"]
    tags = {
      environment               = "dev1"
      environmentType           = "Development"
      latestProvisioning        = "patryk.c@example.com"
      latesteProvisioningDate   = "29-07-2023 19:34:00+00"
      ProjectCode               = "2390-11-100"
    }
}

#Primary Location
module "rg_primary" {
    source = "git::git::https://github.com/PatrykIti/terraform-azurerm-resource-group-2.git?ref=v1.0.0"
    for_each = {for resource_group in local.list_of_resource_groups : resource_group => resource_group}
    resource_group = [ 
      {
        name      = join("-",[local.env_prefix_primary, each.value])
        location  = local.locationPrimary

      }
    ]
    tags = local.tags
}

#Secondary Region
module "rg_secondary" {
    source = "git::https://github.com/PatrykIti/terraform-azurerm-resource-group-2.git?ref=v1.0.0"
    for_each = {for resource_group in local.list_of_resource_groups : resource_group => resource_group}
    resource_group = [ 
      {
        name      = join("-",[local.env_prefix_secondary, each.value])
        location  = local.locationSecondary

      }
    ]
    tags = local.tags
}

#Testing outputs from module for Primary region
#Only for showing how to get them after module execution
#Outputs can be passed between modules of different resources
#Please be aware that in this approach all outputs will be type of list of strings
output "resource_groups_primary" {
  value = [for rg in local.list_of_resource_groups : {
      name        = module.rg_primary[rg].name
      location    = module.rg_primary[rg].location
      managed_by  = module.rg_primary[rg].managed_by
      id          = module.rg_primary[rg].id
    }
  ]
}

#Testing outputs from module for Secondary region
#Only for showing how to get them after module execution
#Outputs can be passed between modules of different resources
#Please be aware that in this approach all outputs will be type of list of strings
output "resource_groups_secondary" {
  value = [for rg in local.list_of_resource_groups : {
      name        = module.rg_secondary[rg].name
      location    = module.rg_secondary[rg].location
      managed_by  = module.rg_secondary[rg].managed_by
      id          = module.rg_secondary[rg].id
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | List of object with properties for Resource Group.<br>      name:       Name of the resource group<br>      location:   Location for the resource group<br>      managed\_by: ID of the resource which manage this resource group | <pre>list(object({<br>    name        = string,<br>    location    = optional(string, "North Europe"),<br>    managed_by  = optional(string, null)<br>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags for resource group | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | [Output,List(string)] Resource Group Name |
| <a name="output_location"></a> [location](#output\_location) | [Output,List(string)] Resource Group Location |
| <a name="output_managed_by"></a> [managed\_by](#output\_managed\_by) | [Output,List(string)] Resource Group Managed By |
| <a name="output_id"></a> [id](#output\_id) | [Output,List(string)] Resource Group ID |
<!-- END_TF_DOCS -->