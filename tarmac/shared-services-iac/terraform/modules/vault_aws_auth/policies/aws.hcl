path "aws/${ACCOUNT_ID}/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Manage data_platform path secrets engine
path "data_platform/*"
{
  capabilities = ["read", "list"]
}
