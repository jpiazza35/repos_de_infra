data "aws_caller_identity" "current" {}
data "aws_region" "current" {}


data "aws_iam_policy_document" "msk" {
  statement {
    sid       = "cluster"
    effect    = "Allow"
    resources = [module.msk.arn]

    actions = [
      "kafka-cluster:Connect",
      "kafka-cluster:AlterCluster",
      "kafka-cluster:DescribeCluster",
      "kafka-cluster:WriteDataIdempotently"
    ]
  }

  statement {
    sid    = "data"
    effect = "Allow"
    resources = [
      "arn:aws:kafka:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:topic/msk/*"
    ]

    actions = [
      "kafka-cluster:*Topic*",
      "kafka-cluster:CreateTopic",
      "kafka-cluster:ReadData",
      "kafka-cluster:WriteData"
    ]
  }

  statement {
    sid       = "group"
    effect    = "Allow"
    resources = ["arn:aws:kafka:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:group/msk/*"]

    actions = [
      "kafka-cluster:AlterGroup",
      "kafka-cluster:DescribeGroup",
    ]
  }

  statement {
    sid    = "List"
    effect = "Allow"
    resources = [
      "arn:aws:kafka:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/*",
    ]
    actions = [
      "kafka:Describe*",
      "kafka:Get*",
      "kafka:List*"
    ]
  }

  statement {
    sid    = "Listv1"
    effect = "Allow"
    resources = [
      "arn:aws:kafka:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:/v1/clusters*",
    ]
    actions = [
      "kafka:Describe*",
      "kafka:Get*",
      "kafka:List*"
    ]
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
        "arn:aws:iam::163032254965:root", ##Self-Hosted Runners
        "arn:aws:iam::${var.databricks_account_id}:root",
        "arn:aws:iam::${var.eks_account_id}:root" ## EKS Account allowing DWB access
      ]
    }
  }
}

data "aws_iam_policy_document" "assume_role_policy_stage" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
        "arn:aws:iam::163032254965:root", ##Self-Hosted Runners
        "arn:aws:iam::${var.databricks_account_id}:root",
        "arn:aws:iam::${var.eks_account_id}:root",   ## EKS Account allowing DWB access
        "arn:aws:iam::${var.qa_eks_account_id}:root" ## QA EKS Account allowing DWB access
      ]
    }
  }
}
