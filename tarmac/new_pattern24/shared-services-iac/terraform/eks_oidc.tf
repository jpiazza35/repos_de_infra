module "ss_eks_oidc" { #SS_TOOLS
  source                        = "./modules/eks_oidc_aws"
  enabled                       = var.enabled
  region                        = var.region
  eks_provider_urls             = var.eks_provider_urls
  max_session_duration          = var.max_session_duration
  create_oidc_provider          = var.create_oidc_provider
  force_detach_policies         = var.force_detach_policies
  iam_role_path                 = var.iam_role_path
  iam_role_permissions_boundary = var.iam_role_permissions_boundary
  iam_role_policy_arns          = var.iam_role_policy_arns
  iam_role_name                 = var.iam_role_name

  tags = merge(
    var.tags,
    {
      Environment    = var.env
      App            = "eks"
      Resource       = "Managed by Terraform"
      Description    = "EKS OIDC Role Config"
      Team           = "DevOps"
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )
}
