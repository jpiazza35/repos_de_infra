module "mgmt" {
  providers = {
    aws.source = aws
    aws.target = aws
  }
  source                         = "./modules/vault_mgmt"
  env                            = "shared_services"
  paths                          = var.paths
  cluster_name                   = var.cluster_name
  k8s_serviceaccount             = var.k8s_serviceaccount
  k8s_cert_issuer_serviceaccount = var.k8s_cert_issuer_serviceaccount
}
