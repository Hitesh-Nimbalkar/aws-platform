
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
  description = "Purpose/function identifier for the Cognito resources"
  type        = string
}
variable "callback_urls" {
  description = "List of allowed callback URLs for the app client"
  type        = list(string)
}
