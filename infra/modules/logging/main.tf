resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket = "${var.project_name}-${var.env}-cloudtrail-logs"

  tags = {
    Project     = var.project_name
    Environment = var.env
    Purpose     = "AuditLogs"
  }
}

resource "aws_s3_bucket_versioning" "cloudtrail_versioning" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "cloudtrail_block" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudwatch_log_group" "cloudtrail_logs" {
  name              = "/aws/cloudtrail/${var.project_name}-${var.env}"
  retention_in_days = 90

  tags = {
    Project     = var.project_name
    Environment = var.env
    Purpose     = "Audit"
  }
}

resource "aws_iam_role" "cloudtrail_role" {
  name = "${var.project_name}-${var.env}-cloudtrail-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "cloudtrail.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "cloudtrail_policy" {
  role = aws_iam_role.cloudtrail_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_cloudtrail" "this" {
  name                          = "${var.project_name}-${var.env}-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.id
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail_logs.arn}:*"
  cloud_watch_logs_role_arn    = aws_iam_role.cloudtrail_role.arn
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
}
