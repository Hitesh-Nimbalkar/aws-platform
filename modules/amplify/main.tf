# -----------------------------------------------------------------------------
# Locals
# -----------------------------------------------------------------------------
locals {
  amplify_app_name = join("-", [var.organization, var.environment, var.project, "amplify", var.purpose])
}

# -----------------------------------------------------------------------------
# Amplify App
# -----------------------------------------------------------------------------
resource "aws_amplify_app" "this" {
  name       = local.amplify_app_name
  repository = var.repo_url

  # ✅ Correct optional oauth_token handling (no dynamic block needed)
  oauth_token = var.github_token != null ? var.github_token : null

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

# -----------------------------------------------------------------------------
# Amplify Branch
# -----------------------------------------------------------------------------
resource "aws_amplify_branch" "main" {
  app_id            = aws_amplify_app.this.id
  branch_name       = var.branch_name
  framework         = var.framework
  stage             = var.stage
  enable_auto_build = var.enable_auto_build
}

# -----------------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------------
output "amplify_app_id" {
  description = "ID of the Amplify App"
  value       = aws_amplify_app.this.id
}

output "amplify_app_name" {
  description = "Name of the Amplify App"
  value       = local.amplify_app_name
}

output "amplify_default_domain" {
  description = "Default domain of the Amplify App"
  value       = aws_amplify_app.this.default_domain
}
