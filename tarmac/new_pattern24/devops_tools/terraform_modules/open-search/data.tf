data "aws_caller_identity" "current" {
}

data "template_file" "assume_role" {
  template = file("${path.module}/iam_policies/assume_role.json")
}

data "template_file" "open_search" {
  count = var.create_opensearch ? 1 : 0

  template = file("${path.module}/iam_policies/os.json")
  vars = {
    open_search_domain_name = element(concat(aws_elasticsearch_domain.open_search.*.domain_name, tolist([""])), 0)
    logging_aws_account_id  = data.aws_caller_identity.current.account_id
  }
}

data "template_file" "lambda_os" {
  count = var.send_cloudtrail_logs ? 1 : 0

  template = file("${path.module}/iam_policies/os_cw.json")
  vars = {
    open_search_domain_name = var.open_search_domain_name
    logging_aws_account_id  = var.logging_aws_account_id
  }
}

data "aws_iam_policy" "lambda_vpc_access" {
  name = "AWSLambdaVPCAccessExecutionRole"
}

data "template_file" "s3_access_trail_logs" {
  template = file("${path.module}/iam_policies/s3-cloud-trail-logs.json")
  vars = {
    aws_account_id     = data.aws_caller_identity.current.account_id
    s3_trail_logs      = element(concat(aws_s3_bucket.s3_cloud_trail_logs.*.arn, tolist([""])), 0)
    s3_vpc_endpoint_id = var.s3_vpc_endpoint_id
  }
}

data "template_file" "assume_cloudtrail" {
  template = file("${path.module}/iam_policies/assume-cloudtrail.json")
}

data "template_file" "cloudtrail_cw_logs" {
  template = file("${path.module}/iam_policies/cloudtrail-cw-logs.json")
  vars = {
    aws_account_id    = data.aws_caller_identity.current.account_id
    region            = var.region
    cw_log_group_name = element(concat(aws_cloudwatch_log_group.os_cloud_trail_logs.*.name, tolist([""])), 0),

  }
}
