
# =============================================================================
# S3 MODULE - REUSABLE S3 BUCKET RESOURCES
# =============================================================================
# Purpose: S3 buckets for various purposes including CloudWatch logs backup
# Resources: S3 Buckets, Bucket Policies, Lifecycle Rules
# =============================================================================
# NAMING LOCALS
# =============================================================================
locals {
  bucket_name = var.bucket_name != null ? var.bucket_name : join("-", [
    var.organization, 
    var.environment, 
    var.project, 
    "s3", 
    var.purpose
  ])
}
# =============================================================================
# S3 BUCKET
# =============================================================================
resource "aws_s3_bucket" "this" {
  bucket        = local.bucket_name
  force_destroy = var.force_destroy
  tags = merge(var.common_tags, {
    Name      = local.bucket_name
    Component = "storage"
    Type      = "s3-bucket"
    Purpose   = var.purpose
  })
}
# =============================================================================
# S3 BUCKET VERSIONING
# =============================================================================
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}
# =============================================================================
# S3 BUCKET SERVER SIDE ENCRYPTION
# =============================================================================
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
# =============================================================================
# S3 BUCKET PUBLIC ACCESS BLOCK
# =============================================================================
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
