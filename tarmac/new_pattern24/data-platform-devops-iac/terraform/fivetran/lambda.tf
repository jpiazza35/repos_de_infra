module "lambda" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//lambda?ref=1.0.111"

  properties = merge(
    var.lambda,
    {
      variables = { ELB_ARN = module.nlb.arn }
    }
  )
  tags = var.tags

}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.lambda.function_name}-lambda-policy"
  role = module.lambda.lambda_role_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:DescribeTags",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
