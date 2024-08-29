locals {
  default = terraform.workspace == "sharedservices" ? 1 : 0

  ## subnets slice for EFS mounts
  selected_subnet_id_0 = element(data.aws_subnets.all[0].ids, 0)
  selected_subnet_id_1 = element(data.aws_subnets.all[0].ids, 1)
  selected_subnet_id_2 = element(data.aws_subnets.all[0].ids, 2)
}

resource "null_resource" "tf_workspace_validator" {
  lifecycle {
    precondition {
      condition     = terraform.workspace == "sharedservices"
      error_message = "SANITY CHECK: This is a sensitive project. Your current workspace is '${terraform.workspace}'. You must be in the 'sharedservices' workspace to apply this terraform."
    }
  }
}

data "aws_iam_policy_document" "github" {
  count = terraform.workspace == "sharedservices" ? 1 : 0
  statement {
    actions = [
      "iam:*",
      "cloudwatch:*",
      "ecs:*",
      "ec2:*",
      "rds:*",
      "secretsmanager:*",
      "acm:*",
      "route53:*",
      "kms:*",
      "s3:*",
      "ssm:*",
      "ecr:*",
      "logs:*",
      "lambda:*",
      "dynamodb:PutItem",
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:DeleteItem",
      "servicediscovery:*",
      "elasticloadbalancing:*",
      "sns:*",
      "autoscaling:*",
      "eks:*",
      "elasticfilesystem:*"
    ]
    resources = ["*"]
  }
}

data "aws_vpc" "vpc" {
  count = local.default
  tags = {
    Name = "primary-vpc"
  }
}

data "aws_subnets" "all" {
  count = local.default
  filter {
    name = "vpc-id"
    values = [
      data.aws_vpc.vpc[count.index].id
    ]
  }
  tags = {
    Layer = "private"
  }
}

data "aws_subnets" "public" {
  count = local.default
  filter {
    name = "vpc-id"
    values = [
      data.aws_vpc.vpc[count.index].id
    ]
  }
  tags = {
    Layer = "public"
  }
}

# PHPIPAM

data "aws_secretsmanager_secret" "secret" {
  count = local.default
  name  = "phpIPAM"
}

data "aws_secretsmanager_secret_version" "secret" {
  count     = local.default
  secret_id = data.aws_secretsmanager_secret.secret[count.index].id
}

# Sonatype

data "aws_secretsmanager_secret" "sonatype_secret" {
  count = local.default
  name  = "sonatype"
}

data "aws_secretsmanager_secret_version" "sonatype_secret_version" {
  count     = local.default
  secret_id = data.aws_secretsmanager_secret.sonatype_secret[count.index].id
}


#permission sets
data "aws_iam_policy_document" "ppmt_api_dev" {
  statement {
    sid       = "Passrole"
    effect    = "Allow"
    resources = ["arn:aws:iam::*:role/sc-*"]
    actions   = ["iam:Passrole"]
  }

  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:aws:s3:::sc-*",
      "arn:aws:s3:::sc-*/*",
    ]

    actions = [
      "s3:*",
      "s3-object-lambda:*",
    ]
  }

  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:aws:iam::*:role/service-role/cwe-role-*",
      "arn:aws:iam::*:policy/service-role/start-pipeline-execution-*",
      "arn:aws:iam::*:role/aws-service-role/codestar-notifications.amazonaws.com/AWSServiceRoleForCodeStarNotifications",
    ]

    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:PassRole",
      "iam:CreatePolicy",
      "iam:DeletePolicy",
      "iam:AttachRolePolicy",
      "iam:CreatePolicyVersion",
      "iam:DeletePolicyVersion",
      "iam:CreateServiceLinkedRole",
      "iam:DeleteServiceLinkedRole",
    ]
  }

  statement {
    sid       = ""
    effect    = "Deny"
    resources = ["*"]
    actions   = ["s3:CreateBucket"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:secretsmanager:*:*:secret:*/ppmt/api/*"]

    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "secretsmanager:GetRandomPassword",
      "secretsmanager:ListSecrets",
    ]
  }
}

data "aws_iam_policy_document" "CNDataScientist" {
  statement {
    sid       = "Statement1"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["secretsmanager:*"]
  }

  statement {
    sid    = "ReadOnly"
    effect = "Allow"

    resources = [
      "arn:aws:s3:::cn-*-rootbucket",
      "arn:aws:s3:::cn-*-rootbucket/*",
    ]

    actions = [
      "s3:Get*",
      "s3:List*",
    ]
  }

  statement {
    sid       = "Put"
    effect    = "Allow"
    resources = ["arn:aws:s3:::*/*"]

    actions = [
      "s3:List*",
      "s3:Get*",
      "s3:PutObject",
      "s3:PutEncryptionConfiguration",
    ]
  }

  statement {
    sid       = "Create"
    effect    = "Allow"
    resources = ["arn:aws:s3:::*"]

    actions = [
      "s3:CreateBucket",
      "s3:List*",
      "s3:Get*",
    ]
  }
}

data "aws_iam_policy_document" "Route53" {
  statement {
    sid    = "Statement1"
    effect = "Allow"

    resources = [
      "arn:aws:route53:::hostedzone/Z004204123F6EY4T2V5AE",
      "arn:aws:route53:::hostedzone/Z0660981SBICARDH3E5I",
      "arn:aws:route53:::hostedzone/Z0058374DHAUF1E6Z6OE",
      "arn:aws:route53:::hostedzone/Z01446973CBAULJKECZL6",
    ]

    actions = [
      "route53:Update*",
      "route53:ChangeResource*",
      "route53:GetHostedZone*",
      "route53:Get*",
      "route53:List*",
    ]
  }

  statement {
    sid       = "Get"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "route53:GetHostedZone*",
      "route53:ListHostedZone*",
    ]
  }
}
data "aws_iam_policy_document" "AWS-Global-ABAC-Dynamic-Access" {
  statement {
    sid       = "globalredshiftdba"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "redshift:*",
      "redshift-data:*",
    ]

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "aws:PrincipalTag/aws-groups"
      values   = ["aws-groups*:17644:*"]
    }
  }

  statement {
    sid       = "viewredshiftmetrics"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["cloudwatch:*"]

    condition {
      test     = "StringLike"
      variable = "cloudwatch:namespace"
      values   = ["*Redshift*"]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "aws:PrincipalTag/aws-groups"

      values = [
        "aws-groups*:17644:*",
        "aws-groups*:25454:*",
      ]
    }
  }

  statement {
    sid    = "edwdev1"
    effect = "Allow"

    resources = [
      "arn:aws:s3:::sc-snowflake-staging",
      "arn:aws:s3:::sc-snowflake-staging/*",
      "arn:aws:s3:::sc-datalake*",
      "arn:aws:s3:::sc-datalake*/*",
    ]

    actions = [
      "s3:GetLifecycleConfiguration",
      "s3:GetBucketTagging",
      "s3:GetInventoryConfiguration",
      "s3:DeleteObjectVersion",
      "s3:GetObjectVersionTagging",
      "s3:ListBucketVersions",
      "s3:GetBucketLogging",
      "s3:RestoreObject",
      "s3:ListBucket",
      "s3:GetAccelerateConfiguration",
      "s3:GetBucketPolicy",
      "s3:GetObjectVersionTorrent",
      "s3:GetObjectAcl",
      "s3:GetEncryptionConfiguration",
      "s3:GetBucketObjectLockConfiguration",
      "s3:GetIntelligentTieringConfiguration",
      "s3:AbortMultipartUpload",
      "s3:GetBucketRequestPayment",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectTagging",
      "s3:GetMetricsConfiguration",
      "s3:GetBucketOwnershipControls",
      "s3:DeleteObject",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketPolicyStatus",
      "s3:ListBucketMultipartUploads",
      "s3:GetObjectRetention",
      "s3:GetBucketWebsite",
      "s3:GetBucketVersioning",
      "s3:GetBucketAcl",
      "s3:GetObjectLegalHold",
      "s3:GetBucketNotification",
      "s3:GetReplicationConfiguration",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectTorrent",
      "s3:PutObjectRetention",
      "s3:GetBucketCORS",
      "s3:GetObjectVersionForReplication",
      "s3:GetBucketLocation",
      "s3:GetObjectVersion",
    ]

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "aws:PrincipalTag/aws-groups"
      values   = ["aws-groups*:25454:*"]
    }
  }

  statement {
    sid       = "edwdev2"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "redshift:describe*",
      "redshift:list*",
    ]

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "aws:PrincipalTag/aws-groups"
      values   = ["aws-groups*:25454:*"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
      "s3:GetAccountPublicAccessBlock",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketPolicyStatus",
      "s3:ListAccessPoints",
      "iam:ListRoles",
    ]
  }
}

data "aws_iam_policy_document" "CNDeveloper" {
  statement {
    sid       = "Statement1"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "dynamodb:*",
      "ec2:*",
      "ecr:*",
      "events:*",
      "iam:GetRole*",
      "iam:ListRole*",
      "lambda:*",
      "s3:*",
      "scheduler:CreateSchedule",
      "scheduler:GetSchedule",
      "scheduler:ListScheduleGroups",
      "scheduler:ListSchedules",
      "scheduler:UpdateSchedule",
      "sqs:*",
      "cloudwatch:GetMetricData",
      "cloudwatch:ListMetrics",
      "logs:PutMetricFilter",
      "logs:DescribeMetricFilters",
      "logs:TestMetricFilter",
    ]
  }

  statement {
    sid       = "PassRole"
    effect    = "Allow"
    resources = ["arn:aws:iam::836442743669:role/form990-role"]
    actions   = ["iam:PassRole"]
  }

  statement {
    sid       = "Logging"
    effect    = "Allow"
    resources = ["arn:aws:logs:us-east-1:836442743669:*"]

    actions = [
      "logs:CreateLogGroup",
      "logs:DescribeLog*",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutRetentionPolicy",
      "logs:GetLogEvents",
      "logs:DescribeLogStreams",
      "logs:FilterLogEvents",
      "logs:GetLogRecord",
      "logs:DescribeLogGroups",
    ]
  }
}

data "aws_iam_policy_document" "databricks_dev" {
  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:aws:s3:::sc-databricks-lake*/*",
      "arn:aws:s3:::sc-databricks-lake*",
    ]

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetLifecycleConfiguration",
      "s3:PutLifecycleConfiguration",
    ]
  }
}

data "aws_iam_policy_document" "datahub_wh_dev" {
  statement {
    sid           = "DenyDefault"
    effect        = "Deny"
    not_resources = ["arn:aws:iam::*:role/sc-*-exec"]

    actions = [
      "iam:PassRole",
      "glue:CreateSecurityConfiguration",
      "glue:DeleteSecurityConfiguration",
    ]
  }

  statement {
    sid       = "RedshiftServerlessExtras"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["redshift-serverless:describe*"]
  }
}

data "aws_iam_policy_document" "datahub_lake_contributor" {
  statement {
    sid       = "S3PermissionsExtra"
    effect    = "Allow"
    resources = ["arn:aws:s3:::sc-*/*"]

    actions = [
      "s3:GetObject",
      "s3:GetObjectTagging",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionTagging",
      "s3:PutObject",
      "s3:PutObjectVersion",
      "s3:PutObjectTagging",
      "s3:PutObjectVersionTagging",
      "s3:DeleteObject",
      "s3:DeleteObjectTagging",
    ]
  }
}

data "aws_iam_policy_document" "aws_infra_prod_ciai_poc" {
  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:aws:s3:::sc-ciai-datalake-poc",
      "arn:aws:s3:::sc-ciai-datalake-poc/*",
    ]

    actions = [
      "s3:GetLifecycleConfiguration",
      "s3:GetBucketTagging",
      "s3:GetInventoryConfiguration",
      "s3:DeleteObjectVersion",
      "s3:GetObjectVersionTagging",
      "s3:ListBucketVersions",
      "s3:GetBucketLogging",
      "s3:RestoreObject",
      "s3:ListBucket",
      "s3:GetAccelerateConfiguration",
      "s3:GetBucketPolicy",
      "s3:GetObjectVersionTorrent",
      "s3:GetObjectAcl",
      "s3:GetEncryptionConfiguration",
      "s3:GetBucketObjectLockConfiguration",
      "s3:GetIntelligentTieringConfiguration",
      "s3:AbortMultipartUpload",
      "s3:GetBucketRequestPayment",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectTagging",
      "s3:GetMetricsConfiguration",
      "s3:GetBucketOwnershipControls",
      "s3:DeleteObject",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketPolicyStatus",
      "s3:ListBucketMultipartUploads",
      "s3:GetObjectRetention",
      "s3:GetBucketWebsite",
      "s3:GetBucketVersioning",
      "s3:GetBucketAcl",
      "s3:GetObjectLegalHold",
      "s3:GetBucketNotification",
      "s3:GetReplicationConfiguration",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectTorrent",
      "s3:PutObjectRetention",
      "s3:GetBucketCORS",
      "s3:GetObjectVersionForReplication",
      "s3:GetBucketLocation",
      "s3:GetObjectVersion",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
      "s3:GetAccountPublicAccessBlock",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketPolicyStatus",
      "s3:ListAccessPoints",
      "iam:ListRoles",
    ]
  }
}

data "aws_iam_policy_document" "AWSServiceCatalogEndUserAccess" {
  statement {
    sid       = "AWSControlTowerAccountFactoryAccess"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "sso:GetProfile",
      "sso:CreateProfile",
      "sso:UpdateProfile",
      "sso:AssociateProfile",
      "sso:CreateApplicationInstance",
      "sso:GetSSOStatus",
      "sso:GetTrust",
      "sso:CreateTrust",
      "sso:UpdateTrust",
      "sso:GetPeregrineStatus",
      "sso:GetApplicationInstance",
      "sso:ListDirectoryAssociations",
      "sso:ListPermissionSets",
      "sso:GetPermissionSet",
      "sso:ProvisionApplicationInstanceForAWSAccount",
      "sso:ProvisionApplicationProfileForAWSAccountInstance",
      "sso:ProvisionSAMLProvider",
      "sso:ListProfileAssociations",
      "sso-directory:ListMembersInGroup",
      "sso-directory:SearchGroups",
      "sso-directory:SearchGroupsWithGroupName",
      "sso-directory:SearchUsers",
      "sso-directory:CreateUser",
      "sso-directory:DescribeGroups",
      "sso-directory:DescribeDirectory",
      "sso-directory:GetUserPoolInfo",
      "controltower:CreateManagedAccount",
      "controltower:DescribeManagedAccount",
      "controltower:DeregisterManagedAccount",
      "s3:GetObject",
      "organizations:describeOrganization",
      "sso:DescribeRegisteredRegions",
    ]
  }
}

data "aws_iam_policy_document" "builddeploy_dev" {
  statement {
    sid    = "Passrole"
    effect = "Allow"

    resources = [
      "arn:aws:iam::*:role/sc-*",
      "arn:aws:secretsmanager:*:*:secret:*",
      "arn:aws:kms:us-east-1:724643956155:key/edf16e9e-2469-4512-b158-109c7910ba7b",
    ]

    actions = [
      "iam:Passrole",
      "secretsmanager:*",
      "kms:decrypt",
    ]
  }

  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:aws:s3:::sc-*",
      "arn:aws:s3:::sc-*/*",
    ]

    actions = [
      "s3:*",
      "s3-object-lambda:*",
    ]
  }

  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:aws:iam::*:role/service-role/cwe-role-*",
      "arn:aws:iam::*:policy/service-role/start-pipeline-execution-*",
      "arn:aws:iam::*:role/aws-service-role/codestar-notifications.amazonaws.com/AWSServiceRoleForCodeStarNotifications",
    ]

    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:PassRole",
      "iam:CreatePolicy",
      "iam:DeletePolicy",
      "iam:AttachRolePolicy",
      "iam:CreatePolicyVersion",
      "iam:DeletePolicyVersion",
      "iam:CreateServiceLinkedRole",
      "iam:DeleteServiceLinkedRole",
    ]
  }

  statement {
    sid       = ""
    effect    = "Deny"
    resources = ["*"]
    actions   = ["s3:CreateBucket"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:lambda:*:*:function:sc-*"]
    actions   = ["lambda:*"]
  }
}

data "aws_iam_policy_document" "datahub_lake_dev" {
  statement {
    sid           = "DenyDefault"
    effect        = "Deny"
    not_resources = ["arn:aws:iam::*:role/sc-*-exec"]

    actions = [
      "iam:PassRole",
      "glue:CreateSecurityConfiguration",
      "glue:DeleteSecurityConfiguration",
    ]
  }

  statement {
    sid       = "PassRolePermissions"
    effect    = "Allow"
    resources = ["arn:aws:iam::*:role/sc-*-exec"]
    actions   = ["iam:PassRole"]
  }

  statement {
    sid       = "S3PermissionsExtra"
    effect    = "Allow"
    resources = ["arn:aws:s3:::sc-*/*"]

    actions = [
      "s3:PutObject",
      "s3:PutObjectVersion",
      "s3:PutObjectTagging",
      "s3:PutObjectVersionTagging",
      "s3:DeleteObject",
      "s3:DeleteObjectTagging",
    ]
  }

  statement {
    sid       = "RedshiftPermissionsExtra"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["redshift:describe*"]
  }
}
