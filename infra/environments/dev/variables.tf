variable "aws_region" {
  description = "AWS region for the environment"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for tagging and resource naming"
  type        = string
  default     = "governed-ai-foundation"
}

variable "env" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}
