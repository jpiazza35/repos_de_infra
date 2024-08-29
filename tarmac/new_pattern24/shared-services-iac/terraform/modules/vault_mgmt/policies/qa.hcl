path "dev/mpt/*" {
  capabilities = ["read", "list"]
}

path "dev/ps/*" {
  capabilities = ["read", "list"]
}

path "dev/dwb/*" {
  capabilities = ["read", "list"]
}

path "dev/bm/*" {
  capabilities = ["read", "list"]
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
