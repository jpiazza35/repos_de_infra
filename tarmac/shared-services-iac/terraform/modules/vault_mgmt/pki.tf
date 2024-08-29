resource "vault_mount" "pki" {
  count                     = local.create_k8s_auth
  path                      = format("%s-pki", var.cluster_name)
  type                      = "pki"
  default_lease_ttl_seconds = 63072000  ## 2yrs
  max_lease_ttl_seconds     = 315360000 ## 10 yrs
}

resource "vault_pki_secret_backend_role" "role" {
  count         = local.create_k8s_auth
  backend       = vault_mount.pki[count.index].path
  name          = "cliniciannexus-dot-com"
  ttl           = "31536000"
  max_ttl       = "315360000"
  allow_ip_sans = true
  key_type      = "rsa"
  key_bits      = 4096
  allowed_domains = [
    "cliniciannexus.com",
  ]
  allow_subdomains            = true
  allow_bare_domains          = true
  allow_wildcard_certificates = true
  allow_glob_domains          = true
  /* allow_any_name = true */

}

resource "vault_pki_secret_backend_root_cert" "app" {
  depends_on = [
    vault_mount.pki
  ]
  count = local.create_k8s_auth

  backend              = vault_mount.pki[count.index].path
  type                 = "internal"
  ttl                  = "315360000" ## 10 yrs
  format               = "pem"
  private_key_format   = "der"
  key_type             = "rsa"
  key_bits             = 4096
  exclude_cn_from_sans = true
  organization         = "Clinician Nexus"
  ou                   = "devops"

  common_name = "*.cliniciannexus.com"
  alt_names = [
    "*.${var.env}.cliniciannexus.com"
  ]

}

resource "vault_pki_secret_backend_config_urls" "urls" {
  count   = local.create_k8s_auth
  backend = vault_mount.pki[count.index].path
  issuing_certificates = [
    "https://vault.cliniciannexus.com:8200/v1/pki/ca",
  ]
  crl_distribution_points = [
    "https://vault.cliniciannexus.com:8200/v1/pki/crl"
  ]
}

resource "vault_pki_secret_backend_crl_config" "crl_config" {
  count        = local.create_k8s_auth
  backend      = vault_mount.pki[count.index].path
  expiry       = "72h"
  disable      = false
  auto_rebuild = true
  enable_delta = true
}

resource "vault_generic_endpoint" "pki_inter-auto-tidy" {
  count = local.create_k8s_auth
  path  = "${vault_mount.pki[count.index].path}/config/auto-tidy"

  # We're not configuring all available options here, just some of them
  # so ignore things which are returned from Vault which we didn't explicitly set
  ignore_absent_fields = true

  data_json = <<EOT
{
  "enabled": true,
  "tidy_cert_store": true,
  "safety_buffer": 86400
}
EOT
}
