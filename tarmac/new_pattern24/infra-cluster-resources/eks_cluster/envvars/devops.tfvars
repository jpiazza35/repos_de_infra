aws_region                 = "us-east-1"
cluster_version            = "1.29"
use_node_group_name_prefix = true
min_size                   = 1
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
asg_metrics_lambda_name    = "lambda-asg-enable-metrics"
asg_metrics_lambda_runtime = "python3.9"

services_cidr = "10.202.28.0/23"

#replace me
environment    = "devops"
instance_types = ["t3.xlarge"]

#auth map
eks_roles = [
  {
    rolearn  = "arn:aws:iam::964608896914:role/AWSReservedSSO_AWSAdministratorAccess_27de45d28707f812"
    groups   = ["system:masters"]
    username = "aws-sso-admin"
  },
  {
    rolearn  = "arn:aws:iam::964608896914:role/AWSReservedSSO_Account_Administrator_0c4eee6da33e281d"
    groups   = ["system:masters"]
    username = "aws-sso-acc-admin"
  }
]

## Vault Auth
## Vault Management
k8s_serviceaccount = "vault-auth"
