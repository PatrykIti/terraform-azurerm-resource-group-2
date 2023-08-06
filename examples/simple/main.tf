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