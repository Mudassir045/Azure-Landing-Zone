resource "azurerm_management_group" "mudassir" {
  display_name = var.management_group_display_name
  subscription_ids = [var.subscription_id,
  ]
}

# Data sources to retrieve the built-in policy definitions
data "azurerm_policy_definition" "policies" {
  count        = length(var.policy_display_names)
  display_name = element(var.policy_display_names, count.index)
}

# Policy assignments for each policy definition
resource "azurerm_management_group_policy_assignment" "policy_assignments" {
  count                = length(var.policy_display_names)
  name                 = "policy-assignment-${count.index}"
  policy_definition_id = element(data.azurerm_policy_definition.policies.*.id, count.index)
  management_group_id  = azurerm_management_group.mudassir.id

  description  = "Assigning built-in policy ${element(var.policy_display_names, count.index)} to a management group."
  display_name = element(var.policy_display_names, count.index)
}