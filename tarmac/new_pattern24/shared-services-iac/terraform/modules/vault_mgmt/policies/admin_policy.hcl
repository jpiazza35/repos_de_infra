# Manage auth methods broadly across Vault
path "auth/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Create, update, and delete auth methods
path "sys/auth/*"
{
  capabilities = ["create", "update", "delete", "sudo"]
}

# List auth methods
path "sys/auth"
{
  capabilities = ["read"]
}

# Create and manage ACL policies
path "sys/policies/acl/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List ACL policies
path "sys/policies/acl"
{
  capabilities = ["list"]
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

# List, create, update, and delete key/value secrets at secret/ 
path "secret/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage dev path secrets engine
path "dev/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage prod path secrets engine
path "prod/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage qa path secrets engine
path "qa/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage data_platform path secrets engine
path "data_platform/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage devops path secrets engine
path "devops/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage SharedServices path secrets engine
path "ss/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Read health checks
path "sys/health"
{
  capabilities = ["read", "sudo"]
}
