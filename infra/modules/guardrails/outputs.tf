output "guardrails_policy_arn" {
  description = "ARN of the core governance guardrails policy"
  value       = aws_iam_policy.core_guardrails.arn
}
