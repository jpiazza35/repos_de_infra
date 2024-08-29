module "dwb_sql_endpoint" {
  source = "../modules/sql_warehouse"
  name   = "data-work-bench-sql-endpoint"
  tags   = local.tags
}

module "dwb_endpoint_permissions" {
  source          = "../modules/permissions/sql_warehouse"
  sql_endpoint_id = module.dwb_sql_endpoint.id
  workspace       = terraform.workspace
  additional_service_principal_permissions = [
    {
      service_principal_name = databricks_service_principal.survey-data-workbench-sp.application_id
      permission_level       = "CAN_USE"
    }
  ]
}



resource "aws_s3_bucket_policy" "allow_access_from_eks" {
  bucket = module.survey_template_extracts_bucket.bucket_id

  policy = data.aws_iam_policy_document.allow_access_from_eks.json
}

# DEPRECATED: update any dependent uses to dwb_sql_endpoint vault_path
resource "vault_generic_secret" "dwb_secret" {
  data_json = jsonencode(module.dwb_sql_endpoint)
  path      = "data_platform/${module.workspace_vars.env}/databricks/sql_endpoints/data_work_bench"
}

data "aws_iam_policy_document" "allow_access_from_eks" {
  statement {
    principals {
      type = "AWS"
      identifiers = terraform.workspace == "sdlc" ? [
        for id in local.sdlc_eks_accounts : "arn:aws:iam::${id}:root"
        ] : [
        "arn:aws:iam::${local.prod_eks_account}:root"
      ]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      module.survey_template_extracts_bucket.bucket_arn,
      "${module.survey_template_extracts_bucket.bucket_arn}/*",
    ]
  }
}

resource "aws_kms_key_policy" "eks" {
  key_id = module.survey_template_extracts_bucket.kms_key_id
  policy = jsonencode({
    Id = "kms-key-policy-eks"
    Statement = [
      {
        Action = "kms:Decrypt"
        Effect = "Allow"
        Principal = {
          AWS = terraform.workspace == "sdlc" ? [
            for id in local.sdlc_eks_accounts : "arn:aws:iam::${id}:root"
            ] : [
            "arn:aws:iam::${local.prod_eks_account}:root"
          ]
        }

        Resource = module.survey_template_extracts_bucket.kms_key_arn
        Sid      = "Enable EKS Root Permissions"
      },
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
          ]
        }

        Resource = module.survey_template_extracts_bucket.kms_key_arn
        Sid      = "Enable EKS Deccryption Permissions"
      },
    ]
    Version = "2012-10-17"
  })
}


resource "aws_iam_role" "eks_role" {
  name = "${module.survey_template_extracts_bucket.bucket_id}-eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" = "Allow"
        "Principal" = {
          "Federated" = terraform.workspace == "sdlc" ? [
            for id in local.sdlc_eks_accounts : var.eks_oidc_arn
            ] : [
            var.eks_oidc_arn
          ]
        },
        "Action" = "sts:AssumeRoleWithWebIdentity",
        "Condition" = {
          "StringEquals" : {
            "${var.eks_oidc_provider}:aud" : "sts.amazonaws.com"
          }
        }
      },
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "AssumeRoleForEKS"
        Principal = {
          AWS = terraform.workspace == "sdlc" ? [
            for id in local.sdlc_eks_accounts : "arn:aws:iam::${id}:root"
            ] : [
            "arn:aws:iam::${local.prod_eks_account}:root"
          ]
        }
      },
    ]
  })

  inline_policy {
    name = "kms_decrypt_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["kms:Decrypt"]
          Effect   = "Allow"
          Resource = module.survey_template_extracts_bucket.kms_key_arn
        },
      ]
    })
  }

  inline_policy {
    name = "s3_read_policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:GetObject",
            "s3:ListBucket",
          ]
          Effect = "Allow"
          Resource = [
            module.survey_template_extracts_bucket.bucket_arn,
            "${module.survey_template_extracts_bucket.bucket_arn}/*",
          ]
        },
      ]
    })
  }

}
