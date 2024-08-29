data "github_team" "dp" {
  slug = "data-platform"
}

data "github_user" "user" {
  username = ""
}


data "vault_generic_secret" "tf_sp" {
  path = "data_platform/${var.env}/databricks/service-principal-tokens/terraform-service-principal"
}

data "github_repository" "repo" {
  name = var.repository
}

#data "github_repository_environments" "env" {
#  repository = data.github_repository.repo.name
#}
