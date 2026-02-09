resource "aws_iam_policy" "ai_kill_switch" {
  name        = "${var.project_name}-${var.env}-ai-kill-switch"
  description = "Emergency kill switch to disable all AI services instantly"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyAllBedrockUsage"
        Effect = "Deny"
        Action = [
          "bedrock:InvokeModel",
          "bedrock:InvokeModelWithResponseStream",
          "bedrock:CreateAgent",
          "bedrock:InvokeAgent"
        ]
        Resource = "*"
      }
    ]
  })
}
