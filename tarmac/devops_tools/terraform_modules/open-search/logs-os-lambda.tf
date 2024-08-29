data "archive_file" "logs_to_os_zip" {
  count = var.send_cloudtrail_logs ? 1 : 0

  type        = "zip"
  source_file = "${path.module}/lambdas/logs_to_opensearch.js"
  output_path = "${path.module}/lambdas/logs_to_opensearch.zip"
}

resource "aws_lambda_function" "logs_to_os" {
  count = var.send_cloudtrail_logs ? 1 : 0

  filename         = element(concat(data.archive_file.logs_to_os_zip.*.output_path, tolist([""])), 0)
  source_code_hash = element(concat(data.archive_file.logs_to_os_zip.*.output_base64sha256, tolist([""])), 0)
  function_name    = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-logs-to-opensearch"

  role    = element(concat(aws_iam_role.lambda_os.*.arn, tolist([""])), 0)
  handler = "logs_to_opensearch.handler"

  timeout = 60

  runtime = "nodejs14.x"

  description = "Script that forwards cloudwatch logs to OpenSearch"

  vpc_config {
    subnet_ids = var.private_subnets
    security_group_ids = [
      aws_security_group.os_lambdas[count.index].id
    ]
  }

  environment {
    variables = {
      OPENSEARCH_ENDPOINT = var.open_search_domain_endpoint
    }
  }

  tags = {
    Environment        = "${var.tags["Environment"]}"
    ManagedByTerraform = "true"
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_os,
    aws_iam_role_policy_attachment.lambda_vpc_access,
  ]
}

resource "aws_lambda_permission" "logs_to_os" {
  count = var.send_cloudtrail_logs ? 1 : 0

  action        = "lambda:InvokeFunction"
  function_name = element(concat(aws_lambda_function.logs_to_os.*.function_name, tolist([""])), 0)
  principal     = "logs.eu-central-1.amazonaws.com"
  source_arn    = "${element(concat(aws_cloudwatch_log_group.os_cloud_trail_logs.*.arn, tolist([""])), 0)}:*"

}