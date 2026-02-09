resource "aws_iam_policy" "ai_bedrock_allow" {
  name        = "${var.project_name}-${var.env}-ai-bedrock-allow"
  description = "Allow limited Bedrock model invocation for governed AI role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel",
          "bedrock:InvokeModelWithResponseStream"
        ]
        Resource = "*"
      }
    ]
  })
}
