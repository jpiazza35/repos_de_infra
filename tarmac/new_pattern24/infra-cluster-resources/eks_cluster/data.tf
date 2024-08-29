### aws account

data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

### vpc

data "aws_vpc" "aws-vpc" {
  tags = {
    Name = "primary-vpc"
  }
}

output "vpc_id" {
  value = data.aws_vpc.aws-vpc.id
}

### Subnet

data "aws_subnets" "private_subnets" {
  filter {
    name   = "tag:Layer"
    values = ["private"]
  }
}

data "aws_subnets" "local_subnets" {
  filter {
    name   = "tag:Layer"
    values = ["local"]
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "tag:Layer"
    values = ["public"]
  }
}

output "private_subnet_id" {
  value = data.aws_subnets.private_subnets.ids
}

output "local_subnet_id" {
  value = data.aws_subnets.local_subnets.ids
}

data "aws_iam_roles" "sso_admin" {
  name_regex = ".*AWSReservedSSO_AWSAdministratorAccess.*"
}

data "aws_eks_cluster_auth" "cluster-auth" {
  depends_on = [module.eks_mgmt]
  name       = local.cluster_name
}

data "vault_generic_secret" "env_vault_token" {
  path = "${var.environment}/external-secrets/vault"
}

data "aws_partition" "current" {}
