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