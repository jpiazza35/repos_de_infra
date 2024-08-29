resource "databricks_obo_token" "token" {
  application_id   = var.service_principal_application_id
  lifetime_seconds = var.lifetime_seconds
  comment          = var.comment
}


resource "vault_generic_secret" "token_secret" {
  data_json = jsonencode({
    id                               = databricks_obo_token.token.id
    token                            = databricks_obo_token.token.token_value
    service_principal_application_id = var.service_principal_application_id
    lifetime_seconds                 = var.lifetime_seconds
    comment                          = var.comment
  })
  path = "data_platform/${var.env}/databricks/service-principal-tokens/${var.service_principal_name}"
}
