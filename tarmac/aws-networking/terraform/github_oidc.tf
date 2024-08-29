module "ss_network_github_oidc" { #SS_NETWORK
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//github_oidc_aws"

  for_each = terraform.workspace == "tgw" ? toset(["us-east-1"]) : toset([])

  enabled = true
  github_repositories = [
    "clinician-nexus/aws-networking",
    "clinician-nexus/shared-services-iac",
    "clinician-nexus/infra-cluster-resources",
    "clinician-nexus/bi-platform-devops-iac",
    "clinician-nexus/data-platform-devops-iac"
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
  tags = merge(
    var.tags,
    {
      "cn:description" = "Github OIDC Role Config"
      "cn:service"     = "security"
    }
  )
}
