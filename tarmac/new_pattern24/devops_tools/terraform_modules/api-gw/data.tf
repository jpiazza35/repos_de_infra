data "aws_caller_identity" "current" {
}

# Allows access to truststore s3 bucket via VPC endpoint and SSL only
data "template_file" "truststore_vpc_endpoint" {
  template = file("${path.module}/iam_policies/s3_truststore_vpc.json")

  vars = {
    truststore_bucket_arn = element(concat(aws_s3_bucket.api_gw_truststore.*.arn, tolist([""])), 0)
    s3_vpc_endpoint_id    = var.s3_vpc_endpoint_id
    aws_organization_id   = "Your-Org-ID"
    aws_account_id        = data.aws_caller_identity.current.account_id
  }
}

data "template_file" "alb_logs" {
  template = file("${path.module}/iam_policies/s3_alb_logs.json")

  vars = {
    alb_logs_bucket_arn  = element(concat(aws_s3_bucket.alb_logs.*.arn, tolist([""])), 0)
    alb_logs_bucket_name = element(concat(aws_s3_bucket.alb_logs.*.bucket, tolist([""])), 0)
    alb_name             = "${var.tags["Environment"]}-${var.tags["Product"]}-internal-alb"
    s3_vpc_endpoint_id   = var.s3_vpc_endpoint_id
    elb_account_id       = "054676820928"
    #For elb_account_id check https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions
    aws_account_id = data.aws_caller_identity.current.account_id
  }
}

data "template_file" "nlb_logs" {
  template = file("${path.module}/iam_policies/s3_nlb_logs.json")

  vars = {
    nlb_logs_bucket_arn  = element(concat(aws_s3_bucket.nlb_logs.*.arn, tolist([""])), 0)
    nlb_logs_bucket_name = element(concat(aws_s3_bucket.nlb_logs.*.bucket, tolist([""])), 0)
    nlb_name             = "${var.tags["Environment"]}-${var.tags["Product"]}-internal-nlb"
    s3_vpc_endpoint_id   = var.s3_vpc_endpoint_id
    elb_account_id       = "054676820928"
    #For elb_account_id check https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions
    aws_account_id = data.aws_caller_identity.current.account_id
  }
}

# Allows access to CW logs to the API GW IAM role
data "template_file" "cw_logs_api_gw_role" {
  template = file("${path.module}/iam_policies/cw_logs_api_gw_role.json")
}
