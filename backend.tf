
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

# TERRAFORM STATE BACKEND CONFIGURATION
# =============================================================================
variable "tf_state_bucket" {
  description = "The name of the S3 bucket for storing the Terraform state file."
  type        = string
}
variable "tf_state_key" {
  description = "The path/key in the S3 bucket for the Terraform state file."
  type        = string
  default     = "platform/terraform.tfstate"
}
variable "tf_state_region" {
  description = "The AWS region for the S3 bucket used for the Terraform state file."
  type        = string
}
variable "tf_state_dynamodb_table" {
  description = "The name of the DynamoDB table for state locking."
  type        = string
  default     = null
}
