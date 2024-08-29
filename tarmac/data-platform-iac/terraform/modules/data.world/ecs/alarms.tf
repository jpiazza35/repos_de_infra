module "chatbot" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//chatbot?ref=1.0.86"

  app                = "data-world"
  env                = var.properties.env_prefix
  guardrail_policies = var.properties.guardrail_policies
  list_email_address = var.properties.list_email_address
  log_level          = "INFO"
  slack_channel_id   = var.properties.slack.channel_id
  slack_workspace_id = var.properties.slack.workspace_id
}

resource "aws_cloudwatch_event_rule" "ecs_exit_code_nonzero" {
  name          = "${var.properties.env_prefix}-ecs-task-failed-rule"
  description   = "Trigger when a container exits with a non-zero exit code"
  event_pattern = <<PATTERN
{
  "source": [
    "aws.ecs"
  ],
  "detail-type": [
    "ECS Task State Change"
  ],
  "detail": {
    "containers": {
      "exitCode": [1]
    }
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "sns_topic" {
  rule      = aws_cloudwatch_event_rule.ecs_exit_code_nonzero.name
  target_id = "${var.properties.env_prefix}_sns_topic"
  arn       = module.chatbot.sns_topic_arn
}
