
variable "organization" {
  description = "Organization name"
  type        = string
}
variable "environment" {
  description = "Environment name"
  type        = string
}
variable "project" {
  description = "Project name"
  type        = string
}
variable "purpose" {
  description = "Purpose/function identifier for the VPC"
  type        = string
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "private_subnet_count" {
  description = "Number of private subnets to create"
  type        = number
  default     = 2
}
variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
}
variable "ssh_cidr_blocks" {
  description = "CIDR blocks allowed to SSH into EC2"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}
variable "grafana_cidr_blocks" {
  description = "CIDR blocks allowed to access Grafana"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}
variable "tags" {
  description = "Tags to apply to networking resources"
  type        = map(string)
  default     = {}
}

