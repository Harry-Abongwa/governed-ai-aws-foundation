module "network" {
  source = "../../modules/network"

  project_name = var.project_name
  env          = var.env
}

module "guardrails" {
  source = "../../modules/guardrails"

  project_name = var.project_name
  env          = var.env
}

module "logging" {
  source = "../../modules/logging"

  project_name = var.project_name
  env          = var.env
}

module "cost" {
  source = "../../modules/cost"

  project_name       = var.project_name
  env                = var.env
  monthly_budget_usd = 50
  alert_email        = "harryabongwa@outlook.com"
}

module "dashboard" {
  source = "../../modules/dashboard"

  project_name = var.project_name
  env          = var.env
}
