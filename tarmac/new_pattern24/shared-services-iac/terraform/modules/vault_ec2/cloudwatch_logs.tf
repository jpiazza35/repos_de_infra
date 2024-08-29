data "aws_iam_policy_document" "log_agent" {
  count = local.default

  statement {
    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "logs:PutLogEvents",
    ]

    resources = [
      aws_cloudwatch_log_group.app[count.index].arn,
    ]
  }

  statement {
    actions = var.additional_permissions

    resources = [
      aws_cloudwatch_log_group.app[count.index].arn,
    ]
  }
}

resource "aws_cloudwatch_log_group" "app" {
  count             = local.default
  name              = format("%s-app-logs", var.env)
  retention_in_days = var.retention_in_days

  tags = merge(
    var.tags,
    tomap(
      {
        "Name"           = format("%s-app-logs", var.env)
        "SourcecodeRepo" = "https://github.com/clinician-nexus/shared-services-iac"
      }
    )
  )
}

resource "aws_cloudwatch_log_stream" "default" {

  count          = local.default
  name           = format("%s-app-stream", var.env)
  log_group_name = aws_cloudwatch_log_group.app[count.index].name
}

resource "aws_iam_role" "app" {
  count = local.default

  name               = format("%s-%s-app-log-role", var.app, var.env)
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = merge(
    var.tags,
    tomap(
      {
        "Name"           = format("%s-%s-app-log-role", var.app, var.env)
        "SourcecodeRepo" = "https://github.com/clinician-nexus/shared-services-iac"
      }
    )
  )

}
