data "aws_vpc" "default" {
    default = true
}

data "aws_caller_identity" "current" {}

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
