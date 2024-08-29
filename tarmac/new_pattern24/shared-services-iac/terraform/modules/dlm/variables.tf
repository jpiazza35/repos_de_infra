variable "env" {
  description = "The environment to deploy the dlm module to"
  type        = string
}

variable "tags" {
  description = "tags to attach to the dlm module's resources"
  type        = map(any)
}

variable "dlm" {
  description = "The dlm module to use"
  type = list(object({
    name        = string
    description = string
    policy_details = object({
      ## If you are creating a snapshot or AMI policy, omit this parameter.
      action = optional(object({
        name = optional(string)
        cross_region_copy = optional(object({
          target_arn = string
          retain_rule = object({
            interval      = number
            interval_unit = string
          })
          encryption_configuration = object({
            kms_key_arn = string
            encrypted   = bool
          })
        }))
      }))
      ## If you are creating a snapshot or AMI policy, omit this parameter. 
      event_source = optional(object({
        type = string ## MANAGED_CWE
        parameters = object({
          event_type        = string ## shareSnapshot
          snapshot_owner    = list(string)
          description_regex = string
        })
      }))
      resource_types     = list(string) ## VOLUME, INSTANCE
      resource_locations = list(string) ## CLOUD, OUTPOST
      policy_type        = string       ## EBS_SNAPSHOT_MANAGEMENT, IMAGE_MANAGEMENT, EVENT_BASED_POLICY
      ## If you are creating an event_based_policy, omit this parameter.
      parameters = optional(object({
        exclude_boot_volume = optional(bool)
        no_reboot           = optional(bool)
      }))
      schedule = optional(object({
        copy_tags = optional(bool)
        create_rule = object({
          cron_expression = optional(string) ## conflicts with interval,interval_unit, and times
          interval        = optional(number)
          interval_unit   = optional(string)
          location        = optional(string)
          times           = optional(list(string))
        })
        cross_region_copy_rule = optional(object({
          copy_tags = optional(bool)
          deprecate_rule = optional(object({
            interval      = number
            interval_unit = string ## DAYS, WEEKS, MONTHS, YEARS
          }))
          target_arn  = string
          encrypted   = bool
          kms_key_arn = optional(string)
          retain_rule = optional(object({
            interval      = number
            interval_unit = string
          }))
        }))
        name = string
        deprecate_rule = object({
          count         = optional(number) ## conflicts with interval,interval_unit, and times
          interval      = optional(number)
          interval_unit = optional(string) ## DAYS, WEEKS, MONTHS, YEARS
        })
        fast_restore_rule = object({
          availability_zones = list(string)
          count              = optional(number) ## conflicts with interval and interval_unit
          interval           = optional(number)
          interval_unit      = optional(string) ## DAYS, WEEKS, MONTHS, YEARS
        })
        retain_rule = object({
          count         = optional(number)
          interval      = optional(number)
          interval_unit = optional(string) ## DAYS, WEEKS, MONTHS, YEARS
        })
        share_rule = object({
          target_accounts = list(string)
          interval        = optional(number)
          interval_unit   = optional(string)
        })
        tags_to_add   = optional(map(any))
        variable_tags = optional(map(any)) ## Only $(instance-id) or $(timestamp) are valid values. Can only be used when resource_types is INSTANCE.
      }))
      target_tags = optional(map(any))
    })
    state = string
  }))
}
