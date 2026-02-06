terraform {
  backend "s3" {
    bucket         = "harry-governed-ai-tfstate-1770412450"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "harry-governed-ai-tflock"
    encrypt        = true
  }
}
