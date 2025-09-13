
# =============================================================================
# API GATEWAY MODULE VARIABLES
# =============================================================================
# Purpose: Variable definitions for API Gateway module
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
  description = "Purpose/function identifier (specific to this API Gateway)"
  type        = string
}
variable "stage_name" {
  description = "Stage name for API Gateway deployment"
  type        = string
  default     = "prod"
}
variable "aws_region" {
  description = "AWS region for API Gateway integrations"
  type        = string
}
variable "endpoints" {
  description = "List of API endpoints to create"
  type = list(object({
    path                    = string
    http_method            = string
    integration_type       = string
    integration_uri        = string
    integration_http_method = string
  }))
  default = []
}
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
variable "enable_logging" {
  description = "Enable CloudWatch logging for API Gateway"
  type        = bool
  default     = true
}
variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 14
}
variable "throttle_burst_limit" {
  description = "API Gateway throttle burst limit"
  type        = number
  default     = 5000
}
variable "throttle_rate_limit" {
  description = "API Gateway throttle rate limit"
  type        = number
  default     = 10000
}
