module "github_oidc" {
  source  = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//github_oidc_aws?ref=1.0.78"
  enabled = true
  github_repositories = [
    "clinician-nexus/infra-cluster-resources"
  ]
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
    Environment    = var.environment
    App            = "github"
    Resource       = "Managed by Terraform"
    Description    = "Github OIDC Role Config"
    Team           = "DevOps"
    SourcecodeRepo = "https://github.com/clinician-nexus/infra-cluster-resources"
  }
}
