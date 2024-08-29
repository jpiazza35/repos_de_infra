resource "aws_flow_log" "vpc" {
  count           = local.default
  iam_role_arn    = aws_iam_role.vpc[count.index].arn
  log_destination = aws_cloudwatch_log_group.vpc[count.index].arn
  traffic_type    = "ALL"
  vpc_id          = data.aws_vpc.vpc[count.index].id

  tags = merge(
    var.tags
  )
}

resource "aws_cloudwatch_log_group" "vpc" {
  count = local.default
  name  = format("%s-%s-vpc-log-group", var.app, var.env)

  tags = merge(
    var.tags,
    tomap(
      {
        "Name" = format("%s-%s-vpc-log-group", var.app, var.env)
      }
    )
  )
}

resource "aws_iam_role" "vpc" {
  count = local.default
  name  = format("%s-%s-vpc-log-role", var.app, var.env)

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags = merge(
    var.tags,
    tomap(
      {
        "Name" = format("%s-%s-vpc-log-role", var.app, var.env)
      }
    )
  )
}

resource "aws_iam_role_policy" "vpc" {
  count = local.default
  name  = format("%s-%s-vpc-log-policy", var.app, var.env)
  role  = aws_iam_role.vpc[count.index].name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

}
