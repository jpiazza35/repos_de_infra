locals {
  role_name = "${var.env}-${var.name}-storage-role"
}

resource "aws_iam_role" "datalake-s3-bucket-role" {
  name               = local.role_name
  assume_role_policy = data.aws_iam_policy_document.external_data_access_assume.json
}

resource "databricks_storage_credential" "this" {
  count = var.enable_self_trust ? 1 : 0
  name  = "${var.env}-${var.name}-storage-credential"
  aws_iam_role {
    role_arn = aws_iam_role.datalake-s3-bucket-role.arn
  }
  comment = var.comment
}



data "aws_iam_policy_document" "external_data_access_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::414351767826:role/unity-catalog-prod-UCMasterRole-14S5ZJVKOTYTL"]
    }

    dynamic "principals" {
      for_each = var.enable_self_trust ? [1] : []
      content {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.role_name}"]
      }
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = ["ad35a21f-129b-4626-884f-7ee496730a60"]
    }
  }
}
