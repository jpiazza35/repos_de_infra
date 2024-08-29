path "dev/*" {
  capabilities = [ "list", "read" ]
}

path "qa/*" {
  capabilities = [ "list", "read" ]
}

path "prod/*" {
  capabilities = [ "list" ]
}

path "data_platform/*" {
  capabilities = [ "list" ]
}
