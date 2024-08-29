path "kubernetes/${CLUSTER_NAME}/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "dev/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "devops/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "qa/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "prod/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
