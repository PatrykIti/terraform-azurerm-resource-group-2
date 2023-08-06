output "name" {
  description = "[Output] Resource Group Name"
  value = [for resource_group in keys(azurerm_resource_group.resource_group) : azurerm_resource_group.resource_group[resource_group].name]
}
output "location" {
  description = "[Output] Resource Group Location"
  value = [for resource_group in keys(azurerm_resource_group.resource_group) : azurerm_resource_group.resource_group[resource_group].location]
}
output "managed_by" {
  description = "[Output] Resource Group Managed By"
  value = [for resource_group in keys(azurerm_resource_group.resource_group) : azurerm_resource_group.resource_group[resource_group].managed_by]
}
output "id" {
  description = "[Output] Resource Group ID"
  value = [for resource_group in keys(azurerm_resource_group.resource_group) : azurerm_resource_group.resource_group[resource_group].id]
}