
# Cognito User Pool Module

# Local for Cognito resource naming
locals {
  cognito_user_pool_name        = join("-", [var.organization, var.environment, var.project, "cognito", var.purpose])
  cognito_user_pool_client_name = "${local.cognito_user_pool_name}-client"
}
resource "aws_cognito_user_pool" "this" {
  name = local.cognito_user_pool_name
}
resource "aws_cognito_user_pool_client" "this" {
  name         = local.cognito_user_pool_client_name
  user_pool_id = aws_cognito_user_pool.this.id
  generate_secret = false
  allowed_oauth_flows = ["code"]
  allowed_oauth_scopes = ["email", "openid", "profile"]
  allowed_oauth_flows_user_pool_client = true
  callback_urls = var.callback_urls
  supported_identity_providers = ["COGNITO"]
}
output "user_pool_id" {
  value = aws_cognito_user_pool.this.id
}
output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.this.id
}
