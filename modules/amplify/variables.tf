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
  description = "GitHub repository URL for Amplify app"
  type        = string
}

variable "github_token" {
  description = "GitHub OAuth token (leave null if using Amplify GitHub App)"
  type        = string
  default     = null
}

variable "branch_name" {
  description = "Branch name to deploy"
  type        = string
}

variable "framework" {
  description = "Framework type (Web, React, Next.js, Angular, etc.)"
  type        = string
  default     = "Web"
}

variable "stage" {
  description = "Stage (DEVELOPMENT, PRODUCTION, etc.)"
  type        = string
  default     = "DEVELOPMENT"
}

variable "enable_auto_build" {
  description = "Enable auto build from repo commits"
  type        = bool
  default     = true
}

variable "environment_variables" {
  description = "Environment variables for Amplify frontend"
  type        = map(string)
  default     = {}
}

variable "custom_rules" {
  description = "Custom rules for redirects/rewrite"
  type        = list(object({
    source = string
    target = string
    status = string
  }))
  default = []
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "build_spec_path" {
  description = "Path to a custom Amplify build spec file"
  type        = string
  default     = null
}

variable "base_directory" {
  description = "Root folder inside repo for Amplify build artifacts (e.g., ui, project-a-ui)"
  type        = string
  default     = "/"
}
