data "azurerm_subscription" "current" {
}

resource "azurerm_management_group" "DEV-MG" {
  display_name = var.management_group_display_name

  subscription_ids = [
    data.azurerm_subscription.current.subscription_id,
  ]
}

data "azurerm_policy_definition" "policies" {
  count        = length(var.policy_display_names)
  display_name = element(var.policy_display_names, count.index)
}

resource "azurerm_management_group_policy_assignment" "policy_assignments" {
  name                 = "policy-assignment-${count.index}"
  count                = length(var.policy_display_names)
  policy_definition_id = element(data.azurerm_policy_definition.policies.*.id, count.index)
  description          = "Assigning built-in policy ${element(var.policy_display_names, count.index)} to a management group."
  display_name         = element(var.policy_display_names, count.index)
  management_group_id  = azurerm_management_group.DEV-MG.id
  location             = var.location
  identity {
    type = "SystemAssigned"
  }
}

data "azurerm_policy_definition" "Allowed-Locations" {
  display_name = "Allowed locations"
}
resource "azurerm_management_group_policy_assignment" "Allowed-locations" {
  name                 = "Allowed-locations"
  management_group_id  = azurerm_management_group.DEV-MG.id
  policy_definition_id = data.azurerm_policy_definition.Allowed-Locations.id
  parameters = jsonencode({
    "listOfAllowedLocations" = {
      "value" = ["Central India"]
    }
  })
}

data "azurerm_policy_definition" "Allowed-SKUs" {
  display_name = "Allowed virtual machine size SKUs"
}

resource "azurerm_management_group_policy_assignment" "Allowed-SKUs" {
  name                 = "Allowed-SKUs"
  management_group_id  = azurerm_management_group.DEV-MG.id
  policy_definition_id = data.azurerm_policy_definition.Allowed-SKUs.id
  parameters = jsonencode({
    "listOfAllowedSKUs" = {
      "value" = ["Standard_D4s_v5", "Standard_D4as_v5", ]
    }
  })
}

