data "azurerm_subscription" "current" {}

resource "azurerm_management_group" "DEV-MG" {
  display_name = "DEV-MG"
  subscription_ids = [data.azurerm_subscription.current.subscription_id,
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
  management_group_id  = azurerm_management_group.DEV-MG.id

  description  = "Assigning built-in policy ${element(var.policy_display_names, count.index)} to a management group."
  display_name = element(var.policy_display_names, count.index)
}

data "azurerm_policy_definition" "Defender" {
  display_name = "Enable Microsoft Defender for Cloud on your subscription"
}

resource "azurerm_management_group_policy_assignment" "Defender" {
  name                 = "Defender-for-cloud"
  policy_definition_id = data.azurerm_policy_definition.Defender.id
  management_group_id  = azurerm_management_group.DEV-MG.id
  location             = var.location
  identity {
    type = "SystemAssigned"
  }
}

data "azurerm_policy_definition" "LAW-Aotomation" {
  display_name = "Configure Log Analytics workspace and automation account to centralize logs and monitoring"
}

resource "azurerm_management_group_policy_assignment" "LAW-Automation" {
  name                 = "LAW-Automation"
  policy_definition_id = data.azurerm_policy_definition.LAW-Aotomation.id
  management_group_id  = azurerm_management_group.DEV-MG.id
  location             = var.location
  identity {
    type = "SystemAssigned"
  }
  parameters = jsonencode({
    workspaceRegion = {
      value = "Central India"
    }
    automationRegion = {
      value = "Central India"
    }
  })
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
      "value" = ["Central India", "East US"]
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
      "value" = ["Standard_D4s_v5", "Standard_D4as_v5", "Standard_F2"]
    }
  })
}

data "azurerm_policy_set_definition" "AMA" {
  display_name = "Enable Azure Monitor for VMs with Azure Monitoring Agent(AMA)"
}

resource "azurerm_management_group_policy_assignment" "AMA" {
  name                 = "MonitorForVMs with (AMA)"
  policy_definition_id = data.azurerm_policy_set_definition.AMA.id
  management_group_id  = azurerm_management_group.DEV-MG.id

  location = var.location
  identity {
    type = "SystemAssigned"
  }
  parameters = jsonencode({
    bringYourOwnUserAssignedManagedIdentity = {
      value = false
    }
    dcrResourceId = {
      value = "false" #"/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Insights/dataCollectionRules/<dcr-name>"
    }
  })
}