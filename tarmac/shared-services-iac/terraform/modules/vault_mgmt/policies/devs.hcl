path "dev/*" {
  capabilities = ["create", "read", "list"]
}

path "dev/codespaces/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "qa/*" {
  capabilities = ["create", "read", "list"]
}

path "prod/*" {
  capabilities = ["list"]
}
