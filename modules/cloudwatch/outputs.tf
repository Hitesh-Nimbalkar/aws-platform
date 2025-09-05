
# =============================================================================
# CLOUDWATCH MODULE OUTPUTS
# =============================================================================
# =============================================================================
# LOG GROUP OUTPUTS
# =============================================================================
output "log_group_name" {
  description = "CloudWatch log group name"
  value       = var.create_log_group ? aws_cloudwatch_log_group.this[0].name : null
}
output "log_group_arn" {
  description = "CloudWatch log group ARN"
  value       = var.create_log_group ? aws_cloudwatch_log_group.this[0].arn : null
}
output "log_group_retention_days" {
  description = "CloudWatch log group retention in days"
  value       = var.create_log_group ? aws_cloudwatch_log_group.this[0].retention_in_days : null
}
# =============================================================================
# LOG STREAM OUTPUTS
# =============================================================================
output "log_stream_names" {
  description = "List of CloudWatch log stream names"
  value       = var.create_log_streams ? aws_cloudwatch_log_stream.this[*].name : []
}
output "log_stream_arns" {
  description = "List of CloudWatch log stream ARNs"
  value       = var.create_log_streams ? aws_cloudwatch_log_stream.this[*].arn : []
}
# =============================================================================
# ALARM OUTPUTS
# =============================================================================
output "alarm_names" {
  description = "List of CloudWatch alarm names"
  value       = var.create_alarms ? aws_cloudwatch_metric_alarm.this[*].alarm_name : []
}
output "alarm_arns" {
  description = "List of CloudWatch alarm ARNs"
  value       = var.create_alarms ? aws_cloudwatch_metric_alarm.this[*].arn : []
}
# =============================================================================
# DASHBOARD OUTPUTS
# =============================================================================
output "dashboard_name" {
  description = "CloudWatch dashboard name"
  value       = var.create_dashboard ? aws_cloudwatch_dashboard.this[0].dashboard_name : null
}
output "dashboard_arn" {
  description = "CloudWatch dashboard ARN"
  value       = var.create_dashboard ? aws_cloudwatch_dashboard.this[0].dashboard_arn : null
}
# =============================================================================
# METRIC FILTER OUTPUTS
# =============================================================================
output "metric_filter_names" {
  description = "List of CloudWatch metric filter names"
  value       = var.create_metric_filters ? aws_cloudwatch_log_metric_filter.this[*].name : []
}
# =============================================================================
# LOG DESTINATION OUTPUTS
# =============================================================================
output "log_destination_name" {
  description = "CloudWatch log destination name"
  value       = var.create_log_destination ? aws_cloudwatch_log_destination.this[0].name : null
}
output "log_destination_arn" {
  description = "CloudWatch log destination ARN"
  value       = var.create_log_destination ? aws_cloudwatch_log_destination.this[0].arn : null
}
# =============================================================================
# SUBSCRIPTION FILTER OUTPUTS
# =============================================================================
output "subscription_filter_names" {
  description = "List of CloudWatch subscription filter names"
  value       = var.create_subscription_filters ? aws_cloudwatch_log_subscription_filter.this[*].name : []
}
# =============================================================================
# PLATFORM NAMING OUTPUTS
# =============================================================================
output "constructed_resource_name" {
  description = "Platform-constructed resource name following naming convention"
  value       = module.naming.resource_name
}
output "constructed_log_group_name" {
  description = "Platform-constructed log group name following naming convention"
  value       = module.naming.log_group_name
}
output "naming_pattern_used" {
  description = "Platform naming pattern used for this resource"
  value       = module.naming.naming_pattern
}
output "platform_tags" {
  description = "Platform-standardized tags applied to resources"
  value       = module.naming.platform_tags
}
