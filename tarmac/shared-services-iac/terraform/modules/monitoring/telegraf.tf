resource "helm_release" "telegraf" {
  repository = var.telegraf_chart_repository
  name       = var.telegraf_deployment_name
  namespace  = var.monitoring_namespace
  chart      = var.telegraf_chart_name
  version    = var.telegraf_chart_version
  timeout    = 300
  skip_crds  = false

  values = [
    templatefile("${path.module}/templates/telegraf.yml",
      {
        influxdb_token        = random_password.influxdb_token.result
        influxdb_organization = var.influxdb_organization
        influxdb_bucket       = var.influxdb_bucket
      }
    )
  ]

  depends_on = [
    helm_release.influxdb
  ]

}