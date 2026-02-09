resource "aws_apigatewayv2_api" "dashboard_api" {
  name          = "${var.project_name}-${var.env}-dashboard-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "OPTIONS"]
    allow_headers = ["*"]
    max_age       = 3600
  }
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.dashboard_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.dashboard.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.dashboard_api.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "status_route" {
  api_id    = aws_apigatewayv2_api.dashboard_api.id
  route_key = "GET /status"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "audit_route" {
  api_id    = aws_apigatewayv2_api.dashboard_api.id
  route_key = "GET /audit"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.dashboard_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "allow_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.dashboard.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.dashboard_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_route" "governance_route" {
  api_id    = aws_apigatewayv2_api.dashboard_api.id
  route_key = "GET /governance"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "killswitch_route" {
  api_id    = aws_apigatewayv2_api.dashboard_api.id
  route_key = "POST /kill-switch"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Secure kill-switch with IAM auth
resource "aws_apigatewayv2_route" "killswitch_route_secure" {
  api_id             = aws_apigatewayv2_api.dashboard_api.id
  route_key          = "POST /kill-switch-secure"
  authorization_type = "AWS_IAM"
  target             = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}
