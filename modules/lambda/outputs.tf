
# =============================================================================
# LAMBDA MODULE OUTPUTS
# =============================================================================
# Purpose: Output values from Lambda module resources for use by other modules
output "lambda_function_arn" {
  value = aws_lambda_function.this[0].arn
}
output "lambda_function_name" {
  value = aws_lambda_function.this[0].function_name
}
output "lambda_function_invoke_arn" {
  value = aws_lambda_function.this[0].invoke_arn
}
output "lambda_function_qualified_arn" {
  value = aws_lambda_function.this[0].qualified_arn
}
output "lambda_function_version" {
  value = aws_lambda_function.this[0].version
}

output "lambda_log_group_arn" {
  description = "The ARN of the CloudWatch log group for the Lambda function"
  value       = aws_cloudwatch_log_group.lambda_log_group.arn
}
