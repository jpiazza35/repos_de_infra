resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "InternalToolDashboard"

  dashboard_body = var.dashboard_body
}

resource "aws_cloudwatch_log_group" "ecs-dev-internaltool" {
  retention_in_days = "7"
  tags = {
    Name = "/ecs/dev-internaltool"
  }
  tags_all = {
    Name = "/ecs/dev-internaltool"
  }
}

resource "aws_cloudwatch_log_group" "ecs_dev_internaltool" {
  retention_in_days = "7"
  tags = {
    Name = "/ecs/dev-internaltool"
  }
  tags_all = {
    name = "/ecs/dev-internaltool"
  }
}

resource "aws_cloudwatch_log_group" "ecs_prod_internaltool" {
  retention_in_days = "7"
  tags = {
    Name = "/ecs/internaltool-prod"
  }
  tags_all = {
    name = "/ecs/internaltool-prod"
  }
}
