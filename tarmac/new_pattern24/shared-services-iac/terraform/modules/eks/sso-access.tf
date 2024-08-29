resource "kubernetes_cluster_role_binding" "sso_admin" {
  metadata {
    name = "sso-admin-role"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "User"
    name      = var.aws_admin_sso_role_arn
    api_group = "rbac.authorization.k8s.io"
  }

}
