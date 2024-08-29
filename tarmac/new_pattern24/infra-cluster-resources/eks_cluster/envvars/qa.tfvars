aws_region                 = "us-east-1"
cluster_version            = "1.29"
min_size                   = 3
max_size                   = 5
des_size                   = 3
is_eks_api_public          = true
is_eks_api_private         = true
capacity_type              = "ON_DEMAND"
ami_type                   = "AL2_x86_64"
disk_size                  = 30
ebs_csi_addon_version      = "v1.27.0-eksbuild.1"
kube_proxy_addon_version   = "v1.29.0-eksbuild.3"
coredns_addon_version      = "v1.11.1-eksbuild.6"
vault_url                  = "https://vault.cliniciannexus.com:8200"
use_node_group_name_prefix = true
asg_metrics_lambda_name    = "lambda-asg-enable-metrics"
asg_metrics_lambda_runtime = "python3.9"

services_cidr = "10.202.28.0/23"

#replace me
environment    = "qa"
instance_types = ["m6i.xlarge"]

#auth map
eks_roles = [
  {
    rolearn  = "arn:aws:iam::063890802877:role/AWSReservedSSO_AWSAdministratorAccess_744f002ac69e113e"
    username = "aws-sso-admin"
    groups   = ["system:masters"]
  },
  {
    rolearn  = "arn:aws:iam::063890802877:role/AWSReservedSSO_CNPowerUserAccess_d1eab0d26e051a3e"
    username = "aws-sso-acc-admin"
    groups   = ["system:masters"]
  }
]

## Vault Auth
## Vault Management
k8s_serviceaccount = "vault-auth"
