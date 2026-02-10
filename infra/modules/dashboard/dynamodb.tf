resource "aws_dynamodb_table" "audit_events" {
  name         = "governed-ai-audit-events-${var.env}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "event_id"

  attribute {
    name = "event_id"
    type = "S"
  }

  attribute {
    name = "event_time"
    type = "S"
  }

  global_secondary_index {
    name            = "event_time_index"
    hash_key        = "event_time"
    projection_type = "ALL"
  }

  tags = {
    Project     = var.project_name
    Environment = var.env
  }
}
