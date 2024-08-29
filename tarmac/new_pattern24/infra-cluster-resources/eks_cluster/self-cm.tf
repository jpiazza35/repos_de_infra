### configmap with information about the cluster for k8s repo

resource "kubernetes_config_map" "self_cm" {
  metadata {
    name      = "cluster"
    namespace = "default"
  }
  data = {
    cluster_name     = local.cluster_name
    cluster_oidc     = local.oidc_provider
    cluster_oidc_url = module.eks_mgmt.cluster_oidc_issuer_url
    cluster_endpoint = module.eks_mgmt.cluster_endpoint
    cluster_id       = module.eks_mgmt.cluster_id
    aws_account_id   = data.aws_caller_identity.current.account_id
    environment      = var.environment
  }
}