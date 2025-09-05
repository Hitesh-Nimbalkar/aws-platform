
resource "aws_cloudwatch_log_group" "fargate_log_group" {
  name              = "/aws/ecs/${local.fargate_task_family}"
  retention_in_days = 14
}
# Fargate ECS Service Module
locals {
  fargate_cluster_name      = join("-", [var.organization, var.environment, var.project, "fargate", var.purpose])
  fargate_service_name      = join("-", [var.organization, var.environment, var.project, "fargate-svc", var.purpose])
  fargate_task_family       = join("-", [var.organization, var.environment, var.project, "fargate-task", var.purpose])
  fargate_execution_role_name = join("-", [var.organization, var.environment, var.project, "fargate-exec-role", var.purpose])
  fargate_task_role_name      = join("-", [var.organization, var.environment, var.project, "fargate-task-role", var.purpose])
}
# IAM Role for ECS Execution
data "aws_iam_policy_document" "ecs_execution_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "ecs_execution_role" {
  name               = local.fargate_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_execution_assume_role.json
}
resource "aws_iam_role_policy_attachment" "ecs_execution_policy_attachments" {
  for_each   = toset(var.execution_role_policy_arns)
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = each.value
}
# IAM Role for ECS Task
data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "ecs_task_role" {
  name               = local.fargate_task_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}
resource "aws_iam_role_policy_attachment" "ecs_task_policy_attachments" {
  for_each   = toset(var.task_role_policy_arns)
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = each.value
}
resource "aws_ecs_cluster" "this" {
  name = local.fargate_cluster_name
}
resource "aws_ecs_task_definition" "this" {
  family                   = local.fargate_task_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions    = var.container_definitions
}
resource "aws_ecs_service" "this" {
  name            = local.fargate_service_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = var.assign_public_ip
  }
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }
  depends_on = [aws_ecs_task_definition.this]
}
