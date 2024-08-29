data "aws_caller_identity" "current" {}

data "aws_region" "current" {
  name = "us-east-2"
}

## VPC must use the sca.local dhcp option set
data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"
    values = [
      "primary-vpc"
    ]
  }
}

data "aws_subnets" "private" {
  filter {
    name = "tag:Layer"
    values = [
      "private"
    ]
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

data "vault_generic_secret" "ds_password" {
  path = "devops/networking/aws_ds"
}

data "aws_iam_policy_document" "workspaces" {

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["workspaces.amazonaws.com"]
    }
  }

}

### Workspace Bundles ## aws workspaces describe-workspace-bundles --owner AMAZON --query "Bundles[*].[Name, BundleId]"

## Windows
data "aws_workspaces_bundle" "standard_windows" {
  owner = "AMAZON"
  name  = "Standard with Windows 10 (Server 2019 based)" #"Value with Windows 10 (Server 2019 based)"

}

## Linux
data "aws_workspaces_bundle" "standard_linux" {

  owner = "AMAZON"
  name  = "Standard with Ubuntu 22.04" #"Value with Ubuntu 22.04"

}
