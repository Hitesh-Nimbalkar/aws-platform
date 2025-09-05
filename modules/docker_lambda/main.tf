
# =============================================================================
# NAMING LOCALS
# =============================================================================
# Local for Docker Lambda function naming
locals {
  lambda_function_name  = join("-", [var.organization, var.environment, var.project, "lambda", var.purpose])
  lambda_log_group_name = "/aws/lambda/${local.lambda_function_name}"
  lambda_role_name      = "${local.lambda_function_name}-role"
}
# =============================================================================
# IAM ROLE FOR LAMBDA - CREATED WITHIN MODULE
# =============================================================================
# Purpose: Lambda execution role with basic permissions (CloudWatch logs)
# Additional custom policies will be attached from main configuration
resource "aws_iam_role" "lambda_role" {
  name = local.lambda_role_name
  
  # Standard Lambda assume role policy
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
  
  tags = merge(var.common_tags, {
    Name         = local.lambda_role_name
    Component    = "security"
  })
}
# Attach AWS managed basic execution role policy
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
# Attach any custom policies passed from main configuration
resource "aws_iam_role_policy_attachment" "lambda_custom_policies" {
  for_each   = toset(var.custom_policy_arns)
  role       = aws_iam_role.lambda_role.name
  policy_arn = each.value
}
# =============================================================================
# CLOUDWATCH LOG GROUP FOR LAMBDA
# =============================================================================
# Purpose: Dedicated log group for this Lambda function following naming convention
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = local.lambda_log_group_name
  retention_in_days = var.log_retention_in_days
  
  tags = merge(var.common_tags, {
    Name         = local.lambda_log_group_name
    Component    = "monitoring"
  })
}
# =============================================================================
# LAMBDA FUNCTION
# =============================================================================
resource "aws_lambda_function" "this" {
  function_name = local.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = var.image_uri
  timeout       = var.timeout
  memory_size   = var.memory_size
  
  # Make sure log group is created before Lambda function
  depends_on = [aws_cloudwatch_log_group.lambda_logs]
  
  environment {
    variables = var.environment_variables
  }
  
  tags = merge(var.common_tags, {
    Name      = local.lambda_function_name
    Component = "compute"
  })
}
