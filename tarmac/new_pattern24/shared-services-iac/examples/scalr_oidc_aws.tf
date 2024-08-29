module "scalr_oidc" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//scalr_oidc_aws?ref=v1.0.0"
  scalr_env = [
    "DevOps/Security", ## scalr_environment/scalr_workspace
    "DevOps/SharedServices",
  ]
  enabled = true

  max_session_duration          = 3600
  attach_admin_policy           = true
  attach_read_only_policy       = false
  create_oidc_provider          = true
  force_detach_policies         = false
  iam_role_path                 = "/"
  iam_role_permissions_boundary = ""
  iam_role_policy_arns          = []
  iam_role_inline_policies      = {}
  iam_role_name                 = ""
  tags = {
    Environment = "dev"
    App         = "scalr_oidc" ## Application/Product the DNS is for e.g. ecs, argocd
    Resource    = "Managed by Terraform"
    Description = "IAM Related Configuration"
    Team        = "DevOps" ## Name of the team requesting the creation of the DNS resource
  }
}
