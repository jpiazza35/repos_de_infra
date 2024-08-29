data "aws_iam_policy_document" "aws_data_platform" {
  statement {
    actions = [
      "ecr:*", "s3:*", "rds:*", "iam:*", "athena:*", "logs:*",
      "dynamodb:*", "dax:*", "autoscaling:*", "ebs:*", "ecs:*", "events:*",
      "schemas:*", "glue:*", "kinesis:*", "kms:*", "lambda:*", "sqs:*",
      "kafka:*", "redshift:*", "s3-object-lambda:*", "sns:*",
    ]
    resources = ["*"]
  }
}

