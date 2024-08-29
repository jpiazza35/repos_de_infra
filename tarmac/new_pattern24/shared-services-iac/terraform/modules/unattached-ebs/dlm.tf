module "dlm" {
  source = "../dlm"
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
        resource_locations = ["CLOUD"]
        policy_type        = "EBS_SNAPSHOT_MANAGEMENT"
        parameters = {
          exclude_boot_volume = false
          no_reboot           = true
        }
        schedule = {
          copy_tags = true

          create_rule = {
            cron_expression = "cron(0 12 * * ? *)"
          }

          name = "Archive after 7 days"

          deprecate_rule = {
            interval      = 3
            interval_unit = "DAYS"
          }

          fast_restore_rule = {
            availability_zones = ["us-west-1a", "us-west-1b"]
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
  ]

}
