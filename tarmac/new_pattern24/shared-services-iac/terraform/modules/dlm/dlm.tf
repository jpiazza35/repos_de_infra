resource "aws_dlm_lifecycle_policy" "dlm" {
  for_each = {
    for dlm in var.dlm : dlm.name => dlm
  }
  description        = each.value.description
  execution_role_arn = aws_iam_role.dlm_lifecycle_role.arn
  state              = each.value.state

  policy_details {
    dynamic "action" {
      for_each = each.value.policy_details.action != null ? [
        each.value.policy_details.action
      ] : []
      content {
        name = action.value != null ? action.value.name : null
        cross_region_copy {
          target = action.value != null ? action.value.cross_region_copy.target_arn : null
          dynamic "retain_rule" {
            for_each = action.value != null ? [
              action.value.cross_region_copy.retain_rule
            ] : []
            content {
              interval      = action.value.cross_region_copy.retain_rule.interval
              interval_unit = action.value.cross_region_copy.retain_rule.interval_unit
            }
          }
          encryption_configuration {
            cmk_arn   = action.value != null ? action.value.cross_region_copy.encryption_configuration.kms_key_arn : null
            encrypted = action.value != null ? action.value.cross_region_copy.encryption_configuration.encrypted : null
          }
        }
      }
    }

    dynamic "event_source" {
      for_each = each.value.policy_details.event_source != null && each.value.policy_details.event_source != {} ? [
        each.value.policy_details.event_source
      ] : []
      content {
        type = each.value.policy_details.event_source != null ? each.value.policy_details.event_source.type : null
        dynamic "parameters" {
          for_each = event_source.value != null ? [
            event_source.value.parameters
          ] : []
          content {
            description_regex = event_source.value.parameters.description_regex
            event_type        = event_source.value.parameters.event_type
            snapshot_owner    = event_source.value.parameters.snapshot_owner
          }
        }
      }
    }

    resource_types = each.value.policy_details.resource_types

    resource_locations = each.value.policy_details.resource_locations

    policy_type = each.value.policy_details.policy_type

    dynamic "parameters" {
      for_each = each.value.policy_details.parameters != null || each.value.policy_details.parameters != {} && each.value.policy_details.policy_type != "EVENT_BASED_POLICY" ? [
        each.value.policy_details.parameters
      ] : []
      content {
        exclude_boot_volume = parameters.value.exclude_boot_volume
        no_reboot           = parameters.value.no_reboot
      }
    }

    dynamic "schedule" {
      for_each = [each.value.policy_details.schedule]
      content {
        copy_tags = schedule.value.copy_tags
        name      = schedule.value.name

        create_rule {
          cron_expression = schedule.value.create_rule.cron_expression
          interval        = schedule.value.create_rule.interval
          interval_unit   = schedule.value.create_rule.interval_unit
          location        = schedule.value.create_rule.location
          times           = schedule.value.create_rule.times
        }

        dynamic "cross_region_copy_rule" {
          for_each = schedule.value.cross_region_copy_rule != null ? [
            schedule.value.cross_region_copy_rule
          ] : []
          content {
            copy_tags = cross_region_copy_rule.value.copy_tags

            deprecate_rule {
              interval      = cross_region_copy_rule.value.deprecate_rule.interval
              interval_unit = cross_region_copy_rule.value.deprecate_rule.interval_unit
            }

            encrypted = cross_region_copy_rule.value.encrypted

            cmk_arn = cross_region_copy_rule.value.kms_key_arn

            target = cross_region_copy_rule.value.target_arn

            retain_rule {
              interval      = cross_region_copy_rule.value.retain_rule.interval
              interval_unit = cross_region_copy_rule.value.retain_rule.interval_unit
            }
          }
        }

        deprecate_rule {
          count         = schedule.value.deprecate_rule.count
          interval      = schedule.value.deprecate_rule.interval
          interval_unit = schedule.value.deprecate_rule.interval_unit
        }

        fast_restore_rule {

          availability_zones = schedule.value.fast_restore_rule.availability_zones
          count              = schedule.value.fast_restore_rule.count
          interval           = schedule.value.fast_restore_rule.interval
          interval_unit      = schedule.value.fast_restore_rule.interval_unit
        }

        retain_rule {
          count         = schedule.value.retain_rule.count
          interval      = schedule.value.retain_rule.interval
          interval_unit = schedule.value.retain_rule.interval_unit
        }

        dynamic "share_rule" {
          for_each = [schedule.value.share_rule]
          content {
            target_accounts = share_rule.value.target_accounts
            # interval        = share_rule.value.interval
            # interval_unit   = share_rule.value.interval_unit
          }
        }

        tags_to_add   = schedule.value.tags_to_add
        variable_tags = schedule.value.variable_tags
      }
    }
  }

  tags = var.tags
}
