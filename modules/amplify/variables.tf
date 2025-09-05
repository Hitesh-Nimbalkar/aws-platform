
variable "organization" {
  description = "Organization name"
  type        = string
}
variable "project" {
  description = "Project name"
  type        = string
}
variable "environment" {
  description = "Environment name"
  type        = string
}
variable "purpose" {
  description = "Purpose/function identifier for the Amplify resources"
  type        = string
}
variable "repo_url" {
  description = "GitHub repository URL"
  type        = string
}
variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}
variable "build_spec_path" {
  description = "Path to buildspec.yml file"
  type        = string
  default     = null
}
variable "environment_variables" {
  description = "Map of environment variables for Amplify app"
  type        = map(string)
  default     = {}
}
variable "custom_rules" {
  description = "List of custom rules for Amplify app"
  type = list(object({
    source = string
    target = string
    status = string
  }))
  default = []
}
variable "tags" {
  description = "Tags to apply to Amplify resources"
  type        = map(string)
  default     = {}
}
variable "branch_name" {
  description = "Branch name to deploy"
  type        = string
  default     = "main"
}
variable "framework" {
  description = "Framework type (e.g., Web)"
  type        = string
  default     = "Web"
}
variable "stage" {
  description = "Stage of the branch (e.g., PRODUCTION)"
  type        = string
  default     = "PRODUCTION"
}
variable "enable_auto_build" {
  description = "Enable auto build for the branch"
  type        = bool
  default     = true
}
