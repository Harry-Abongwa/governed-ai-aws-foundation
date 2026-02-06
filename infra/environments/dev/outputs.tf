output "vpc_id" {
  description = "VPC ID for the dev environment"
  value       = module.network.vpc_id
}
