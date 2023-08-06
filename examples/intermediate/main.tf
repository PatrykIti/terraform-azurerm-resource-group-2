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
#Please be awar that in this approach all outputs will be type of list of strings
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
#Please be awar that in this approach all outputs will be type of list of strings
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