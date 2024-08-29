data "aws_iam_policy_document" "main" {
  statement {
    sid = "${var.app}LogGroups"
    actions = [
      "logs:CreateLogGroup",
      "logs:DescribeLogStreams"
    ]
    effect = "Allow"
    resources = [
      format(
        "arn:%s:logs:%s:%s:log-group:/aws/apigateway/%s:log-stream:",
        data.aws_partition.current.partition,
        data.aws_region.current.name,
        data.aws_caller_identity.current.account_id,
        var.app
      )
    ]
  }
  statement {
    sid = "${var.app}LogStreams"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    effect = "Allow"
    resources = [
      format(
        "arn:%s:logs:%s:%s:log-group:/aws/apigateway/%s:log-stream:*",
        data.aws_partition.current.partition,
        data.aws_region.current.name,
        data.aws_caller_identity.current.account_id,
        var.app
      )
    ]
  }
  statement {
    sid = "LogGroups"
    actions = [
      "logs:CreateLogGroup",
      "logs:DescribeLogGroups",
      "logs:FilterLogEvents"
    ]
    effect = "Allow"
    resources = [
      format(
        "arn:%s:logs:%s:%s:log-group:/aws/api-gateway/logs_*",
        data.aws_partition.current.partition,
        data.aws_region.current.name,
        data.aws_caller_identity.current.account_id
      )
    ]
  }
  statement {
    sid = "LogStreams"
    actions = [
      "logs:DescribeLogStreams",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:GetLogEvents"
    ]
    effect = "Allow"
    resources = [
      format(
        "arn:%s:logs:%s:%s:log-group:/aws/api-gateway/logs_*:log-stream:*",
        data.aws_partition.current.partition,
        data.aws_region.current.name,
        data.aws_caller_identity.current.account_id
      )
    ]
  }
}

