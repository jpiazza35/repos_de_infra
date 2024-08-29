################################################################################
# EKS Module
################################################################################

module "eks_mgmt" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//eks?ref=1.0.191"

  services_cidr      = var.services_cidr
  vpc_id             = data.aws_vpc.aws-vpc.id
  private_subnet_ids = data.aws_subnets.private_subnets.ids
  local_subnet_ids   = data.aws_subnets.local_subnets.ids
  aws_region         = var.aws_region
  cluster_name       = local.cluster_name
  environment        = var.environment

  use_node_group_name_prefix = var.use_node_group_name_prefix

  cluster_version    = var.cluster_version
  is_eks_api_public  = var.is_eks_api_public
  is_eks_api_private = var.is_eks_api_private

  ami_type                 = var.ami_type
  disk_size                = var.disk_size
  ebs_csi_addon_version    = var.ebs_csi_addon_version
  coredns_addon_version    = var.coredns_addon_version
  kube_proxy_addon_version = var.kube_proxy_addon_version

  min_size = var.min_size
  max_size = var.max_size
  des_size = var.des_size

  acc_id         = [data.aws_caller_identity.current.account_id]
  eks_roles      = var.eks_roles
  instance_types = var.instance_types
  capacity_type  = var.capacity_type

  aws_admin_sso_role_arn = local.sso_role_arn[0]

}

resource "null_resource" "kubectl_update" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.aws_region} --name ${local.cluster_name}"
  }
  depends_on = [module.eks_mgmt]
}


# resource "random_string" "random_string" {
#   length  = 6
#   special = false
# }
