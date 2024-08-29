resource "aws_scheduler_schedule" "trigger_lambda_rule" {
  for_each = { for db in local.source_input : "${var.common_properties.environment}_${db.db_name}" => db }
  name     = "${each.key}_rule"

  state = "ENABLED"
  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_lambda_function.lambda_function.arn
    role_arn = aws_iam_role.scheduler_role.arn

    input = jsonencode({
      db_host         = each.value.db_host
      db_user         = each.value.db_user
      db_pass         = each.value.db_pass
      db_name         = each.value.db_name
      init_command    = each.value.db_type
      upload_location = each.value.upload_location_dataset
      ecs_cluster     = { for key, val in local.ecs_cluster_name : key => val if key == "dataworld" }
      security_group  = { for key, val in local.security_group_id : key => val if key == "dataworld" }
      container_name  = { for key, val in local.container_name : key => val if key == "dataworld" }
    })
  }

  schedule_expression = nonsensitive("cron(${index(local.flat_db_names, each.value)} 22 * * ? *)")
}

## Lambda role and permission
resource "aws_iam_role" "scheduler_role" {
  name = "scheduler_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "scheduler.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "scheduler_policy" {
  name = "scheduler_policy"
  role = aws_iam_role.scheduler_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:InvokeFunction"
        ]
        Effect = "Allow"
        Resource = [
          "${aws_lambda_function.lambda_function.arn}:*",
          aws_lambda_function.lambda_function.arn
        ]
      }
    ]
  })
}
