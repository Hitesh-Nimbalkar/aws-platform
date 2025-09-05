
output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.this.function_name
}
output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.this.arn
}
output "lambda_function_qualified_arn" {
  description = "Lambda function qualified ARN with version"
  value       = aws_lambda_function.this.qualified_arn
}
output "lambda_role_arn" {
  description = "Lambda execution role ARN"
  value       = aws_iam_role.lambda_role.arn
}
output "lambda_role_name" {
  description = "Lambda execution role name"
  value       = aws_iam_role.lambda_role.name
}
output "cloudwatch_log_group_name" {
  description = "CloudWatch log group name for Lambda"
  value       = aws_cloudwatch_log_group.lambda_logs.name
}
output "cloudwatch_log_group_arn" {
  description = "CloudWatch log group ARN for Lambda"
  value       = aws_cloudwatch_log_group.lambda_logs.arn
}
