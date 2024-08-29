

# todo: migrate to provisioned environment on close of https://github.com/integrations/terraform-provider-github/issues/1805
# until then, create envs via UI
#resource "github_repository_environment" "databricks" {
#  environment = "databricks_${var.env}"
#  repository = var.repository
#
##  reviewers {
##    teams = [data.github_team.dp.id]
##  }
##
##  deployment_branch_policy {
##    custom_branch_policies = false
##    protected_branches     = false
##  }
#}


locals {
  environment = "databricks_${var.env}"
}

resource "github_actions_environment_variable" "databricks_host" {
  environment   = local.environment
  repository    = var.repository
  value         = data.vault_generic_secret.tf_sp.data["host"]
  variable_name = "DATABRICKS_HOST"
}

resource "github_actions_environment_secret" "client_id" {
  environment     = local.environment
  repository      = var.repository
  plaintext_value = data.vault_generic_secret.tf_sp.data["client_id"]
  secret_name     = "DATABRICKS_CLIENT_ID"
}

resource "github_actions_environment_secret" "client_secret" {
  environment     = local.environment
  repository      = var.repository
  secret_name     = "DATABRICKS_CLIENT_SECRET"
  plaintext_value = data.vault_generic_secret.tf_sp.data["client_secret"]
}

resource "github_actions_environment_variable" "tf_workspace" {
  environment   = local.environment
  repository    = var.repository
  value         = var.env
  variable_name = "TF_WORKSPACE"
}

resource "github_actions_environment_variable" "aws_gh_oidc" {
  environment   = local.environment
  repository    = var.repository
  value         = "arn:aws:iam:${var.databricks_aws_account_number}:role/databricks-${var.env}-github-oidc-role"
  variable_name = "OIDC_ROLE"
}
