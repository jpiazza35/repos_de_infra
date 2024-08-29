path "dev/ces/*" {
  capabilities = ["read", "list", "create", "update"]
}

path "dev/" {
  capabilities = ["list"]
}

path "qa/ces/*" {
  capabilities = ["read", "list", "create", "update"]
}

path "qa/" {
  capabilities = ["list"]
}

path "prod/" {
  capabilities = ["list"]
}

path "prod/ces/*" {
  capabilities = ["read", "list", "create"]
}
