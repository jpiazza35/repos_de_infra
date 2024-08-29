locals {
  template_vars = {
    project                  = var.cert_manager_project
    env                      = var.cert_manager_env
    name                     = "letsencrypt-${var.cert_manager_env}"
    aws_region               = var.aws_region
    email                    = "patriciaanong@schsharedservices.com"
    namespace                = var.cert_manager_namespace
    cert_manager_dns_zone    = var.cert_manager_dns_zone
    cert_manager_dns_zone_id = var.cert_manager_dns_zone_id
    istio_gw_name            = var.istio_gw_name
    istio_namespace          = var.istio_namespace
    istio_dns_record         = var.istio_dns_record
    istio_cert_secret_name   = var.istio_cert_secret_name
  }

  certs_helm_chart_values = templatefile(
    "${path.module}/certs/values.yaml.tpl",
    local.template_vars
  )
}
