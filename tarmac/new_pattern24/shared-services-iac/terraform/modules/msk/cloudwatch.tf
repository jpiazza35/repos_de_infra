resource "aws_cloudwatch_log_group" "cw" {
  count = var.create && var.create_cloudwatch_log_group ? 1 : 0

  name              = coalesce(var.cloudwatch_log_group_name, "/aws/msk/${var.name}")
  retention_in_days = var.cloudwatch_log_group_retention_in_days
  kms_key_id        = var.cloudwatch_log_group_kms_key_id

  tags = merge(
    var.tags,
    {
      Name = coalesce(var.cloudwatch_log_group_name, "/aws/msk/${var.name}")
    }
  )
}
