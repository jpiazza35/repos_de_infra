# AWS Backup vault
resource "aws_backup_vault" "ab_vault" {
  count       = var.enabled ? 1 : 0
  name        = format("%s-backup-vault", var.app)
  kms_key_arn = var.vault_kms_key_arn
  tags        = var.tags
}

# AWS Backup plan
resource "aws_backup_plan" "ab_plan" {
  count = var.enabled ? 1 : 0
  name  = format("%s-backup-plan", var.app)

  # Rules
  dynamic "rule" {
    for_each = local.rules
    content {
      rule_name                = lookup(rule.value, "name", null)
      target_vault_name        = lookup(rule.value, "target_vault_name", null) != null ? rule.value.target_vault_name : "Default"
      schedule                 = lookup(rule.value, "schedule", null)
      start_window             = lookup(rule.value, "start_window", null)
      completion_window        = lookup(rule.value, "completion_window", null)
      enable_continuous_backup = lookup(rule.value, "enable_continuous_backup", null)
      recovery_point_tags      = length(lookup(rule.value, "recovery_point_tags", {})) == 0 ? var.tags : lookup(rule.value, "recovery_point_tags")

      # Lifecycle
      dynamic "lifecycle" {
        for_each = length(lookup(rule.value, "lifecycle", {})) == 0 ? [] : [lookup(rule.value, "lifecycle", {})]
        content {
          cold_storage_after = lookup(lifecycle.value, "cold_storage_after", 0)
          delete_after       = lookup(lifecycle.value, "delete_after", 90)
        }
      }

      # Copy action
      dynamic "copy_action" {
        for_each = lookup(rule.value, "copy_actions", [])
        content {
          destination_vault_arn = lookup(copy_action.value, "destination_vault_arn", null)

          # Copy Action Lifecycle
          dynamic "lifecycle" {
            for_each = length(lookup(copy_action.value, "lifecycle", {})) == 0 ? [] : [lookup(copy_action.value, "lifecycle", {})]
            content {
              cold_storage_after = lookup(lifecycle.value, "cold_storage_after", 0)
              delete_after       = lookup(lifecycle.value, "delete_after", 90)
            }
          }
        }
      }
    }
  }

  # Advanced backup setting
  dynamic "advanced_backup_setting" {
    for_each = var.windows_vss_backup ? [1] : []
    content {
      backup_options = {
        WindowsVSS = "enabled"
      }
      resource_type = "EC2"
    }
  }

  # Tags
  tags = var.tags

  # First create the vault if needed
  depends_on = [
    aws_backup_vault.ab_vault
  ]
}


resource "aws_backup_selection" "ab_selection" {
  count = var.enabled ? length(local.selections) : 0

  iam_role_arn = var.iam_role_arn != null ? var.iam_role_arn : aws_iam_role.ab_role[0].arn
  name         = lookup(element(local.selections, count.index), "name") == null ? format("%s-aws-backup-plan-selection", var.app) : lookup(element(local.selections, count.index), "name")

  plan_id = aws_backup_plan.ab_plan[0].id

  resources = lookup(element(local.selections, count.index), "resources", null)

  not_resources = lookup(element(local.selections, count.index), "not_resources", null)

  dynamic "selection_tag" {
    for_each = length(lookup(element(local.selections, count.index), "selection_tags", [])) == 0 ? [] : lookup(element(local.selections, count.index), "selection_tags", [])
    content {
      type  = lookup(selection_tag.value, "type", null)
      key   = lookup(selection_tag.value, "key", null)
      value = lookup(selection_tag.value, "value", null)
    }
  }

  condition {
    dynamic "string_equals" {
      for_each = lookup(lookup(element(local.selections, count.index), "conditions", {}), "string_equals", [])
      content {
        key   = lookup(string_equals.value, "key", null)
        value = lookup(string_equals.value, "value", null)
      }
    }
    dynamic "string_like" {
      for_each = lookup(lookup(element(local.selections, count.index), "conditions", {}), "string_like", [])
      content {
        key   = lookup(string_like.value, "key", null)
        value = lookup(string_like.value, "value", null)
      }
    }
    dynamic "string_not_equals" {
      for_each = lookup(lookup(element(local.selections, count.index), "conditions", {}), "string_not_equals", [])
      content {
        key   = lookup(string_not_equals.value, "key", null)
        value = lookup(string_not_equals.value, "value", null)
      }
    }
    dynamic "string_not_like" {
      for_each = lookup(lookup(element(local.selections, count.index), "conditions", {}), "string_not_like", [])
      content {
        key   = lookup(string_not_like.value, "key", null)
        value = lookup(string_not_like.value, "value", null)
      }
    }
  }
}

## AWS Backup Lock
resource "aws_backup_vault_lock_configuration" "lock" {
  count               = var.enabled ? 1 : 0
  backup_vault_name   = aws_backup_vault.ab_vault[count.index].name
  changeable_for_days = 3
  max_retention_days  = 45
  min_retention_days  = 7
}
