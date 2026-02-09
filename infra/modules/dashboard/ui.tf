data "aws_region" "current" {}

resource "aws_s3_bucket" "ui_bucket" {
  bucket = "${var.project_name}-${var.env}-ai-dashboard-ui"

  tags = {
    Project     = var.project_name
    Environment = var.env
    Purpose     = "GovernedAIDashboardUI"
  }
}
resource "aws_s3_bucket_website_configuration" "ui_site" {
  bucket = aws_s3_bucket.ui_bucket.id

  index_document {
    suffix = "index.html"
  }
}
resource "aws_s3_bucket_public_access_block" "ui_public" {
  bucket = aws_s3_bucket.ui_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
resource "aws_s3_bucket_policy" "ui_policy" {
  bucket = aws_s3_bucket.ui_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.ui_bucket.arn}/*"
    }]
  })
}
output "ui_url" {
  value = "http://${aws_s3_bucket.ui_bucket.bucket}.s3-website-${data.aws_region.current.id}.amazonaws.com"
}
