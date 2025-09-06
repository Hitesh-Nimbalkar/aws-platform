# Locals for naming
locals {
  lambda_function_name = join("-", [var.organization, var.environment, var.project, "lambda", var.purpose])
  lambda_log_group_name = "/aws/lambda/${local.lambda_function_name}"
  lambda_role_name      = "${local.lambda_function_name}-role"
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name               = local.lambda_role_name
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Attach user-supplied policies
resource "aws_iam_role_policy_attachment" "lambda_policy_attachments" {
  for_each   = var.policy_arns
  role       = aws_iam_role.lambda_role.name
  policy_arn = each.value
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = local.lambda_log_group_name
  retention_in_days = 14
}

# Lambda function (ZIP or Image)
resource "aws_lambda_function" "this" {
  function_name = local.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  memory_size   = var.memory_size
  timeout       = var.timeout
  tags          = var.tags

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) > 0 ? [1] : []
    content {
      variables = var.environment_variables
    }
  }

  # Deployment type: ZIP or Image
  package_type = var.image_uri != null && var.image_uri != "" ? "Image" : "Zip"
  filename     = var.image_uri == null || var.image_uri == "" ? var.zip_file_path : null
  image_uri    = var.image_uri != null && var.image_uri != "" ? var.image_uri : null
}
