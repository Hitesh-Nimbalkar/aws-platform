
# =============================================================================
# PLATFORM NAMING VARIABLES
# =============================================================================
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
  description = "Purpose/function identifier (specific to this Lambda)"
  type        = string
}
# =============================================================================
# LAMBDA-SPECIFIC CONFIGURATION VARIABLES
# =============================================================================
variable "custom_policy_arns" {
  description = "List of custom policy ARNs to attach to the Lambda IAM role (in addition to basic execution role)."
  type        = list(string)
  default     = []
}
variable "image_uri" {
  description = "ECR image URI for Lambda."
  type        = string
}
variable "timeout" {
  description = "Lambda timeout."
  type        = number
  default     = 30
}
variable "memory_size" {
  description = "Lambda memory size."
  type        = number
  default     = 512
}
variable "environment_variables" {
  description = "Environment variables for Lambda."
  type        = map(string)
  default     = {}
}
variable "log_retention_in_days" {
  description = "CloudWatch log retention in days."
  type        = number
  default     = 14
}
variable "common_tags" {
  description = "Common tags to apply to all resources."
  type        = map(string)
  default     = {}
}
