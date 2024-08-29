output "catalog_id" {
  value = databricks_catalog.this.id
}

output "catalog_name" {
  value = databricks_catalog.this.name
}


output "schemas" {
  value = {
    for schema in databricks_schema.schemas : schema.name => schema.id
  }
}
