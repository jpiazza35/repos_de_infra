## lambda role

resource "aws_iam_role" "lambda_role" {
  name               = "${var.asg_metrics_lambda_name}-role"
  assume_role_policy = data.aws_iam_policy_document.asg_metrics_lambda_assume_policy.json
}

## lambda policy

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.asg_metrics_lambda_name}-policy"
  description = "Policy for Lambda to enable metrics"

  policy = file("${path.module}/files/lambda-policy.json")
}

## lambda policy attachment

resource "aws_iam_policy_attachment" "attach_lambda_policy" {
  name       = "${var.asg_metrics_lambda_name}-policy-attachment"
  policy_arn = aws_iam_policy.lambda_policy.arn
  roles      = [aws_iam_role.lambda_role.name]
}

resource "aws_iam_policy_attachment" "attach_execution_policy" {
  name       = "${var.asg_metrics_lambda_name}-attach-VPC-execution-policy"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  roles      = [aws_iam_role.lambda_role.name]
}

## lambda function

resource "aws_lambda_function" "lambda_function" {
  #checkov:skip=CKV_AWS_272: "Skipping this because it will be removed once the issue https://github.com/aws/containers-roadmap/issues/762 is resolved"
  #checkov:skip=CKV_AWS_50: "Skipping this because it will be removed once the issue https://github.com/aws/containers-roadmap/issues/762 is resolved"
  ##checkov:skip=CKV_AWS_116: "Skipping this because for the same reason"
  reserved_concurrent_executions = 5
  function_name                  = "asg-enable-metrics-collection"
  filename                       = "${path.module}/files/function.zip"
  source_code_hash               = filebase64sha256("${path.module}/files/function.zip")
  role                           = aws_iam_role.lambda_role.arn

  handler = "lambda-handler.lambda_handler"
  runtime = var.asg_metrics_lambda_runtime
  timeout = 600

  vpc_config {

    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.lambda_sg.id]

  }

}

## lambda event source mapping

resource "aws_cloudwatch_event_rule" "create_nodegroup_rule" {
  name        = "CreateNodegroupRuleToLambda"
  description = "Rule to trigger Lambda on EKS CreateNodegroup event"

  event_pattern = jsonencode({
    source      = ["aws.eks"],
    detail_type = ["AWS API Call via CloudTrail"],
    detail = {
      eventName   = ["CreateNodegroup"],
      eventSource = ["eks.amazonaws.com"]
    }
  })
}

## lambda target 

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.create_nodegroup_rule.name
  target_id = "1"
  arn       = aws_lambda_function.lambda_function.arn
}

resource "aws_lambda_permission" "event_rule_invoke_permission" {
  statement_id  = "CreateNodegroupRuleToLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.create_nodegroup_rule.arn
}

### lambda SG for checkov

resource "aws_security_group" "lambda_sg" {
  description = "Security group for lambda function"
  vpc_id      = var.vpc_id
  name        = "${var.asg_metrics_lambda_name}-sg"

  ingress {
    description = "Allow inbound TCP from private network"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}