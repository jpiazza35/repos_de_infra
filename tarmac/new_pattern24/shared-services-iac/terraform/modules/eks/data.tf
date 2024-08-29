data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

data "aws_subnet" "selected_private_1" {
  filter {
    name   = "tag:Name"
    values = ["primary-vpc-az1-local"] # Replace with your desired subnet name
  }
}

data "aws_subnet" "selected_private_2" {
  filter {
    name   = "tag:Name"
    values = ["primary-vpc-az5-local"] # Replace with your desired subnet name
  }
}

data "aws_subnet" "selected_private_3" {
  filter {
    name   = "tag:Name"
    values = ["primary-vpc-az6-local"] # Replace with your desired subnet name
  }
}

data "aws_iam_policy_document" "asg_metrics_lambda_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "tls_certificate" "eks" {
  url = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

data "aws_iam_roles" "sso_admin" {
  name_regex = ".*AWSReservedSSO_AWSAdministratorAccess.*"
}

