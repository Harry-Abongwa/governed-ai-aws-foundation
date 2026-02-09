resource "aws_lambda_function" "dashboard" {
  function_name = "${var.project_name}-${var.env}-dashboard-api"
  role          = aws_iam_role.dashboard_lambda_role.arn
  runtime       = "python3.11"
  handler       = "app.handler"
  timeout       = 10

  filename         = "${path.module}/dashboard.zip"
  source_code_hash = filebase64sha256("${path.module}/dashboard.zip")

  environment {
    variables = {
      PROJECT = var.project_name
      ENV     = var.env
    }
  }
}
