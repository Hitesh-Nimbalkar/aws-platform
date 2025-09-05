
# =============================================================================
# S3 MODULE OUTPUTS
# =============================================================================
# Purpose: Output values from S3 module resources for use by other modules
output "bucket_id" {
  description = "The ID of the S3 bucket"
  value       = aws_s3_bucket.this.id
}
output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.this.arn
}
output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.this.bucket
}
output "bucket_domain_name" {
  description = "The domain name of the S3 bucket"
  value       = aws_s3_bucket.this.bucket_domain_name
}
output "bucket_regional_domain_name" {
  description = "The region-specific domain name of the S3 bucket"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}
output "bucket_hosted_zone_id" {
  description = "The hosted zone ID of the S3 bucket"
  value       = aws_s3_bucket.this.hosted_zone_id
}
output "bucket_region" {
  description = "The region of the S3 bucket"
  value       = aws_s3_bucket.this.region
}
