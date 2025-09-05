
terraform {
  backend "s3" {
    bucket         = var.tf_state_bucket
    key            = var.tf_state_key
    region         = var.tf_state_region
    dynamodb_table = var.tf_state_dynamodb_table
    encrypt        = true
  }
}

resource "aws_s3_bucket" "tf_state" {
  bucket = var.tf_state_bucket
  force_destroy = false
  tags = var.common_tags
}
resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}


