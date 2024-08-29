resource "kubernetes_namespace" "kubernetes_dashboard" {

  metadata {
    name = var.k8s_dashboard_release_namespace
    annotations = {
      name = var.k8s_dashboard_release_namespace
    }

    labels = {
      ns = var.k8s_dashboard_release_namespace
    }
  }
}

resource "kubernetes_service_account" "kubernetes_dashboard" {
  metadata {
    name      = var.k8s_dashboard_release_name
    namespace = kubernetes_namespace.kubernetes_dashboard.id
    annotations = {
      "meta.helm.sh/release-name"      = var.k8s_dashboard_release_name
      "meta.helm.sh/release-namespace" = kubernetes_namespace.kubernetes_dashboard.id
    }
    labels = {
      "app.kubernetes.io/managed-by" = "Helm"
    }
  }
  secret {
    name = var.k8s_dashboard_release_name
  }
  automount_service_account_token = true

}

resource "kubernetes_cluster_role_binding" "kubernetes_dashboard" {
  metadata {
    name = var.k8s_dashboard_release_name
    annotations = {
      "meta.helm.sh/release-name"      = var.k8s_dashboard_release_name
      "meta.helm.sh/release-namespace" = kubernetes_namespace.kubernetes_dashboard.id
    }
    labels = {
      "app.kubernetes.io/managed-by" = "Helm"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = var.k8s_dashboard_release_name
    namespace = kubernetes_namespace.kubernetes_dashboard.id
  }
}

resource "kubernetes_secret" "kubernetes_dashboard" {
  metadata {
    name      = var.k8s_dashboard_release_name
    namespace = kubernetes_namespace.kubernetes_dashboard.id
    annotations = {
      "kubernetes.io/service-account.name" = var.k8s_dashboard_release_name
    }
  }
  type = "kubernetes.io/service-account-token"
}

resource "helm_release" "kubernetes_dashboard" {
  depends_on = [
    kubernetes_namespace.kubernetes_dashboard,
    kubernetes_secret.kubernetes_dashboard
  ]

  name = var.k8s_dashboard_release_name

  repository       = var.k8s_dashboard_chart_repository
  chart            = var.k8s_dashboard_release_name
  version          = var.k8s_dashboard_chart_version
  namespace        = kubernetes_namespace.kubernetes_dashboard.id
  create_namespace = false

  values = [templatefile("${path.module}/templates/kubernetes_dashboard.yml.tpl", {
    prometheus_release_name = var.prometheus_release_name
  })]
}
