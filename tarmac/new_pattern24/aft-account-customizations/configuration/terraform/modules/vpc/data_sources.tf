data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_elb_service_account" "main" {}

### Find Transit Gateway Attachment
data "aws_ec2_transit_gateway" "tgw" {
  filter {
    name = "options.amazon-side-asn"
    values = [
      "64512"
    ]
  }
}

data "aws_route53_resolver_rules" "forwarders" {
  rule_type    = "FORWARD"
  share_status = "SHARED_WITH_ME"
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

data "aws_vpc_endpoint_service" "svc" {
  for_each = {
    for svc in var.vpc_parameters["endpoints"] : svc.service => svc
  }

  service      = lookup(each.value, "service", null)
  service_name = lookup(each.value, "service_name", null)

  filter {
    name   = "service-type"
    values = [lookup(each.value, "service_type", "Interface")]
  }
}

### VPC Flow Logs
# Update bucket policy allowing logging from current AWS accounts in the organization
data "aws_organizations_organization" "current" {
  provider = aws.mgmt
}

data "aws_iam_policy_document" "flow_logging" {

  # Allow organization accounts to write logs to this bucket
  statement {
    sid = "log_write"
    principals {
      type = "Service"
      identifiers = [
        "delivery.logs.amazonaws.com"
      ]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      format("%s/*", data.aws_ssm_parameter.flowlogs.value)
    ]

    # Allow only accounts in the organization
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "aws:SourceAccount"
      values   = data.aws_organizations_organization.current.accounts[*].id
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  # Allow log delivery permissions check for accounts in this organization
  statement {
    sid = "log_verify"
    principals {
      type = "Service"
      identifiers = [
        "delivery.logs.amazonaws.com"
      ]
    }

    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket"
    ]

    resources = [
      data.aws_ssm_parameter.flowlogs.value
    ]

    # Allow only accounts in the organization
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "aws:SourceAccount"
      values   = data.aws_organizations_organization.current.accounts[*].id
    }
  }

  # Allow Taegis to collect logs
  statement {
    sid = "taegis_list"
    principals {
      type        = "AWS"
      identifiers = [local.taegis_vpc_monitor_role]
    }

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]

    resources = [
      data.aws_ssm_parameter.flowlogs.value
    ]
  }

  statement {
    sid = "taegis_collect"
    principals {
      type = "AWS"
      identifiers = [
        local.taegis_vpc_monitor_role
      ]
    }

    actions = [
      "s3:GetObjectAcl",
      "s3:GetObject"
    ]

    resources = [
      format("%s/*", data.aws_ssm_parameter.flowlogs.value)
    ]
  }

}

# Policies and buckets are region specific for elb - Adding us-east-1 only right now
## https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-access-logs.html#attach-bucket-policy
data "aws_iam_policy_document" "elb_logging" {

  # Allow organization accounts to write logs to this bucket
  statement {
    sid = "log_write"
    principals {
      type = "AWS"
      identifiers = [
        data.aws_elb_service_account.main.arn
      ]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      for account in data.aws_organizations_organization.current.accounts[*].id : format("%s/*/%s/*", data.aws_ssm_parameter.elblogs.value, account)
    ]
  }

  statement {
    sid = "log_write2"
    principals {
      type = "Service"
      identifiers = [
        "delivery.logs.amazonaws.com"
      ]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      format("%s/*", data.aws_ssm_parameter.elblogs.value)
    ]

    # Allow only accounts in the organization
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "aws:SourceAccount"
      values   = data.aws_organizations_organization.current.accounts[*].id
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
  }

  # Allow log delivery permissions check for accounts in this organization
  statement {
    sid = "log_verify"
    principals {
      type = "Service"
      identifiers = [
        "delivery.logs.amazonaws.com"
      ]
    }

    actions = [
      "s3:GetBucketAcl"
    ]

    resources = [
      data.aws_ssm_parameter.elblogs.value
    ]

    # Allow only accounts in the organization
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "aws:SourceAccount"
      values   = data.aws_organizations_organization.current.accounts[*].id
    }
  }

  # Allow Taegis to collect logs
  statement {
    sid = "taegis_list"
    principals {
      type = "AWS"
      identifiers = [
        local.taegis_elb_monitor_role
      ]
    }

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]

    resources = [
      data.aws_ssm_parameter.elblogs.value
    ]
  }

  statement {
    sid = "taegis_collect"
    principals {
      type = "AWS"
      identifiers = [
        local.taegis_elb_monitor_role
      ]
    }

    actions = [
      "s3:GetObjectAcl",
      "s3:GetObject"
    ]

    resources = [
      format("%s/*", data.aws_ssm_parameter.elblogs.value)
    ]
  }
}

data "aws_vpc" "vpc" {
  id = aws_vpc.vpc.id
}
