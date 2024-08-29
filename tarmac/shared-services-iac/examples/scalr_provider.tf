module "scalr_provider" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//scalr_provider?ref=1.0.0"

  account_id = "acc-ucn902p9416i3h8"

  scalr_providers = [
    ### AWS Scalr Provider using OIDC Credentials
    {
      name        = "ss_tools"
      type        = "aws"
      description = null
      aws_arn     = module.scalr_oidc.iam_role_arn
      environments = [
        "DevOps",
        "DataPlatform",
      ]
    },
    ### Scalr Provider with ServiceAccount Token
    {
      name        = "scalr_prod"
      type        = "scalr"
      description = "Scalr Provider with ServiceAccount Token"
      aws_arn     = null
      environments = [
        "DevOps",
        "DataPlatform",
      ]
    },
  ]

  hostname = "cliniciannexus.scalr.io"

}

module "scalr_oidc" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//scalr_oidc_aws?ref=1.0.0"
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
