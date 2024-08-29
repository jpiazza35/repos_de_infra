resource "random_password" "influxdb_password" {
  length  = 20
  special = false
}

resource "vault_kv_secret" "influxdb_password_vault" {
  path = "${var.environment}/secrets/${var.cluster_name}/influxdb_psw"
  data_json = jsonencode(
    {
      password = random_password.influxdb_password.result
    }
  )
}

resource "random_password" "influxdb_token" {
  length  = 30
  special = false
}

resource "vault_kv_secret" "influxdb_token_vault" {
  path = "${var.environment}/secrets/${var.cluster_name}/influxdb_token"
  data_json = jsonencode(
    {
      password = random_password.influxdb_token.result
    }
  )
}

resource "helm_release" "influxdb" {

  repository = var.influxdb_chart_repository
  name       = var.influxdb_deployment_name
  namespace  = var.monitoring_namespace
  chart      = var.influxdb_chart_name
  version    = var.influxdb_chart_version
  timeout    = 300
  skip_crds  = false

  values = [
    templatefile("${path.module}/templates/influxdb.yml",
      {
        influxdb_password     = random_password.influxdb_password.result
        influxdb_token        = random_password.influxdb_token.result
        influxdb_organization = var.influxdb_organization
        influxdb_bucket       = var.influxdb_bucket
        influxdb_user         = var.influxdb_user
      }
    )
  ]

  depends_on = [
    random_password.influxdb_password,
    random_password.influxdb_token
  ]

}
