path "${CLUSTER_NAME}-pki*" {
  capabilities = ["read", "list"]
}

path "${CLUSTER_NAME}-pki/roles/cliniciannexus-dot-com" {
  capabilities = ["create", "update"]
}

path "${CLUSTER_NAME}-pki/sign/cliniciannexus-dot-com" {
  capabilities = ["create", "update"]
}

path "${CLUSTER_NAME}-pki/issue/cliniciannexus-dot-com" {
  capabilities = ["create"]
}
