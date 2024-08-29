resource "aws_iam_service_linked_role" "open_search" {
  count = var.create_opensearch ? 1 : 0

  aws_service_name = "es.amazonaws.com"
  description      = "AWSServiceRoleForAmazonOpenSearchService Service-Linked Role"
}

# Role to assume for access opensearch
resource "aws_iam_role" "open_search" {
  count = var.create_opensearch ? 1 : 0

  name               = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-elk-iam-role"
  assume_role_policy = data.template_file.assume_role.rendered
  description        = "IAM Role to assume, to access the OpenSearch ${element(concat(aws_elasticsearch_domain.open_search.*.domain_name, tolist([""])), 0)} cluster."

  tags = var.tags
}

# Role for sending CloudTrail logs into OpenSearch
resource "aws_iam_role" "lambda_os" {
  count = var.send_cloudtrail_logs ? 1 : 0

  name               = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-lambda-opensearch"
  assume_role_policy = var.assume_lambda_role_policy
  description        = "IAM Role used to send alerts/notifications to the OpenSearch ${element(concat(aws_elasticsearch_domain.open_search.*.domain_name, tolist([""])), 0)} cluster."

  tags = var.tags
}

resource "aws_iam_policy" "lambda_os" {
  count = var.send_cloudtrail_logs ? 1 : 0

  name        = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-lambda-opensearch"
  description = "This policy is used to send alerts/notifications to OpenSearch."
  path        = "/"
  policy      = element(concat(data.template_file.lambda_os.*.rendered, tolist([""])), 0)

  tags = var.tags
}


resource "aws_iam_role_policy_attachment" "lambda_os" {
  count = var.send_cloudtrail_logs ? 1 : 0

  role       = element(concat(aws_iam_role.lambda_os.*.name, tolist([""])), 0)
  policy_arn = element(concat(aws_iam_policy.lambda_os.*.arn, tolist([""])), 0)
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  count = var.send_cloudtrail_logs ? 1 : 0

  role       = element(concat(aws_iam_role.lambda_os.*.name, tolist([""])), 0)
  policy_arn = data.aws_iam_policy.lambda_vpc_access.arn
}

resource "aws_iam_role" "cloudtrail_cw_logs" {
  count = var.send_cloudtrail_logs ? 1 : 0
  name  = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-cloudtrail-cw-logs-role"
  path  = "/"

  assume_role_policy = data.template_file.assume_cloudtrail.rendered
}
