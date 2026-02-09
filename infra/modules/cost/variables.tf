variable "project_name" {
  description = "Project name for budget naming"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "monthly_budget_usd" {
  description = "Monthly AWS budget in USD"
  type        = number
}

variable "alert_email" {
  description = "Email address for budget alerts"
  type        = string
}
