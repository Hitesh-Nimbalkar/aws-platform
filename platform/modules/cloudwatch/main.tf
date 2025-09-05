
# =============================================================================
# CLOUDWATCH MODULE - REUSABLE CLOUDWATCH RESOURCES
# =============================================================================
# Purpose: Common CloudWatch resources that can be reused across projects
# Resources: Log Groups, Alarms, Dashboards, Metric Filters

# Local for CloudWatch resource naming
locals {
  cloudwatch_log_group_name = join("-", [var.organization, var.environment, var.project, "cloudwatch", var.purpose])
  cloudwatch_alarm_name     = "${local.cloudwatch_log_group_name}-alarm"
  cloudwatch_dashboard_name = "${local.cloudwatch_log_group_name}-dashboard"
}
# =============================================================================
# CLOUDWATCH LOG GROUP
# =============================================================================
resource "aws_cloudwatch_log_group" "this" {
  count             = var.create_log_group ? 1 : 0
  name              = var.log_group_name != null ? var.log_group_name : local.cloudwatch_log_group_name
  retention_in_days = var.log_retention_days
  kms_key_id        = var.log_group_kms_key_id
  tags = merge(var.common_tags, {
    Name      = var.log_group_name != null ? var.log_group_name : local.cloudwatch_log_group_name
    Component = "monitoring"
    Type      = "log-group"
  })
}
# =============================================================================
# CLOUDWATCH LOG STREAMS
# =============================================================================
resource "aws_cloudwatch_log_stream" "this" {
  count          = var.create_log_streams && var.create_log_group ? length(var.log_streams) : 0
  name           = var.log_streams[count.index]
  log_group_name = aws_cloudwatch_log_group.this[0].name
  depends_on = [aws_cloudwatch_log_group.this]
}
# =============================================================================
# CLOUDWATCH METRIC ALARMS
# =============================================================================
resource "aws_cloudwatch_metric_alarm" "this" {
  count = var.create_alarms ? length(var.alarms) : 0
  alarm_name          = "${local.cloudwatch_alarm_name}-${var.alarms[count.index].name}"
  alarm_description   = var.alarms[count.index].description
  comparison_operator = var.alarms[count.index].comparison_operator
  evaluation_periods  = var.alarms[count.index].evaluation_periods
  metric_name         = var.alarms[count.index].metric_name
  namespace           = var.alarms[count.index].namespace
  period              = var.alarms[count.index].period
  statistic           = var.alarms[count.index].statistic
  threshold           = var.alarms[count.index].threshold
  alarm_actions       = var.alarms[count.index].alarm_actions
  ok_actions          = var.alarms[count.index].ok_actions
  treat_missing_data  = var.alarms[count.index].treat_missing_data
  dimensions          = var.alarms[count.index].dimensions
  tags = merge(var.common_tags, {
    Name      = "${local.cloudwatch_alarm_name}-${var.alarms[count.index].name}"
    Component = "monitoring"
    Type      = "alarm"
  })
}
# =============================================================================
# CLOUDWATCH DASHBOARD
# =============================================================================
resource "aws_cloudwatch_dashboard" "this" {
  count          = var.create_dashboard ? 1 : 0
  dashboard_name = var.dashboard_name != null ? var.dashboard_name : local.cloudwatch_dashboard_name
  dashboard_body = var.dashboard_body
}
# =============================================================================
# CLOUDWATCH METRIC FILTERS
# =============================================================================
resource "aws_cloudwatch_log_metric_filter" "this" {
  count          = var.create_metric_filters ? length(var.metric_filters) : 0
  name           = "${local.cloudwatch_log_group_name}-${var.metric_filters[count.index].name}"
  log_group_name = var.metric_filters[count.index].log_group_name
  pattern        = var.metric_filters[count.index].filter_pattern
  metric_transformation {
    name          = var.metric_filters[count.index].metric_transformation.name
    namespace     = var.metric_filters[count.index].metric_transformation.namespace
    value         = var.metric_filters[count.index].metric_transformation.value
    default_value = var.metric_filters[count.index].metric_transformation.default_value
  }
}
