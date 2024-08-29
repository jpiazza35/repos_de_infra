locals {
  default = var.enabled ? 1 : 0

  iam_role_name = var.iam_role_name == "" ? format("%s-eks-oidc-custom-role", "shared-services-iac") : var.iam_role_name

  partition = data.aws_partition.current[0].partition
}
