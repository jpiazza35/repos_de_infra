locals {
  cloudwatch_log_group = var.create && var.create_cloudwatch_log_group ? aws_cloudwatch_log_group.cw[0].name : var.cloudwatch_log_group_name
}
