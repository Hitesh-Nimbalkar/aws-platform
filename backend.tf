
terraform {
  backend "s3" {
    bucket         = "msumani-terraform-state"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "msumani-terraform-lock"
    encrypt        = true
  }
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "msumani-terraform-state"
  force_destroy = false
  tags = var.common_tags
}
resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# DynamoDB table for Terraform state locking
resource "aws_dynamodb_table" "tf_state_lock" {
  name         = "msumani-terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.common_tags
}


