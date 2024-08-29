data "aws_iam_instance_profiles" "node" {
  role_name = local.node_role_name[0]
}

data "aws_iam_instance_profile" "node" {
  for_each = data.aws_iam_instance_profiles.node.names
  name     = each.value
}

data "aws_region" "current" {}

data "aws_eks_clusters" "cluster" {}

data "aws_eks_cluster" "cluster" {
  name = local.cluster_name[0]
}

data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

data "aws_caller_identity" "ss_network" {
  provider = aws.ss_network
}

data "aws_iam_policy_document" "external_dns" {

  statement {

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"
      identifiers = [
        "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider}:sub"
      values = [
        "system:serviceaccount:kube-system:external-dns"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider}:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }

  }
}


## Find Node Instance Profile
data "aws_iam_roles" "roles" {
  name_regex = "${element(local.cluster_name, 0)}-worker-node*"
}


## Get Infra Prod Assume Role Policy
data "aws_iam_role" "dns_manager" {
  provider = aws.ss_network
  name     = "dns-manager"
}


data "aws_iam_policy_document" "update_assume_role_policy_eks" {
  depends_on = [
    aws_iam_role.external_dns
  ]

  source_policy_documents = [
    data.aws_iam_role.dns_manager.assume_role_policy
  ]

  statement {
    sid = "TrustCrossAccountRole"

    principals {
      type = "AWS"
      identifiers = [
        local.node_role_arn[0],
      ]
    }
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]
  }

  statement {
    sid = "TrustCrossAccountRole2"

    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.external_dns.arn
      ]
    }
    actions = [
      "sts:AssumeRole",
    ]
  }


  statement {
    sid = "AssumeCrossAccountRole"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.ss_network.account_id}:role/dns-manager"
      ]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}
