data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_ec2_transit_gateway" "tgw" {
  id = var.org_tgw_id
}

data "aws_route53_resolver_rules" "forwarders" {
  rule_type    = "FORWARD"
  share_status = "SHARED_BY_ME"
}

data "aws_route53_resolver_rule" "forwarders" {
  for_each         = data.aws_route53_resolver_rules.forwarders.resolver_rule_ids
  resolver_rule_id = each.value
}

data "aws_ssm_parameter" "flowlogs" {
  name     = "/config/logging/flowlogs-arn"
  provider = aws.logs
}

data "aws_ssm_parameter" "elblogs" {
  name     = "/config/logging/elblogs-arn"
  provider = aws.logs
}

data "aws_arn" "flowlogs" {
  arn = data.aws_ssm_parameter.flowlogs.value
}

data "aws_arn" "elblogs" {
  arn = data.aws_ssm_parameter.elblogs.value
}

data "aws_iam_policy_document" "kms_key" {
  count = var.name == "primary-vpc" ? 1 : 0
  statement {
    sid       = "Enable IAM User Permissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
  }

  statement {
    sid    = "Enable Delivery Service Permissions"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }

  statement {
    sid    = "Enable Logs Service Permissions"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
    }
  }
}

data "aws_s3_bucket" "flowlogs" {
  bucket = format("cn-flow-logs-%s-%s", data.aws_caller_identity.current.account_id, data.aws_region.current.name)
}

data "aws_vpc_endpoint_service" "svc" {
  for_each = var.name == "primary-vpc" ? {
    for svc in var.endpoints : svc.service => svc
  } : {}

  service      = lookup(each.value, "service", null)
  service_name = lookup(each.value, "service_name", null)

  filter {
    name   = "service-type"
    values = [lookup(each.value, "service_type", "Interface")]
  }
}
