
variable "execution_role_policy_arns" {
  description = "List of policy ARNs to attach to the ECS execution role"
  type        = list(string)
  default     = []
}
variable "task_role_policy_arns" {
  description = "List of policy ARNs to attach to the ECS task role"
  type        = list(string)
  default     = []
}
variable "organization" {
  description = "Organization name for resource naming"
  type        = string
}
variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}
variable "project" {
  description = "Project name for resource naming"
  type        = string
}
variable "purpose" {
  description = "Purpose or component name for resource naming"
  type        = string
}
variable "cpu" {
  description = "CPU units for the task (256 is the minimum for Fargate)"
  type        = string
  default     = "256"
}
variable "memory" {
  description = "Memory for the task in MiB (512 is the minimum for Fargate)"
  type        = string
  default     = "512"
}

variable "container_definitions" {
  description = "Container definitions JSON"
  type        = string
}

variable "desired_count" {
  description = "Number of desired tasks"
  type        = number
}
variable "subnets" {
  description = "List of subnet IDs (must be private for cost/security best practice)"
  type        = list(string)
  validation {
    condition     = length(var.subnets) > 0
    error_message = "At least one subnet must be provided."
  }
}
variable "security_groups" {
  description = "List of security group IDs (should be least privilege)"
  type        = list(string)
  validation {
    condition     = length(var.security_groups) > 0
    error_message = "At least one security group must be provided."
  }
}
variable "assign_public_ip" {
  description = "Assign public IP to tasks"
  type        = bool
}
