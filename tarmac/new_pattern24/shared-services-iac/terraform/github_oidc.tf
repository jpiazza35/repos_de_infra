module "ss_github_oidc" { #SS_TOOLS
  source                        = "./modules/github_oidc_aws"
  enabled                       = var.enabled
  github_repositories           = var.github_repositories
  max_session_duration          = var.max_session_duration
  attach_admin_policy           = var.attach_admin_policy
  attach_read_only_policy       = var.attach_read_only_policy
  create_oidc_provider          = var.create_oidc_provider
  force_detach_policies         = var.force_detach_policies
  iam_role_path                 = var.iam_role_path
  iam_role_permissions_boundary = var.iam_role_permissions_boundary
  iam_role_policy_arns          = var.iam_role_policy_arns
  iam_role_inline_policies = merge(
    var.iam_role_inline_policies,
    {
      "github_oidc_policy" : data.aws_iam_policy_document.github[0].json
    }
  )
  iam_role_name = var.iam_role_name
  tags = merge(
    var.tags,
    {
      Environment    = var.env
      App            = "github"
      Resource       = "Managed by Terraform"
      Description    = "Github OIDC Role Config"
      Team           = "DevOps"
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )
}
