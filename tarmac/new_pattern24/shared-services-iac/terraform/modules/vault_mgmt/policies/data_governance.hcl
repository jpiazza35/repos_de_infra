path "dev/*" {
  capabilities = [ "list" ]
}

path "prod/*" {
  capabilities = [ "list" ]
}

path "dev/databricks/sql_endpoints/sdlc-reltio-sql-endpoint" {
  capabilities = ["create", "read", "list"]
}

path "prod/databricks/sql_endpoints/prod-reltio-sql-endpoint" {
  capabilities = ["create", "read", "list"]
}

path "prod/preview/databricks/sql_endpoints/preview-reltio-sql-endpoint" {
  capabilities = ["create", "read", "list"]
}

path "dev/databricks/service-principal-tokens/sdlc-reltio-service-principal" {
  capabilities = ["create", "read", "list"]
}

path "prod/databricks/service-principal-tokens/prod-reltio-service-principal" {
  capabilities = ["create", "read", "list"]
}

path "prod/preview/databricks/service-principal-tokens/preview-reltio-service-principal" {
  capabilities = ["create", "read", "list"]
}
