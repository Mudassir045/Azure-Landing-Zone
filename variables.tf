variable "policy_display_names" {
  description = "A list of display names for the built-in policies."
  type        = list(string)
  default = ["Audit VMs that do not use managed disks",
    "Network interfaces should not have public IPs",
    "Subnets should be associated with a Network Security Group",
    "Network Watcher should be enabled",
    "Management ports should be closed on your virtual machines",
    "Auto provisioning of the Log Analytics agent should be enabled on your subscription",
    #"Enable Azure Monitor for VMs with Azure Monitoring Agent(AMA)",
    "Audit usage of custom RBAC roles",
    "A maximum of 3 owners should be designated for your subscription",
    #"Enable Microsoft Defender for Cloud on your subscription",
    #"Configure Log Analytics workspace and automation account to centralize logs and monitoring"
  ]
}

variable "budget_resource_group_name" {
  type    = string
  default = "budget-rg"
}

variable "budget_action_group_name1" {
  type    = string
  default = "Budgetag1"
}

variable "budget_action_group_name1_short_name" {
  type    = string
  default = "Budgetag1"
}

variable "Subscription_budget_alert_name" {
  type    = string
  default = "Subscription-budget-alert"
}

variable "budget_alert_amount" {
  type    = number
  default = 5000
}

variable "budget_alert_time_grain" {
  type    = string
  default = "Monthly"
}

variable "time_period_start_date" {
  type    = string
  default = "2024-10-01T00:00:00Z"
}

variable "time_period_end_date" {
  type    = string
  default = "2029-10-01T00:00:00Z"
}

variable "budget_notification_enabled" {
  type    = bool
  default = true
}

variable "budget_notification_operator" {
  type    = string
  default = "EqualTo"
}

# variable "budget_notification_threshold" {
#   description = "A map of tags to assign to the resource"
#   type        = list(number)
#   default     = ["25"]
# }

variable "contact_emails" {
  description = "A list of display names of emails."
  type        = list(string)
  default = [
    "abc@gmail.com",
    "xyz@gmail.com",
  ]
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default = {
    Environment  = "Development"
    CreatedBy    = "Mudassir"
    ApprovedBy   = "Mudassir"
    CreationDate = "11 Sept 2024"
  }
}

variable "resource_group_name" {
  type        = string
  description = "This defines the resource group name"
  default     = "DEV-RG-01"
}

variable "location" {
  type        = string
  description = "This defines the location"
  default     = "Central India"
}

variable "virtual_network_name" {
  type        = string
  description = "This defines the name of the virtual network"
  default     = "DEV-VNET-01"
}

# variable "virtual_network_address_space" {
#   type        = string
#   description = "This defines the address space of the virtual network"
#   default     = "10.0.0.0/16"
# }

variable "admin_username" {
  type    = string
  default = "Mudassir"
}

variable "admin_password" {
  type      = string
  sensitive = true
  default   = "Mudassir@123"
}
