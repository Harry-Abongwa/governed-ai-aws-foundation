resource "aws_iam_role" "ai_execution_role" {
  name = "${var.project_name}-${var.env}-ai-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "bedrock.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Project     = var.project_name
    Environment = var.env
    RoleType    = "AI"
  }
}
