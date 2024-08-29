# module "external_secrets" {
#   source             = "./modules/vault_external_secrets"
#   k8s_serviceaccount = var.k8s_serviceaccount
#   vault_url          = var.vault_url
#   env                = var.env
#   eks_cluster_name   = var.eks_cluster_name
# }
