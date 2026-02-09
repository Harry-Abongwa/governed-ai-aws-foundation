resource "aws_iam_role_policy_attachment" "ai_guardrails_attach" {
  role       = aws_iam_role.ai_execution_role.name
  policy_arn = aws_iam_policy.core_guardrails.arn
}
