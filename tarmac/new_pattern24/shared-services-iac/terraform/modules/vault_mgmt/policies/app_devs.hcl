path "dev/mpt/*" {
  capabilities = ["read", "list", "create", "update"]
}

path "dev/ps/*" {
  capabilities = ["read", "list", "create", "update"]
}

path "dev/dwb/*" {
  capabilities = ["read", "list", "create", "update"]
}

path "dev/bm/*" {
  capabilities = ["read", "list", "create", "update"]
}

path "dev/" {
  capabilities = ["list"]
}

path "qa/mpt/*" {
  capabilities = ["read", "list", "create", "update"]
}

path "qa/dwb/*" {
  capabilities = ["read", "list", "create", "update"]
}

path "qa/bm/*" {
  capabilities = ["read", "list", "create", "update"]
}

path "qa/" {
  capabilities = ["list"]
}

path "qa/ps/*" {
  capabilities = ["read", "list", "create", "update"]
}

path "prod/" {
  capabilities = ["list"]
}

path "prod/mpt/*" {
  capabilities = ["read", "list", "create", "update"]
}

path "prod/preview/*" {
  capabilities = ["read", "list", "create", "update"]
}

path "prod/ps/*" {
  capabilities = ["read", "list", "create", "update"]
}

path "prod/dwb/*" {
  capabilities = ["read", "list", "create", "update"]
}

path "prod/bm/*" {
  capabilities = ["read", "list", "create", "update"]
}

path "data_platform/" {
  capabilities = ["list"]
}

path "data_platform/mpt/" {
  capabilities = ["read", "list"]
}

path "dev/codespaces/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}