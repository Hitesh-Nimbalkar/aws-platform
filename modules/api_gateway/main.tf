
# =============================================================================
# API GATEWAY MODULE - REUSABLE API GATEWAY RESOURCES
# =============================================================================
# Purpose: Common API Gateway resources that can be reused across projects
# Resources: REST API, Resources, Methods, Integrations, Deployment, Stage
# =============================================================================
# NAMING LOCALS
# =============================================================================
locals {
  api_gateway_name      = join("-", [var.organization, var.environment, var.project, "api", var.purpose])
  api_gateway_role_name = "${local.api_gateway_name}-role"
  api_gateway_log_group = "/aws/apigateway/${local.api_gateway_name}"
}
# =============================================================================
# API GATEWAY-SPECIFIC CONFIGURATION VARIABLES
# =============================================================================
variable "stage_name" {
  description = "Stage name for API Gateway deployment"
  type        = string
  default     = "prod"
}
variable "aws_region" {
  description = "AWS region for API Gateway integrations"
  type        = string
}
variable "endpoints" {
  description = "List of API endpoints to create"
  type = list(object({
    path                    = string
    http_method            = string
    integration_type       = string
    integration_uri        = string
    integration_http_method = string
  }))
  default = []
}
variable "log_retention_in_days" {
  description = "CloudWatch log retention in days for API Gateway"
  type        = number
  default     = 14
}
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
# =============================================================================
# API GATEWAY RESOURCES
# =============================================================================
# Create API Gateway
resource "aws_api_gateway_rest_api" "main" {
  name        = local.api_gateway_name
  description = "API Gateway for ${local.api_gateway_name}"
  
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  
  tags = merge(var.common_tags, {
    Name      = local.api_gateway_name
    Component = "api"
  })
}
# =============================================================================
# CLOUDWATCH LOG GROUP FOR API GATEWAY
# =============================================================================
resource "aws_cloudwatch_log_group" "api_gateway_logs" {
  name              = local.api_gateway_log_group
  retention_in_days = var.log_retention_days
  
  tags = merge(var.common_tags, {
    Name      = local.api_gateway_log_group
    Component = "monitoring"
  })
}
# Create parent resources (e.g., "chat")
resource "aws_api_gateway_resource" "parent_resources" {
  for_each = toset([
    for endpoint in var.endpoints : split("/", endpoint.path)[0]
  ])
  
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = each.value
}
# Create child resources (e.g., "chat/index", "chat/query")
resource "aws_api_gateway_resource" "child_resources" {
  for_each = {
    for endpoint in var.endpoints : endpoint.path => endpoint
    if length(split("/", endpoint.path)) > 1
  }
  
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.parent_resources[split("/", each.value.path)[0]].id
  path_part   = split("/", each.value.path)[1]
}
# Create resources dynamically based on endpoints (for single-level paths)
resource "aws_api_gateway_resource" "single_level_resources" {
  for_each = {
    for endpoint in var.endpoints : endpoint.path => endpoint
    if length(split("/", endpoint.path)) == 1
  }
  
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = each.value.path
}
# Create methods dynamically
resource "aws_api_gateway_method" "endpoints" {
  for_each = { for endpoint in var.endpoints : "${endpoint.path}-${endpoint.http_method}" => endpoint }
  
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = length(split("/", each.value.path)) > 1 ? aws_api_gateway_resource.child_resources[each.value.path].id : aws_api_gateway_resource.single_level_resources[each.value.path].id
  http_method = each.value.http_method
  authorization = "NONE"
}
# Create integrations dynamically
resource "aws_api_gateway_integration" "endpoints" {
  for_each = { for endpoint in var.endpoints : "${endpoint.path}-${endpoint.http_method}" => endpoint }
  
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = length(split("/", each.value.path)) > 1 ? aws_api_gateway_resource.child_resources[each.value.path].id : aws_api_gateway_resource.single_level_resources[each.value.path].id
  http_method = aws_api_gateway_method.endpoints[each.key].http_method
  integration_http_method = each.value.integration_http_method
  type                   = each.value.integration_type
  uri                    = each.value.integration_uri
}
# Deploy API
resource "aws_api_gateway_deployment" "main" {
  depends_on = [
    aws_api_gateway_integration.endpoints
  ]
  rest_api_id = aws_api_gateway_rest_api.main.id
  
  lifecycle {
    create_before_destroy = true
  }
  
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_method.endpoints,
      aws_api_gateway_integration.endpoints,
    ]))
  }
}
# Create stage
resource "aws_api_gateway_stage" "main" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
  stage_name    = var.stage_name
  
  tags = merge(var.common_tags, {
    Name      = "${local.api_gateway_name}-${var.stage_name}"
    Component = "api"
  })
}
