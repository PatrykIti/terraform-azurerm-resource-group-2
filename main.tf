resource azurerm_resource_group "resource_group"{
    for_each    = {for resource_group in var.resource_group : resource_group.name => resource_group}

    name        = each.value.name
    location    = each.value.location
    managed_by  = each.value.managed_by

    tags        = var.tags
}