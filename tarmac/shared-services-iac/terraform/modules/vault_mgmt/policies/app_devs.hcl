path "dev/mpt/*" {
  capabilities = ["read", "list", "create", "update"]
}

path "dev/" {
  capabilities = ["list"]
}

path "qa/mpt/*" {
  capabilities = ["read", "list", "create", "update"]
}

path "qa/" {
  capabilities = ["list"]
}

path "prod/" {
  capabilities = ["list"]
}

path "prod/mpt/*" {
  capabilities = ["read", "list"]
}

path "prod/preview/*" {
  capabilities = ["read", "list"]
}

path "data_platform/" {
  capabilities = ["list"]
}

path "data_platform/mpt/" {
  capabilities = ["read", "list"]
}
