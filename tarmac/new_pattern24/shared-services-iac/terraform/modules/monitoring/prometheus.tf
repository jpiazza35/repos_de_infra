resource "random_password" "password" {
  length  = 16
  special = true
}

resource "vault_kv_secret" "grafana_password" {
  path = "${var.environment}/secrets/${var.cluster_name}/grafana"
  data_json = jsonencode(
    {
      username = var.grafana_username,
      password = random_password.password.result
    }
  )
}


resource "helm_release" "prometheus" {
  name = var.prometheus_release_name

  repository = var.prometheus_chart_repository

  skip_crds = var.prometheus_helm_skip_crds

  chart     = var.prometheus_chart_name
  version   = var.prometheus_chart_version
  namespace = var.monitoring_namespace

  timeout     = var.helm_releases_timeout_seconds
  max_history = var.helm_releases_max_history

  values = [templatefile("${path.module}/templates/prometheus_operator.yml.tpl", {
    es_master_password                         = random_password.elastic_password.result
    environment                                = var.environment
    alertmanager_ingress                       = local.alertmanager_ingress
    grafana_root                               = local.grafana_root
    grafana_password                           = random_password.password.result
    local_grafana_role                         = aws_iam_role.grafana.arn
    infra_prod_grafana_role                    = aws_iam_role.grafana_infra_prod.arn
    pagerduty_config                           = var.pagerduty_config
    monitoring_ingress                         = var.monitoring_ingress
    prometheus_release_name                    = var.prometheus_release_name
    enable_prometheus_affinity_and_tolerations = var.enable_prometheus_affinity_and_tolerations
    enable_large_nodesgroup                    = var.enable_large_nodesgroup
    enable_thanos_sidecar                      = var.enable_thanos_sidecar
    clusterName                                = terraform.workspace
    region                                     = data.aws_region.current.name
    dns_name                                   = var.cluster_domain_name
    namespace                                  = var.monitoring_namespace
    github_oauth_client_id                     = data.vault_generic_secret.grafana_gh_oauth.data["github_oauth_client_id"]
    github_oauth_client_secret                 = data.vault_generic_secret.grafana_gh_oauth.data["github_oauth_client_secret"]
    influxdb_bucket                            = var.influxdb_bucket
    influxdb_organization                      = var.influxdb_organization
    influxdb_token                             = random_password.influxdb_token.result
    influxdb_password                          = random_password.influxdb_password.result
    influxdb_user                              = var.influxdb_user
  })]

  depends_on = [
    helm_release.elasticsearch,
    helm_release.influxdb
  ]

}

resource "kubernetes_persistent_volume" "prometheus_pv" {
  metadata {
    name = var.prometheus_release_name
  }
  spec {
    capacity = {
      storage = "5Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      host_path {
        path = "/tmp"
      }
    }
  }
}
