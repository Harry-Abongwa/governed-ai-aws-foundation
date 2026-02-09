output "ai_kill_switch_policy_arn" {
  description = "ARN of the AI kill switch policy"
  value       = aws_iam_policy.ai_kill_switch.arn
}
