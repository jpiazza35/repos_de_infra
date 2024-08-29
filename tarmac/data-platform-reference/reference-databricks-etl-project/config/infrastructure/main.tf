# Databricks Repo
# Databricks Job / Tasks
# Artifacts location 

resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

resource "databricks_repo" "databricks_repo" {
  url = var.code_repository_url
}