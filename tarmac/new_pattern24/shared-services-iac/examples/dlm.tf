## Provides a Data Lifecycle Manager (DLM) lifecycle policy for managing snapshots.
module "dlm" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//dlm?ref=1.0.195"
  env    = "dev"
  tags = {
    "Environment" = "dev"
    "Owner"       = "DevOps"
  }
  dlm = [
    {
      name        = "dlm-lifecycle-ebs-mgmt"
      description = "dlm-lifecycle"
      state       = "ENABLED"
      policy_details = {
        resource_types     = ["VOLUME"]
        resource_locations = ["CLOUD"]                 # "CLOUD" or "OUTPOST"
        policy_type        = "EBS_SNAPSHOT_MANAGEMENT" ## "EBS_SNAPSHOT_MANAGEMENT", "IMAGE_MANAGEMENT", or "EVENT_BASED_POLICY"
        parameters = {
          exclude_boot_volume = false
          no_reboot           = true
        }
        schedule = {
          copy_tags = true
          create_rule = {
            cron_expression = "cron(0 12 * * ? *)" ## required if interval, interval_unit, and times are not set. Run every day at 12:00 PM
          }
          cross_region_copy_rule = {
            copy_tags = true
            deprecate_rule = {
              interval      = 3
              interval_unit = "DAYS"
            }
            target_arn  = "arn:aws:ec2:us-east-2:123456789012:volume/vol-1234567890abcdef0"
            encrypted   = true
            kms_key_arn = "arn:aws:kms:us-east-2:123456789012:key/1234abcd-12ab-34cd-56ef-1234567890ab"
            retain_rule = {
              interval      = 2
              interval_unit = "DAYS"
            }
          }
          name = "Archive after 7 days"
          deprecate_rule = {
            interval      = 3
            interval_unit = "DAYS"
          }
          fast_restore_rule = {
            availability_zones = ["us-east-2a", "us-east-2b"]
            interval           = 2
            interval_unit      = "WEEKS"
          }
          retain_rule = {
            count = 14
          }
          share_rule = {
            target_accounts = ["123456789012"]
            interval        = 24
            interval_unit   = "HOURS"
          }
          tags_to_add = {
            "SnapshotCreator" = "DLM"
          }
        }
      }
      target_tags = {
        Snapshot = "true"
      }
    },
    {
      name        = "dlm-lifecycle-instance-mgmt"
      description = "dlm-lifecycle-instance-mgmt"
      state       = "ENABLED"
      policy_details = {
        resource_types     = ["INSTANCE"]
        resource_locations = ["CLOUD"]
        policy_type        = "IMAGE_MANAGEMENT"
        parameters = {
          exclude_boot_volume = false
          no_reboot           = true
        }
        schedule = {
          copy_tags = true
          create_rule = {
            cron_expression = "cron(0 12 * * ? *)" ## required if interval, interval_unit, and times are not set. Run every day at 12:00 PM
          }
          cross_region_copy_rule = {
            copy_tags = true
            deprecate_rule = {
              interval      = 3
              interval_unit = "DAYS"
            }
            target_arn  = "arn:aws:ec2:us-east-2:123456789012:volume/vol-1234567890abcdef0"
            encrypted   = true
            kms_key_arn = "arn:aws:kms:us-east-2:123456789012:key/1234abcd-12ab-34cd-56ef-1234567890ab"
            retain_rule = {
              interval      = 2
              interval_unit = "DAYS"
            }
          }
          name = "Archive after 7 days"
          deprecate_rule = {
            interval      = 3
            interval_unit = "DAYS"
          }
          fast_restore_rule = {
            availability_zones = ["us-east-2a", "us-east-2b"]
            interval           = 2
            interval_unit      = "WEEKS"
          }
          retain_rule = {
            count = 14
          }
          share_rule = {
            target_accounts = ["123456789012"]
            interval        = 2
            interval_unit   = "DAYS"
          }
        }
        target_tags = {
          Snapshot = "true"
        }
      }
    },
    {
      name        = "dlm-lifecycle-event-based-policy"
      description = "dlm-lifecycle-event-based-policy"
      state       = "ENABLED"
      policy_details = {
        action = {
          name = "event-based-policy"
          cross_region_copy = {
            target_arn = "arn:aws:ec2:us-east-2:123456789012:volume/vol-1234567890abcdef0"
            retain_rule = {
              interval      = 24
              interval_unit = "DAYS"
            }
            encryption_configuration = {
              kms_key_arn = "arn:aws:kms:us-east-2:123456789012:key/1234abcd-12ab-34cd-56ef-1234567890ab"
              encrypted   = true
            }
          }
        }
        event_source = {
          type = "MANAGED_CWE"
          parameters = {
            event_type        = "shareSnapshot"
            snapshot_owner    = ["123456789012"]
            description_regex = "^.*Created for policy: policy-1234567890abcdef0.*$"
          }
        }
        resource_types     = ["VOLUME"]
        resource_locations = ["CLOUD"]
        policy_type        = "EVENT_BASED_POLICY"
        schedule = {
          copy_tags = true
          create_rule = {
            cron_expression = "cron(0 12 * * ? *)" ## required if interval, interval_unit, and times are not set. Run every day at 12:00 PM
          }
          cross_region_copy_rule = {
            copy_tags = true
            deprecate_rule = {
              interval      = 72
              interval_unit = "WEEKS"
            }
            target_arn  = "arn:aws:ec2:us-east-2:123456789012:volume/vol-1234567890abcdef0"
            encrypted   = true
            kms_key_arn = "arn:aws:kms:us-east-2:123456789012:key/1234abcd-12ab-34cd-56ef-1234567890ab"
            retain_rule = {
              interval      = 24
              interval_unit = "DAYS"
            }
          }
          name = "Archive after 7 days"
          deprecate_rule = {
            interval      = 72
            interval_unit = "MONTHS"
          }
          fast_restore_rule = {
            availability_zones = ["us-east-2a", "us-east-2b"]
            interval           = 2
            interval_unit      = "WEEKS"
          }
          retain_rule = {
            count = 14
          }
          share_rule = {
            target_accounts = ["123456789012"]
            interval        = 24
            interval_unit   = "WEEKS"
          }
          tags_to_add = {
            "SnapshotCreator" = "DLM"
          }
        }
        target_tags = {
          Snapshot = "true"
        }
      }
    }
  ]
}
