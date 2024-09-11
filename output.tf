output "management_group_id" {
  value = azurerm_management_group.DEV-MG.id
}

output "subscription_id" {
  value = data.azurerm_subscription.current.id
}