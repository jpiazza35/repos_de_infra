data "aws_iam_policy_document" "provider_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.id}:oidc-provider/${local.condition_oidc_url}"]
    }

    condition {
      test = "ForAllValues:StringEquals"
      values = [
        var.oidc_provider_organization
      ]
      variable = "${local.condition_oidc_url}:aud"
    }
  }
}

resource "aws_iam_role" "provider_role" {
  name               = local.provider_role_fullname
  assume_role_policy = data.aws_iam_policy_document.provider_assume_role.json

  inline_policy {
    name = "${title(var.oidc_provider_name)}AllowKMSScheduleKeyDeletion"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "kms:ScheduleKeyDeletion",
          "Resource" : "*"
        }
      ]
    })
  }

  inline_policy {
    name = "${title(var.oidc_provider_name)}AmazonPollyFullAccess"
    policy = jsonencode({
      "Statement" : [
        {
          "Action" : [
            "polly:*"
          ],
          "Effect" : "Allow",
          "Resource" : [
            "*"
          ]
        }
      ],
      "Version" : "2012-10-17"
    })
  }

  inline_policy {
    name = "${title(var.oidc_provider_name)}ECR"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "ecr:GetRegistryPolicy",
            "ecr:CreateRepository",
            "ecr:DescribeRegistry",
            "ecr:DescribePullThroughCacheRules",
            "ecr:GetAuthorizationToken",
            "ecr:PutRegistryScanningConfiguration",
            "ecr:CreatePullThroughCacheRule",
            "ecr:DeletePullThroughCacheRule",
            "ecr:PutRegistryPolicy",
            "ecr:GetRegistryScanningConfiguration",
            "ecr:BatchImportUpstreamImage",
            "ecr:DeleteRegistryPolicy",
            "ecr:PutReplicationConfiguration"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "VisualEditor1",
          "Effect" : "Allow",
          "Action" : "ecr:*",
          "Resource" : data.aws_ecr_repository.backend_repository.arn
        }
      ]
    })
  }

  inline_policy {
    name = "${title(var.oidc_provider_name)}CloudfrontPermissions"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : "cloudfront:*",
          "Resource" : "*"
        }
      ]
    })
  }

  inline_policy {
    name = "${title(var.oidc_provider_name)}ECSTaskExecutionFargate"
    policy = jsonencode({
      "Statement" : [
        {
          "Action" : [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        }
      ],
      "Version" : "2012-10-17"
    })
  }

  inline_policy {
    name = "${title(var.oidc_provider_name)}ECSTaskExecutionFargateASM"
    policy = jsonencode({
      "Statement" : [
        {
          "Action" : "secretsmanager:GetSecretValue",
          "Effect" : "Allow",
          "Resource" : "*",
          "Sid" : ""
        }
      ],
      "Version" : "2012-10-17"
    })
  }

  inline_policy {
    name = "${title(var.oidc_provider_name)}ECSTaskPolicyImagePull"
    policy = jsonencode({
      "Statement" : [
        {
          "Action" : [
            "ecr:BatchCheckLayerAvailability",
            "ecr:CompleteLayerUpload",
            "ecr:InitiateLayerUpload",
            "ecr:PutImage",
            "ecr:GetAuthorizationToken",
            "ecr:UploadLayerPart",
            "logs:PutLogEvents",
            "logs:GetLogEvents",
            "logs:FilterLogEvents",
            "logs:DescribeLogStreams",
            "logs:DescribeLogGroups",
            "logs:CreateLogStream",
            "logs:CreateLogGroup"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        }
      ],
      "Version" : "2012-10-17"
    })
  }

  inline_policy {
    name = "${title(var.oidc_provider_name)}SSMTaskPolicy"
    policy = jsonencode({
      "Statement" : [
        {
          "Action" : "ssm:GetParameters",
          "Effect" : "Allow",
          "Resource" : "arn:aws:ssm:us-east-1:${data.aws_caller_identity.current.id}:parameter/${var.oidc_environment}/internaltool/*",
          "Sid" : "1"
        }
      ],
      "Version" : "2012-10-17"
    })
  }

  inline_policy {
    name = "${title(var.oidc_provider_name)}TarmacReportsListBucket"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "s3:ListAllMyBuckets",
          "Resource" : "*"
        }
      ]
    })
  }

  inline_policy {
    name = "${title(var.oidc_provider_name)}ECSPermissions"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor1",
          "Effect" : "Allow",
          "Action" : [
            "ecs:*"
          ],
          "Resource" : "*"
        }
      ]
    })
  }

  inline_policy {
    name = "${title(var.oidc_provider_name)}IAMPassrole"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : "iam:PassRole",
          "Resource" : [
            "arn:aws:iam::${data.aws_caller_identity.current.id}:role/FargateTaskRole",
            "arn:aws:iam::${data.aws_caller_identity.current.id}:role/ecs-task-execution-role"
          ]
        }
      ]
    })
  }

  inline_policy {
    name = "${title(var.oidc_provider_name)}S3BucketPolicy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "s3:GetBucketTagging",
            "s3:DeleteObjectVersion",
            "s3:PutObjectVersionTagging",
            "s3:ListBucket",
            "s3:GetBucketVersioning",
            "s3:PutObject",
            "s3:GetObject",
            "s3:PutBucketNotification",
            "s3:ListAllMyBuckets",
            "s3:PutBucketLogging",
            "s3:PutObjectTagging",
            "s3:DeleteObject",
            "s3:GetObjectVersion"
          ],
          "Resource" : "*"
        }
      ]
    })
  }

  tags = local.oidc_provider_tags
}