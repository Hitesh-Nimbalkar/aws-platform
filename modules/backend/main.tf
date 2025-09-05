
variable "organization" { type = string }
variable "environment"  { type = string }
variable "project"      { type = string }
resource "aws_s3_bucket" "tf_state" {
  bucket = "${var.organization}-${var.environment}-${var.project}-tfstate"
  force_destroy = true
}

output "bucket" {
  value = aws_s3_bucket.tf_state.bucket
}

