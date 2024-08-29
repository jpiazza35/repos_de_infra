module "ecs" {
  for_each = var.agent_properties
  source   = "../modules/ecs"
  properties = merge(
    each.value,
    var.common_properties,
    var.lambda_properties,
    {
      container_definitions = "${path.root}/../templates/generic_task_definition.tpl",
      private_subnets       = data.aws_subnets.private_subnets.ids,
      list_email_address = [
        "devops@cliniciannexus.com",
        "markoIlijoski@cliniciannexus.com"
      ]
      slack = {
        channel_id = [
          data.vault_generic_secret.slack_webhook.data["datadotworld_notification_channel_id"]
        ]
        workspace_id = data.vault_generic_secret.slack_webhook.data["slack_workspace_id"]
      }
      guardrail_policies = [
        "arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess"
      ]
    }
  )
  aws_s3_collector_bucket   = join(", ", local.databases.s3.db_names)
  aws_s3_collector_iam_role = "447179157197:role/data-dot-world-s3-metadata-collector-role"
}
