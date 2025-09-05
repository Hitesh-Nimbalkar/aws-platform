
variable "image_uri" {
  description = "ECR image URI for Lambda Docker deployment. If set, deploys Lambda from Docker image."
  type        = string
  default     = null
}
# Tags for Lambda resources
variable "tags" {
  description = "A map of tags to assign to the Lambda resources."
  type        = map(string)
  default     = {}
}
# Environment variables for Lambda
variable "environment_variables" {
  description = "A map of environment variables for the Lambda function."
  type        = map(string)
  default     = {}
}
# Memory size for Lambda
variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime."
  type        = number
  default     = 128
}
# Timeout for Lambda
variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 3
}
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
  description = "Purpose of the Lambda function"
  type        = string
}
variable "lambda_handler" {
  description = "Handler for the Lambda function (e.g., main.handler)"
  type        = string
}
variable "lambda_runtime" {
  description = "Runtime for the Lambda function"
  type        = string
  default     = "python3.12"
}
variable "lambda_source_path" {
  description = "Path to the Python file for the Lambda function"
  type        = string
}
variable "policy_arns" {
  description = "List of policy ARNs to attach to the Lambda role"
  type        = list(string)
  default     = []
}
