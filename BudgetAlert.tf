resource "azurerm_resource_group" "budget-rg" {
  name     = var.budget_resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_monitor_action_group" "Budgetag1" {
  name                = var.budget_action_group_name1
  resource_group_name = var.budget_resource_group_name
  short_name          = var.budget_action_group_name1_short_name
  tags                = var.tags
  depends_on          = [azurerm_resource_group.budget-rg]
}

resource "azurerm_consumption_budget_subscription" "budgetalert" {
  name            = var.Subscription_budget_alert_name
  subscription_id = data.azurerm_subscription.current.id

  amount     = var.budget_alert_amount
  time_grain = var.budget_alert_time_grain

  time_period {
    start_date = var.time_period_start_date
    end_date   = var.time_period_end_date
  }

  notification {
    enabled   = var.budget_notification_enabled
    threshold = 25
    operator  = var.budget_notification_operator

    contact_emails = var.contact_emails
  }

  notification {
    enabled   = var.budget_notification_enabled
    threshold = 50
    operator  = var.budget_notification_operator

    contact_emails = var.contact_emails
  }

  notification {
    enabled   = var.budget_notification_enabled
    threshold = 75
    operator  = var.budget_notification_operator

    contact_emails = var.contact_emails
  }

  notification {
    enabled   = true
    threshold = 90.0
    operator  = "EqualTo"

    contact_emails = var.contact_emails
  }

  notification {
    enabled        = false
    threshold      = 100.0
    operator       = "GreaterThan"
    threshold_type = "Forecasted"

    contact_emails = var.contact_emails
  }
}
