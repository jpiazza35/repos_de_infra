data "vault_generic_secret" "kubecost" {
  path = "${var.environment}/kubecost"
}
