data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "databricks_aws_assume_role_policy" "assume_policy" {
  provider    = databricks
  external_id = var.databricks_account_id
}

data "databricks_aws_crossaccount_policy" "cross_acct_policy" {
  provider = databricks
}

data "aws_iam_policy_document" "mandatory_tags" {

  # tag errors show up in databricks as:
  # Cloud Provider Launch Failure: A cloud provider error was encountered while setting up the cluster.

  statement {
    sid    = "MandateLaunchWithTeamTag"
    effect = "Deny"
    actions = [
      "ec2:RunInstances",
      "ec2:CreateTags"
    ]
    resources = ["arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:instance/"]
    condition {
      test     = "StringNotEquals"
      values   = ["aws:RequestTag/Team"]
      variable = "Data Platform"
    }
    condition {
      test     = "StringNotEquals"
      values   = ["aws:RequestTag/Team"]
      variable = "DevOps"
    }
    condition {
      test     = "StringNotEquals"
      values   = ["aws:RequestTag/Team"]
      variable = "MPT"
    }
    condition {
      test     = "StringNotEquals"
      values   = ["aws:RequestTag/Team"]
      variable = "Data Science"
    }
    condition {
      test     = "StringNotEquals"
      values   = ["aws:RequestTag/Team"]
      variable = "Consulting"
    }
  }

  statement {
    sid    = "MandateLaunchWithRegionTag"
    effect = "Deny"
    actions = [
      "ec2:RunInstances",
      "ec2:CreateTags"
    ]
    resources = ["arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:instance/"]
    condition {
      test     = "StringNotEquals"
      values   = ["aws:RequestTag/Region"]
      variable = "us-east-1"
    }
    condition {
      test     = "StringNotEquals"
      values   = ["aws:RequestTag/Region"]
      variable = "us-east-2"
    }
  }

  statement {
    sid    = "MandateLaunchWithProjectTag"
    effect = "Deny"
    actions = [
      "ec2:RunInstances",
      "ec2:CreateTags"
    ]
    resources = ["arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:instance/"]
    condition {
      test     = "StringNotEquals"
      values   = ["aws:RequestTag/Project"]
      variable = "?*"
    }
  }

  statement {
    sid    = "MandateLaunchWithRegionTagIndividuals"
    effect = "Deny"
    actions = [
      "ec2:RunInstances",
      "ec2:CreateTags"
    ]
    resources = ["arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:instance/"]
    condition {
      test     = "StringNotEquals"
      values   = ["aws:RequestTag/Individual"]
      variable = "?*"
    }
  }


}

// Configure a simple access policy for the S3 root bucket within your AWS account, so that Databricks can access data in it.
data "databricks_aws_bucket_policy" "db_bucket_policy" {
  bucket = aws_s3_bucket.root_storage_bucket.bucket
}

//Customer Managed Key - KMS
data "aws_iam_policy_document" "databricks_managed_services_and_storage_cmk" {

  version = "2012-10-17"
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        data.aws_caller_identity.current.account_id
      ]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
  statement {
    sid    = "Allow Databricks to use KMS key for control plane managed services"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::414351767826:root"
      ]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "Allow Databricks to use KMS key for DBFS"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::414351767826:root"]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "Allow Databricks to use KMS key for DBFS (Grants)"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::414351767826:root"]
    }
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }
  statement {
    sid    = "Allow Databricks to use KMS key for EBS"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.cross_account_role.arn
      ]
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*",
      "kms:CreateGrant",
      "kms:DescribeKey"
    ]
    resources = ["*"]
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "kms:ViaService"
      values   = ["ec2.*.amazonaws.com"]
    }
  }
}

// Find all groups
data "databricks_group" "admins" {
  provider = databricks
  for_each = toset([
    for g in var.groups["admins"] : g
  ])
  display_name = each.value
}

data "databricks_group" "users" {
  provider = databricks
  for_each = toset([
    for g in var.groups["users"] : g
  ])
  display_name = each.value
}

data "databricks_group" "technical_users" {
  provider = databricks
  for_each = toset([
    for g in var.technical_groups : g

  ])
  display_name = each.value
}

// Azure Config
data "azuread_client_config" "current" {

}

// Get Network Interface IPs for the Workspace VPC Endpoint
data "aws_vpc_endpoint" "databricks" {

  vpc_id       = var.vpc_id
  service_name = aws_vpc_endpoint.workspace.service_name
}

//For Nexla
/* data "aws_network_interface" "databricks_vpce" {
  for_each = data.aws_vpc_endpoint.databricks.network_interface_ids
  id       = each.value
} */

// Azure App Registration
// Get Microsft Graph Components
data "azuread_application_published_app_ids" "graph" {}

data "azuread_service_principal" "msgraph" {
  client_id = data.azuread_application_published_app_ids.graph.result.MicrosoftGraph
}

data "azuread_group" "assignment" {
  for_each = {
    for g in local.ad_group_assignments : g["g"] => g["g"]
  }
  /* {
    for g in flatten(local.ad_group_assignments): keys(g) => g
  } */
  display_name     = each.value
  security_enabled = true
}

data "aws_route53_resolver_endpoint" "rre" {
  provider = aws.ss_network

  filter {
    name   = "Name"
    values = ["outbound"]
  }
}

// Share the Route53 Resolver Rules for the Databricks Workspace
data "aws_organizations_organization" "org" {
  provider = aws.ss_network
}

data "aws_ram_resource_share" "route53_resolver_rules" {
  provider       = aws.ss_network
  name           = "route53-outbound-rules-share"
  resource_owner = "SELF"
}