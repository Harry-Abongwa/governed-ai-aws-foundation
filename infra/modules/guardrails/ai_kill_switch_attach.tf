resource "aws_iam_role_policy_attachment" "ai_kill_switch_attach" {
  count      = 0
  role       = aws_iam_role.ai_execution_role.name
  policy_arn = aws_iam_policy.ai_kill_switch.arn
}
