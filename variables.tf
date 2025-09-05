
# =============================================================================
# COMMON TAGS FOR ALL RESOURCES
# =============================================================================
variable "common_tags" {
  description = "A map of tags to assign to all resources."
  type        = map(string)
  default     = {}
}
# =============================================================================
# AWS ACCOUNT LEVEL PLATFORM VARIABLES
# =============================================================================
# =============================================================================
# CORE CONFIGURATION
# =============================================================================
variable "organization" {
  description = "Organization name"
  type        = string
}
variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}
variable "owner" {
  description = "Owner of the resources"
  type        = string
}
variable "project" {
  description = "Project name"
  type        = string
}
# =============================================================================
# FEATURE FLAGS FOR AWS ACCOUNT LEVEL RESOURCES
# =============================================================================
variable "enable_cloudwatch_logs_backup" {
  description = "Enable CloudWatch logs backup to S3 at AWS account level"
  type        = bool
  default     = true
}
variable "enable_grafana_log_cleanup" {
  description = "Enable Grafana Lambda to clean CloudWatch logs at AWS account level"
  type        = bool
  default     = false
}
# =============================================================================
# CLOUDWATCH LOGS BACKUP CONFIGURATION
# =============================================================================
##
variable "logs_lambda_function_name" {
  description = "Name of the CloudWatch logs export Lambda function"
  type        = string
  default     = "logs-export"
}
variable "logs_backup_retention_days" {
  description = "Number of days to retain CloudWatch logs backup in S3"
  type        = number
  default     = 365
}
variable "logs_export_schedule_days" {
  description = "Schedule for exporting CloudWatch logs (in days)"
  type        = number
  default     = 10
}
variable "logs_lambda_timeout" {
  description = "Timeout for the CloudWatch logs export Lambda function in seconds"
  type        = number
  default     = 300
}
variable "logs_lambda_memory" {
  description = "Memory size for the CloudWatch logs export Lambda function in MB"
  type        = number
  default     = 256
}
variable "platform_ecr_repository" {
  description = "ECR repository name for platform-level Docker images (e.g., grafana, monitoring, etc.)"
  type        = string
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