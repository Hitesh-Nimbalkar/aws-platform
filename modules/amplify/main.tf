resource "aws_amplify_app" "this" {
  name       = local.amplify_app_name
  repository = var.repo_url

  # ✅ Only set oauth_token if a github_token was passed
  dynamic "oauth_token" {
    for_each = var.github_token != null ? [1] : []
    content {
      oauth_token = var.github_token
    }
  }

  build_spec = var.build_spec_path != null ? file(var.build_spec_path) : <<EOT
version: 1
frontend:
  phases:
    build:
      commands: []
  artifacts:
    baseDirectory: ${var.base_directory}
    files:
      - '**/*'
  cache:
    paths: []
EOT

  environment_variables = var.environment_variables

  dynamic "custom_rule" {
    for_each = var.custom_rules
    content {
      source = custom_rule.value.source
      target = custom_rule.value.target
      status = custom_rule.value.status
    }
  }

  tags = var.tags
}
