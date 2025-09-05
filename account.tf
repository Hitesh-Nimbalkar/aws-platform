
data "aws_vpc" "default" {
  default = true
}
# Fetch AWS account ID dynamically
data "aws_caller_identity" "current" {}
# Fetch default VPC for the account/region
data "aws_vpc" "default" {
    default = true
}
# Consolidated locals for account-wide settings
locals {
    organization    = "dummy"
    project         = "dummy-project"
    account_region  = "ap-south-2"
    environment     = local.account_region
    account_id      = data.aws_caller_identity.current.account_id
    default_vpc_id  = data.aws_vpc.default.id
}
output "default_vpc_id" {
    value = local.default_vpc_id
}
