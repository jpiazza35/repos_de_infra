module "github_oidc" {
  source  = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//github_oidc_aws"
  enabled = true
  github_repositories = [
    "clinician-nexus/etl-organization-financial-data",
    "clinician-nexus/data-platform-cdc",
    "clinician-nexus/data-platform-survey-to-file-type1",
    "clinician-nexus/data-platform-databricks-applications-infrastructure",
    "clinician-nexus/data-platform-tableau",
    "clinician-nexus/data-platform-simple-integration-service",
    "clinician-nexus/data-platform-dxf-commons",
    "clinician-nexus/data-platform-s3-presigned-url-generator",
    "clinician-nexus/data-platform-file-type1",
    "clinician-nexus/data-platform-file-registration-service",
    "clinician-nexus/app-mpt-api-data-elt",
    "clinician-nexus/shared-services-iac",
    "clinician-nexus/data-platform-devops-iac",
    "clinician-nexus/data-platform-iac",
    "clinician-nexus/data-exchange-framework",
    "clinician-nexus/physician-rfi-application"
  ]
  max_session_duration          = 3600
  attach_admin_policy           = true
  attach_read_only_policy       = false
  create_oidc_provider          = true
  force_detach_policies         = false
  iam_role_path                 = "/"
  iam_role_permissions_boundary = ""
  iam_role_policy_arns          = []
  iam_role_inline_policies = {
    "github_oidc_policy" : data.aws_iam_policy_document.aws_data_platform.json
  }
  iam_role_name = "data-platform-github-oidc-role"
  tags = {
    Environment    = var.env
    App            = "github"
    Resource       = "Managed by Terraform"
    Description    = "Github OIDC Role for Data Platform Team Config"
    Team           = "Data"
    SourceCodeRepo = "https://github.com/clinician-nexus/data-platform-devops-iac"
  }
}
