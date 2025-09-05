
variable "organization" {
  description = "Organization name (platform-level constant)"
  type        = string
}
variable "project" {
  description = "Project name (project-specific input)"
  type        = string
}
variable "environment" {
  description = "Environment name (platform-level managed)"
  type        = string
}
variable "purpose" {
  description = "Purpose/function identifier (specific to this S3 bucket)"
  type        = string
}
variable "bucket_name" {
  description = "Name of the S3 bucket (optional, if not provided will be auto-generated)"
  type        = string
  default     = null
}
variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket when the bucket is destroyed"
  type        = bool
  default     = false
}
variable "common_tags" {
  description = "A map of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
