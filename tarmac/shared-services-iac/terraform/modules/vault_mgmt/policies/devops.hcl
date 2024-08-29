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

path "data_platform/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "preview/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Create and manage secrets engines broadly across Vault.
path "sys/mounts/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List enabled secrets engines
path "sys/mounts"
{
  capabilities = ["read", "list"]
}

# Read auth methods broadly across Vault
path "auth/*"
{
  capabilities = ["read", "list"]
}

# Create and update auth methods
path "sys/auth/*"
{
  capabilities = ["create", "update"]
}

# List auth methods
path "sys/auth"
{
  capabilities = ["read", "list"]
}

# List ACL policies
path "sys/policies/acl"
{
  capabilities = ["read", "list"]
}

# Read ACL policies
path "sys/policies/acl/*"
{
  capabilities = ["read", "list"]
}
