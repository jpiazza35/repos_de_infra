resource "aws_cloudwatch_log_group" "main" {
  name = format("%s-%s-ecs-cw-logs", lower(var.cluster["env"]), lower(var.cluster["app"]))

  retention_in_days = coalesce(var.cloudwatch_log_group["log_retention_in_days"], 90)
  kms_key_id        = try(var.cloudwatch_log_group["logs_kms_key"], null)

  tags = merge(
    {
      Name = format("%s-%s-ecs-cw-logs", lower(var.cluster["env"]), lower(var.cluster["app"]))
    },
    var.tags,
    {
      Environment    = var.cluster["env"]
      App            = var.cluster["app"]
      Resource       = "Managed by Terraform"
      Description    = "${var.cluster["app"]} Related Configuration"
      Team           = var.cluster["team"]
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )
}
