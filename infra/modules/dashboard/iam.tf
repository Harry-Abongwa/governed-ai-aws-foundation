resource "aws_iam_role" "dashboard_lambda_role" {
  name = "${var.project_name}-${var.env}-dashboard-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Read-only governance + audit permissions
resource "aws_iam_role_policy" "dashboard_read_policy" {
  role = aws_iam_role.dashboard_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:ListAttachedRolePolicies",
          "iam:GetRole",
          "logs:DescribeLogGroups",
          "logs:FilterLogEvents",
          "budgets:ViewBudget"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter"
        ]
        Resource = "arn:aws:ssm:us-east-1:*:parameter/governed-ai/*/kill-switch"
      }
    ]
  })
}

# CloudWatch metrics access for dashboard analytics
resource "aws_iam_role_policy" "dashboard_metrics_policy" {
  role = aws_iam_role.dashboard_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics"
        ]
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_role_policy" "dashboard_cost_policy" {
  role = aws_iam_role.dashboard_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ce:GetCostAndUsage",
          "budgets:ViewBudget"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "dashboard_cloudtrail_policy" {
  role = aws_iam_role.dashboard_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudtrail:LookupEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# Kill-switch in SSM Parameter Store
resource "aws_iam_role_policy" "dashboard_killswitch_policy" {
  role = aws_iam_role.dashboard_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:PutParameter"
        ]
        Resource = "arn:aws:ssm:us-east-1:*:parameter/governed-ai/${var.env}/kill-switch"
      }
    ]
  })
}

# Allow Lambda to query its own logs (audit reconstruction)
resource "aws_iam_role_policy" "dashboard_logs_insights_policy" {
  role = aws_iam_role.dashboard_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:StartQuery",
          "logs:GetQueryResults"
        ]
        Resource = "*"
      }
    ]
  })
}
