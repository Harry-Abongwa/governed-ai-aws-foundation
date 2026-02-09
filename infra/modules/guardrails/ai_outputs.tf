output "ai_execution_role_arn" {
  description = "ARN of the AI execution role with governance guardrails"
  value       = aws_iam_role.ai_execution_role.arn
}
