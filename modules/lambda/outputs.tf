
# =============================================================================
# LAMBDA MODULE OUTPUTS
# =============================================================================
# Purpose: Output values from Lambda module resources for use by other modules
output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.this.arn
}
output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.this.function_name
}
output "lambda_function_invoke_arn" {
  description = "The ARN to be used for invoking Lambda function from API Gateway"
  value       = aws_lambda_function.this.invoke_arn
}
output "lambda_function_qualified_arn" {
  description = "The qualified ARN of the Lambda function"
  value       = aws_lambda_function.this.qualified_arn
}
output "lambda_function_version" {
  description = "Latest published version of the Lambda function"
  value       = aws_lambda_function.this.version
}
output "lambda_role_arn" {
  description = "The ARN of the IAM role used by the Lambda function"
  value       = aws_iam_role.lambda_role.arn
}
output "lambda_role_name" {
  description = "The name of the IAM role used by the Lambda function"
  value       = aws_iam_role.lambda_role.name
}
output "lambda_log_group_name" {
  description = "The name of the CloudWatch log group for the Lambda function"
  value       = aws_cloudwatch_log_group.lambda_log_group.name
}
output "lambda_log_group_arn" {
  description = "The ARN of the CloudWatch log group for the Lambda function"
  value       = aws_cloudwatch_log_group.lambda_log_group.arn
}
