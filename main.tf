
################################################################################
#                                                                              #
#                              CLOUDWATCH LOGS BACKUP                          #
#                                                                              #
################################################################################
# =============================================================================
# Archive Lambda Source for CloudWatch Logs Backup
# =============================================================================
data "archive_file" "cloudwatch_logs_backup_lambda" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/cloudwatch_logs_backup"
  output_path = "${path.module}/lambda/cloudwatch_logs_backup.zip"
}
# =============================================================================
# S3: CloudWatch Logs Backup Bucket
# =============================================================================
module "cloudwatch_logs_backup_bucket" {
  source        = "./modules/s3"
  organization  = var.organization
  environment   = var.environment
  project       = var.project
  purpose       = "cloudwatch-logs-backup"
  bucket_name   = null # Let module construct the name
  force_destroy = true
  common_tags   = var.common_tags
}
# =============================================================================
# Lambda: CloudWatch Logs Backup Lambda
# =============================================================================
module "cloudwatch_logs_backup_lambda" {
  source                = "./modules/lambda"
  organization          = var.organization
  environment           = var.environment
  project               = var.project
  purpose               = "cloudwatch-logs-backup"
  lambda_handler        = "main.lambda_handler"
  lambda_runtime        = "python3.12"
  lambda_source_path    = data.archive_file.cloudwatch_logs_backup_lambda.output_path
  memory_size           = 256
  timeout               = 900
  environment_variables = {
    S3_BUCKET = module.cloudwatch_logs_backup_bucket.bucket_name
  }
  policy_arns = [
    aws_iam_policy.cloudwatch_logs_to_s3.arn
  ]
  tags = var.common_tags
}
# =============================================================================
# IAM Policy: CloudWatch Logs to S3
# =============================================================================
resource "aws_iam_policy" "cloudwatch_logs_to_s3" {
  name        = "cloudwatch-logs-to-s3-policy"
  description = "Allow Lambda to export CloudWatch logs to S3"
  policy      = data.aws_iam_policy_document.cloudwatch_logs_to_s3.json
}
data "aws_iam_policy_document" "cloudwatch_logs_to_s3" {
  statement {
    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:GetLogEvents",
      "logs:FilterLogEvents"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${module.cloudwatch_logs_backup_bucket.bucket_arn}/*"
    ]
  }
}
# =============================================================================
# CloudWatch Events: Schedule and Permissions
# =============================================================================
resource "aws_cloudwatch_event_rule" "cloudwatch_logs_backup_schedule" {
  name                = "cloudwatch-logs-backup-schedule"
  schedule_expression = "rate(7 days)"
}
resource "aws_cloudwatch_event_target" "cloudwatch_logs_backup_lambda_target" {
  rule      = aws_cloudwatch_event_rule.cloudwatch_logs_backup_schedule.name
  target_id = "cloudwatch-logs-backup-lambda"
  arn       = module.cloudwatch_logs_backup_lambda.lambda_function_arn[0]
}
resource "aws_lambda_permission" "allow_cloudwatch_events" {
  statement_id  = "AllowExecutionFromCloudWatchEvents"
  action        = "lambda:InvokeFunction"
  function_name = module.cloudwatch_logs_backup_lambda.lambda_function_name[0]
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cloudwatch_logs_backup_schedule.arn
}
# ============================================================================ #
# FUNCTIONALITY: CLOUDWATCH LOGS BACKUP                                      #
# ============================================================================ #
################################################################################
#                                                                              #
#                              GRAFANA MONITORING & NETWORKING                 #
#                                                                              #
################################################################################
# =============================================================================
# Networking: VPC, Subnets, Security Groups
# =============================================================================
module "networking" {
  source                = "./modules/networking"
  organization          = var.organization
  environment           = var.environment
  project               = var.project
  purpose               = "monitoring"
  vpc_cidr              = "10.10.0.0/16" # Update as needed
private_subnet_count  = 2
    availability_zones    = ["ap-south-1a", "ap-south-1b"] # Hyderabad zones
  ssh_cidr_blocks       = ["10.10.0.0/16"] # Restrict as needed
  grafana_cidr_blocks   = ["10.10.0.0/16"] # Restrict as needed
  tags                  = var.common_tags
}
# ============================================================================ #
# FUNCTIONALITY: VPC NETWORKING                                              #
# ============================================================================ #
# =============================================================================
# ECR: Platform Docker Repository
# =============================================================================
# resource "aws_ecr_repository" "platform" {
#   name                 = var.platform_ecr_repository
#   image_tag_mutability = "MUTABLE"
#   image_scanning_configuration {
#     scan_on_push = true
#   }
#   tags = var.common_tags
#  }
# # =============================================================================
# # Fargate: Monitoring Service
# # =============================================================================
# module "fargate_monitoring" {
#   source         = "./modules/fargate"
#   organization   = var.organization
#   environment    = var.environment
#   project        = var.project
#   purpose        = "monitoring"
#   cpu            = "256"
#   memory         = "512"
#   execution_role_policy_arns = [
#     "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
#     # Add more managed or custom policy ARNs as needed
#   ]
#   task_role_policy_arns = [
#     # Add managed or custom policy ARNs for your app's needs
#   ]
#   container_definitions = file("./fargate/container_definitions.json") # Update path as needed
#   desired_count    = 1
#   subnets          = module.networking.private_subnet_ids
#   security_groups  = [module.networking.security_group_id]
#   assign_public_ip = false
# }
# # ============================================================================ #
# # FUNCTIONALITY: GRAFANA MONITORING (FARGATE + ECR)                          #
# # ============================================================================ #

