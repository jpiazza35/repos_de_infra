resource "helm_release" "external_dns" {
  count       = var.create == true ? 1 : 0
  name        = var.helm_release
  chart       = var.helm_chart
  repository  = var.helm_repository
  version     = var.chart_version
  namespace   = var.helm_namespace
  max_history = var.max_history

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.external_dns[0].metadata[0].name
  }

  values = [
    templatefile("${path.module}/templates/external_dns.yml",
      {
        dns_role_arn           = aws_iam_role.external_dns.arn #local.node_role_arn[0] 
        ssnetwork_dns_role_arn = "arn:aws:iam::${data.aws_caller_identity.ss_network.account_id}:role/external-dns-role"
        domain_filter          = var.env == "prod" ? format("cliniciannexus.com") : format("%s.cliniciannexus.com", var.env)
        env                    = var.env
      }
    )
  ]
}

resource "kubernetes_service_account" "external_dns" {
  count = var.create == true ? 1 : 0
  metadata {
    name      = var.helm_release
    namespace = var.helm_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.external_dns.arn #local.node_role_arn[0] 
    }
    labels = {
      istio-injection = "enabled"
    }
  }
  secret {
    name = var.helm_release
  }
  automount_service_account_token = true
}

resource "kubernetes_secret" "external_dns" {
  count = var.create == true ? 1 : 0
  metadata {
    name      = var.helm_release
    namespace = var.helm_namespace
    annotations = {
      "kubernetes.io/service-account.name"      = var.helm_release
      "kubernetes.io/service-account.namespace" = var.helm_namespace
    }
  }
  type = "kubernetes.io/service-account-token"
}
