## External DNS
resource "aws_iam_role" "external_dns" {
  name                  = format("%s-external-dns-role", lower(local.cluster_name[0]))
  assume_role_policy    = data.aws_iam_policy_document.external_dns.json
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "external_dns" {
  role       = aws_iam_role.external_dns.id
  policy_arn = aws_iam_policy.external_dns.arn
}

resource "aws_iam_policy" "external_dns" {
  name   = format("%s-external-dns-policy", lower(var.cluster_name))
  path   = "/"
  policy = data.aws_iam_policy_document.external_dns_permissions.json
}

data "aws_iam_policy_document" "external_dns_permissions" {

  statement {
    actions = [
      "route53:GetChange",
    ]

    resources = [
      "arn:aws:route53:::change/*",
    ]
  }

  statement {
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets"
    ]

    resources = [
      "arn:aws:route53:::hostedzone/*"
    ]
  }

  statement {
    actions = [
      "route53:ListHostedZonesByName",
      "route53:ListHostedZones"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "sts:AssumeRole"
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.ss_network.account_id}:role/external-dns-role"
    ]
  }
}

//Update SS_NETWORK DNS Role with the arn of this IRSA Role
resource "null_resource" "add_worker_node_assume_role_policy" {
  depends_on = [
    data.aws_iam_policy_document.update_assume_role_policy_eks
  ]

  provisioner "local-exec" {
    command = "sleep 5;aws iam update-assume-role-policy --role-name external-dns-role --policy-document '${self.triggers.updated_policy_json}' --profile ss_network"
  }

  triggers = {
    updated_policy_json = (
      replace
      (
        replace(
        data.aws_iam_policy_document.update_assume_role_policy_eks.json, "\n", ""), " ", ""
      )
    )
    "after" = sha256(aws_iam_role.external_dns.assume_role_policy)
  }
}

