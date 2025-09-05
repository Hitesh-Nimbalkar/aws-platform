
# =============================================================================
# CLOUDWATCH MODULE - REUSABLE CLOUDWATCH RESOURCES
# =============================================================================
# Purpose: Provide common CloudWatch resources (log groups, alarms, dashboards)
# Usage: Can be used across different projects and environments
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
  description = "Purpose/function identifier for the CloudWatch resources"
  type        = string
}
# =============================================================================
# CLOUDWATCH LOG GROUP CONFIGURATION
# =============================================================================
variable "create_log_group" {
  description = "Whether to create CloudWatch log group"
  type        = bool
  default     = true
}
variable "log_group_name" {
  description = "Custom log group name (optional, will use naming convention if not provided)"
  type        = string
  default     = null
}
variable "log_retention_days" {
  description = "Log retention period in days"
  type        = number
  default     = 14
  validation {
    condition = contains([
      1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653
    ], var.log_retention_days)
    error_message = "Log retention days must be one of the valid CloudWatch values: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653."
  }
}
variable "log_group_kms_key_id" {
  description = "KMS key ID for log group encryption"
  type        = string
  default     = null
}
# =============================================================================
# CLOUDWATCH ALARMS CONFIGURATION
# =============================================================================
variable "create_alarms" {
  description = "Whether to create CloudWatch alarms"
  type        = bool
  default     = false
}
variable "alarms" {
  description = "List of CloudWatch alarms to create"
  type = list(object({
    name                = string
    description         = string
    metric_name         = string
    namespace           = string
    statistic           = string
    period              = number
    evaluation_periods  = number
    threshold           = number
    comparison_operator = string
    dimensions          = map(string)
    alarm_actions       = list(string)
    ok_actions          = list(string)
    treat_missing_data  = string
  }))
  default = []
}
# =============================================================================
# CLOUDWATCH DASHBOARD CONFIGURATION
# =============================================================================
variable "create_dashboard" {
  description = "Whether to create CloudWatch dashboard"
  type        = bool
  default     = false
}
variable "dashboard_name" {
  description = "Custom dashboard name (optional, will use naming convention if not provided)"
  type        = string
  default     = null
}
variable "dashboard_body" {
  description = "Dashboard body JSON configuration"
  type        = string
  default     = ""
}
# =============================================================================
# CLOUDWATCH LOG STREAM CONFIGURATION
# =============================================================================
variable "create_log_streams" {
  description = "Whether to create CloudWatch log streams"
  type        = bool
  default     = false
}
variable "log_streams" {
  description = "List of log stream names to create"
  type        = list(string)
  default     = []
}
# =============================================================================
# METRIC FILTERS CONFIGURATION
# =============================================================================
variable "create_metric_filters" {
  description = "Whether to create CloudWatch metric filters"
  type        = bool
  default     = false
}
variable "metric_filters" {
  description = "List of metric filters to create"
  type = list(object({
    name           = string
    filter_pattern = string
    log_group_name = string
    metric_transformation = object({
      name          = string
      namespace     = string
      value         = string
      default_value = string
    })
  }))
  default = []
}
# =============================================================================
# LOG DESTINATION AND SUBSCRIPTION FILTERS
# =============================================================================
variable "create_log_destination" {
  description = "Whether to create a CloudWatch log destination for S3 backup"
  type        = bool
  default     = false
}
variable "destination_name" {
  description = "Name of the CloudWatch log destination"
  type        = string
  default     = null
}
variable "target_arn" {
  description = "ARN of the target resource (S3 bucket, Kinesis stream, etc.)"
  type        = string
  default     = null
}
variable "role_arn" {
  description = "ARN of the IAM role that grants CloudWatch logs permission to put data into the target"
  type        = string
  default     = null
}
variable "create_subscription_filters" {
  description = "Whether to create CloudWatch log subscription filters"
  type        = bool
  default     = false
}
variable "subscription_filters" {
  description = "List of subscription filters to create"
  type = list(object({
    name            = string
    log_group_name  = string
    filter_pattern  = string
    destination_arn = string
    role_arn        = optional(string)
  }))
  default = []
}
# =============================================================================
# COMMON TAGS
# =============================================================================
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
# =============================================================================
# NAMING LOCALS
# =============================================================================
# Variables for naming convention
variable "organization" {
  description = "Organization name"
  type        = string
}
variable "project" {
  description = "Project name"
  type        = string
}
variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}
variable "purpose" {
  description = "Purpose of the CloudWatch resources"
  type        = string
}
