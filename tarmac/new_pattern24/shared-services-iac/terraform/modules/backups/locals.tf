locals {

  iam = var.enabled && var.iam_role_arn == null ? 1 : 0

  # Rule
  rule = var.rule_name == null ? [] : [
    {
      name = format("%s-daily-backup-plan", var.app)

      target_vault_name = format("%s-backup-vault", var.app)

      schedule = var.rule_schedule

      start_window = var.rule_start_window

      completion_window = var.rule_completion_window

      lifecycle = var.rule_lifecycle_cold_storage_after == null ? {} : {
        cold_storage_after = var.rule_lifecycle_cold_storage_after
        delete_after       = var.rule_lifecycle_delete_after
      }

      enable_continuous_backup = var.rule_enable_continuous_backup

      recovery_point_tags = var.rule_recovery_point_tags

      copy_actions = [
        {
          lifecycle = {
            cold_storage_after = 0
            delete_after       = 90
          },

          destination_vault_arn = "arn:aws:backup:us-east-2:${data.aws_caller_identity.current.account_id}:backup-vault:Default"
        },
      ]
    }
  ]

  # Rules
  rules = concat(local.rule, var.rules)

  # Selection
  selection = var.selection_name == null ? [] : [
    {
      name           = null
      resources      = var.selection_resources
      not_resources  = var.selection_not_resources
      conditions     = var.selection_conditions
      selection_tags = var.selection_tags
    }
  ]

  # Selections
  selections = concat(local.selection, var.selections)

  # Make sure the role can get tag resources
  depends_on = [aws_iam_role_policy_attachment.ab_tag_policy_attach]

}
