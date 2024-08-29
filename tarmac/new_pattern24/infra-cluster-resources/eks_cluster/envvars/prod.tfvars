aws_region                 = "us-east-1"
cluster_version            = "1.29"
min_size                   = 3
max_size                   = 10
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
environment    = "prod"
instance_types = ["m6i.4xlarge"]

#auth map
eks_roles = [
  {
    rolearn  = "arn:aws:iam::071766652168:role/AWSReservedSSO_AWSAdministratorAccess_d65cf6bdfb296011"
    username = "aws-sso-admin"
    groups   = ["system:masters"]
  },
  {
    rolearn  = "arn:aws:iam::071766652168:role/AWSReservedSSO_CNPowerUserAccess_802b4adc637815e3"
    username = "aws-sso-acc-admin"
    groups   = ["system:masters"]
  },
  {
    rolearn  = "arn:aws:iam::071766652168:role/AWSReservedSSO_PowerUserAccess_09851571ce50babd"
    username = "aws-sso-acc-admin-2"
    groups   = ["system:masters"]
  }
]

## Vault Auth
## Vault Management
k8s_serviceaccount = "vault-auth"

