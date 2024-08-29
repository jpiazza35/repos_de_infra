resource "aws_iam_role" "rds_enhanced_monitoring" {
  count = terraform.workspace == "sharedservices" && var.enhanced_monitoring_role_enabled == true && var.monitoring_interval > 0 ? 1 : 0

  name_prefix = "rds-enhanced-monitoring-"

  assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring[count.index].json
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {

  count = terraform.workspace == "sharedservices" && var.enhanced_monitoring_role_enabled == true && var.monitoring_interval > 0 ? 1 : 0

  role = aws_iam_role.rds_enhanced_monitoring[count.index].name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

data "aws_iam_policy_document" "rds_enhanced_monitoring" {
  count = local.default
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "monitoring.rds.amazonaws.com"
      ]
    }
  }
}
