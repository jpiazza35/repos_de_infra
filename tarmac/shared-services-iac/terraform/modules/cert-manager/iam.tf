## Cert Manager
resource "aws_iam_role" "cert_manager" {
  name                  = format("%s-cert-manager-role", lower(local.cluster_name[0]))
  assume_role_policy    = data.aws_iam_policy_document.cert_manager.json
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "cert_manager" {
  role       = aws_iam_role.cert_manager.id
  policy_arn = aws_iam_policy.cert_manager.arn
}

resource "aws_iam_policy" "cert_manager" {
  name   = format("%s-cert-manager-policy", lower(local.cluster_name[0]))
  path   = "/"
  policy = data.aws_iam_policy_document.cert_manager_permissions.json
}

data "aws_iam_policy_document" "cert_manager_permissions" {

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
    sid = "certmanager"
    actions = [
      "sts:AssumeRole"
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.ss_network.account_id}:role/dns-manager"
    ]
  }
}
