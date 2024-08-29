resource "random_password" "elastic_password" {
  length           = 20
  special          = true
  override_special = "!"
}

resource "vault_kv_secret" "elasticsearch_password" {
  path = "${var.environment}/secrets/${var.cluster_name}/elastic"
  data_json = jsonencode(
    {
      password = random_password.elastic_password.result
    }
  )
}

resource "kubernetes_secret" "elastic_password_secret" {
  metadata {
    name      = "${var.elasticsearch_cluster_name}-master-credentials"
    namespace = var.monitoring_namespace
  }

  data = {
    password = random_password.elastic_password.result
  }

}

# Elasticsearch master nodes
resource "helm_release" "elasticsearch" {

  name        = var.elasticsearch_release_name
  chart       = var.elasticsearch_chart_name
  repository  = var.elasticsearch_chart_repository
  version     = var.elasticsearch_chart_version
  namespace   = var.monitoring_namespace
  timeout     = var.helm_releases_timeout_seconds
  max_history = var.helm_releases_max_history

  values = [
    templatefile("${path.module}/templates/elasticsearch.yml",
      {
        es_cluster_name = var.elasticsearch_cluster_name

        es_image                        = var.elasticsearch_docker_image
        es_image_tag                    = var.elasticsearch_docker_image_tag
        es_major_version                = var.elasticsearch_major_version
        es_rbac_enable                  = var.elasticsearch_rbac_enable || var.elasticsearch_psp_enable
        es_psp_enable                   = var.elasticsearch_psp_enable
        es_master_minimum_replicas      = var.elasticsearch_master_minimum_replicas
        es_master_replicas              = var.elasticsearch_master_replicas
        es_master_resources             = jsonencode(var.elasticsearch_master_resources)
        es_master_persistence_disk_size = var.elasticsearch_master_persistence_disk_size
      }
    )
  ]

  depends_on = [
    kubernetes_secret.elastic_password_secret
  ]

}

# Elasticsearch data nodes
resource "helm_release" "elasticsearch_data" {

  name        = "${var.elasticsearch_release_name}-data"
  chart       = var.elasticsearch_chart_name
  repository  = var.elasticsearch_chart_repository
  version     = var.elasticsearch_chart_version
  namespace   = var.monitoring_namespace
  max_history = var.helm_releases_max_history

  timeout = var.helm_releases_timeout_seconds

  values = [
    templatefile("${path.module}/templates/elasticsearch_data.yml",
      {
        es_cluster_name = var.elasticsearch_cluster_name

        es_image                      = var.elasticsearch_docker_image
        es_image_tag                  = var.elasticsearch_docker_image_tag
        es_major_version              = var.elasticsearch_major_version
        es_rbac_enable                = var.elasticsearch_rbac_enable || var.elasticsearch_psp_enable
        es_psp_enable                 = var.elasticsearch_psp_enable
        es_data_replicas              = var.elasticsearch_data_replicas
        es_data_resources             = jsonencode(var.elasticsearch_data_resources)
        es_data_persistence_disk_size = var.elasticsearch_data_persistence_disk_size
      }
    )
  ]

  depends_on = [
    helm_release.elasticsearch,
    helm_release.elasticsearch_client
  ]
}

# Elasticsearch client nodes
resource "helm_release" "elasticsearch_client" {
  name        = "${var.elasticsearch_release_name}-client"
  chart       = var.elasticsearch_chart_name
  repository  = var.elasticsearch_chart_repository
  version     = var.elasticsearch_chart_version
  namespace   = var.monitoring_namespace
  max_history = var.helm_releases_max_history

  timeout = var.helm_releases_timeout_seconds

  values = [
    templatefile("${path.module}/templates/elasticsearch_client.yml",
      {
        es_cluster_name = var.elasticsearch_cluster_name

        es_image                        = var.elasticsearch_docker_image
        es_image_tag                    = var.elasticsearch_docker_image_tag
        es_major_version                = var.elasticsearch_major_version
        es_rbac_enable                  = var.elasticsearch_rbac_enable || var.elasticsearch_psp_enable
        es_psp_enable                   = var.elasticsearch_psp_enable
        es_client_replicas              = var.elasticsearch_client_replicas
        es_client_resources             = jsonencode(var.elasticsearch_client_resources)
        es_client_persistence_disk_size = var.elasticsearch_client_persistence_disk_size
      }
    )
  ]

  depends_on = [
    helm_release.elasticsearch
  ]
}
