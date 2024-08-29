## oidc role for runner to deploy to aws account
data "aws_iam_policy_document" "databricks_data_platform" {
  statement {
    actions   = ["s3:*", "iam:*", "logs:*", "ec2:*", "kms:*"]
    resources = ["*"]
  }
}

module "github_oidc" {
  source  = "github.com/clinician-nexus/shared-services-iac//terraform//modules//github_oidc_aws?ref=1.0.114"
  enabled = true
  github_repositories = [
    "clinician-nexus/data-platform-devops-iac",
    "clinician-nexus/data-platform-iac",
    "clinician-nexus/data-platform-databricks-common",
    "clinician-nexus/data-exchange-framework",
    "clinician-nexus/survey-cuts-etl-jobs",
    "clinician-nexus/data-platform-survey-to-file-type1",
    "clinician-nexus/data-platform-reference-data",
    "clinician-nexus/etl-survey-submission",
    "clinician-nexus/data-platform-tableau-cleansing",
    "clinician-nexus/great_expectations_suites",
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
    "github_oidc_policy" : data.aws_iam_policy_document.databricks_data_platform.json
  }
  iam_role_name = "databricks-${var.env}-github-oidc-role"
  tags = {
    Environment = var.env
    App         = "github"
    Resource    = "Managed by Terraform"
    Description = "Github OIDC Role for Databricks Workspace Config"
    Team        = "Data Platform"
  }
}