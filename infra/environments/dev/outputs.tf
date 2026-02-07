output "vpc_id" {
  description = "VPC ID for the dev environment"
  value       = module.network.vpc_id
}

output "dashboard_api_url" {
  description = "Public URL for the Governed AI Dashboard API"
  value       = module.dashboard.dashboard_api_url
}

output "dashboard_ui_url" {
  description = "Public URL for the Governed AI Dashboard UI"
  value       = module.dashboard.ui_url
}
