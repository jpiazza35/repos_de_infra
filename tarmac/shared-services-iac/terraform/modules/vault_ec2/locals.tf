locals {
  default          = var.env == "shared_services" ? 1 : 0
  lt_name          = "lt-${var.app}-${var.env}-"
  asg_name         = "asg-${var.app}-${var.env}"
  sns_name         = "sns-${var.app}-${var.env}"
  sns_display_name = "${title(var.app)} ${title(var.env)} ASG SNS Topic"

  arch_version = {
    "amd64" = "amd64"
    "arm64" = "arm64"
  }

  dashboard = {
    start          = "-PT4H"
    end            = null
    periodOverride = null
    widgets = [
      {
        x = 6
        y = 0

        type = "metric"
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCountPerTarget", "TargetGroup", "target_group_name"]
          ]
          view     = "timeSeries"
          stacked  = false
          region   = data.aws_region.current[0].name
          title    = "RequestsPerTarget (1 min sum)"
          period   = 60
          stat     = "Sum"
          liveData = false
        }
      }
    ]
  }
}
