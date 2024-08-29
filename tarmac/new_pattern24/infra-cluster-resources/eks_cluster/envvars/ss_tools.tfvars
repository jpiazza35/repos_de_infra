aws_region                 = "us-east-1"
cluster_version            = "1.29"
use_node_group_name_prefix = true
min_size                   = 3
max_size                   = 6
des_size                   = 3
is_eks_api_public          = true
is_eks_api_private         = true
capacity_type              = "ON_DEMAND"
ami_type                   = "AL2_x86_64"
disk_size                  = 50
ebs_csi_addon_version      = "v1.27.0-eksbuild.1"
kube_proxy_addon_version   = "v1.29.0-eksbuild.3"
coredns_addon_version      = "v1.11.1-eksbuild.6"
vault_url                  = "https://vault.cliniciannexus.com:8200"
asg_metrics_lambda_name    = "lambda-asg-enable-metrics"
asg_metrics_lambda_runtime = "python3.9"

services_cidr = "10.202.28.0/23"

#replace me
environment    = "ss"
instance_types = ["c5.4xlarge"]

#auth map
eks_roles = [
  {
    rolearn  = "arn:aws:iam::163032254965:role/AWSReservedSSO_AWSAdministratorAccess_5cbbb788048d298b"
    username = "aws-sso-admin"
    groups   = ["system:masters"]
  },
  {
    rolearn  = "arn:aws:iam::163032254965:role/AWSReservedSSO_CNPowerUserAccess_6cf27681bbefac08"
    username = "aws-sso-acc-admin"
    groups   = ["system:masters"]
  }
]

## Vault Management
k8s_serviceaccount = "vault-auth"

## cert-manager vars

cert_manager_release_namespace = "cert-manager"
cert_manager_release_name      = "cert-manager"
cert_manager_chart_repository  = "https://charts.jetstack.io"
cert_manager_chart_name        = "cert-manager"
cert_manager_chart_version     = "1.12.7"
cert_manager_crds_helm_url     = "https://github.com/cert-manager/cert-manager/releases/download/v1.12.7/cert-manager.crds.yaml"
