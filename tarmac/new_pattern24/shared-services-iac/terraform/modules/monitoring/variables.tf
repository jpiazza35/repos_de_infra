variable "environment" {
  description = "The environment"
}

variable "cluster_name" {}

variable "prefix" {
  description = "Prefix for thanos S3 Bucket"
  default     = "tools"
}

variable "helm_releases_timeout_seconds" {
  description = "Time in seconds to wait for any individual kubernetes operation during a helm release."
}

variable "helm_releases_max_history" {
  description = "Max History for Helm"
}

variable "monitoring_namespace" {
  description = "The namespace Helm will install the chart under"
}

variable "grafana_agent_image_tag" {
  description = "Variable for image tag in yml file"
}

variable "cni_metrics_namespace" {
  description = "The namespace where CNI PodMonitor will be installed."
}

variable "argocd_release_namespace" {
  description = "Namespace where ArgoCD is installed"
  type        = string
}

variable "monitoring_ingress" {
  description = "Host name for monitoring stack Ingress"
  type        = string
}

variable "ingress_monitoring_name" {
  description = "Name for the monitoring stack Ingress"
  type        = string
}

############## 
# Prometheus
##############
variable "prometheus_release_name" {
  description = "The name of the Helm release"
}

variable "prometheus_chart_repository" {
  description = "The repository where the Helm chart is stored"
}

variable "helm_recreate_pods" {
  type        = bool
  description = "Perform pods restart during upgrade/rollback"
  default     = true
}

variable "prometheus_helm_skip_crds" {
  type        = bool
  description = "Skip installing Prometheus CRDs"
}

variable "prometheus_chart_version" {
  description = "Version of the Helm chart"
}

variable "prometheus_chart_name" {
  description = "The name of the Helm chart"
}

variable "runbook_base_url" {
  description = "Prometheus runbook base URL."
}

variable "enable_destinationrules" {
  type        = bool
  default     = true
  description = "Creates DestinationRules for Prometheus, Alertmanager, Grafana, and Node Exporters"
}

variable "enable_prometheus_affinity_and_tolerations" {
  description = "Enable or not Prometheus node affinity (check helm values for the expressions)"
  default     = false
  type        = bool
}

variable "enable_large_nodesgroup" {
  description = "Due to Prometheus resource consumption, enabling this will set k8s Prometheus resources to higher values"
  type        = bool
  default     = false
}

variable "pagerduty_config" {
  description = "Add PagerDuty key to allow integration with a PD service."
  default     = ""
}

variable "destinationrules_mode" {
  type        = string
  default     = "DISABLE" #MUTUAL
  description = "DestionationRule TLS mode"
}

variable "cluster_domain" {
  type        = string
  default     = "cliniciannexus.com"
  description = "Cluster domain for DestinationRules"
}

variable "enable_prometheus_rules" {
  type        = bool
  description = "Adds PrometheusRules for alerts"
}

variable "prometheus_pvc_name" {
  type        = string
  default     = "prometheus-pvc"
  description = "Used for storage alert. Set if using non-default helm_release"
}

################
# Alertmanager
################

variable "alertmanager_replicas" {
  type        = number
  default     = 1
  description = "Number of replicas for Alertmanager"
}

variable "alertmanager_slack_receivers" {
  description = "A list of configuration values for Slack receivers"
  type        = list(any)
  default = [
    {
      channel  = "#monitoring_alerts"
      webhook  = "https://hooks.slack.com/services/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"
      severity = "warning"
    }
  ]
}

variable "cluster_domain_name" {
  description = "The cluster domain - used by externalDNS and certmanager to create URLs"
  default     = "dev.cliniciannexus.com"
}

#########
# Thanos
#########
variable "enable_thanos_sidecar" {
  description = "Enable or not Thanos sidecar. Basically defines if we want to send cluster metrics to thanos's S3 bucket"
  default     = true
  type        = bool
}

variable "enable_thanos_helm_chart" {
  description = "Enable or not Thanos Helm Chart - (do NOT confuse this with thanos sidecar within prometheus-operator)"
  type        = bool
}

variable "enable_thanos_compact" {
  description = "Enable or not Thanos Compact - not semantically concurrency safe and must be deployed as a singleton against a bucket"
  default     = true
  type        = bool
}

variable "thanos_release_name" {
  description = "The Thanos helm release name."
  type        = string
}

variable "thanos_chart_repository" {
  description = "The Thanos helm chart repository."
  type        = string
}

variable "thanos_chart_version" {
  description = "The Thanos helm chart version."
  type        = string
}

variable "thanos_chart_name" {
  description = "The Thanos helm chart name."
  type        = string
}

###########################
# Elasticsearch cluster
###########################
variable "elasticsearch_release_name" {
  description = "Helm release name for Elasticsearch"
}

variable "elasticsearch_chart_name" {
  description = "Chart name for Elasticsearch"
}

variable "elasticsearch_chart_repository" {
  description = "Chart repository for Elasticsearch"
}

variable "elasticsearch_chart_version" {
  description = "Chart version for Elasticsearch"
}

variable "elasticsearch_docker_image" {
  description = "Elasticsearch docker image"
}

variable "elasticsearch_docker_image_tag" {
  description = "Elasticsearch docker image tag"
}

variable "elasticsearch_major_version" {
  description = "Used to set major version specific configuration. If you are using a custom image and not running the default Elasticsearch version you will need to set this to the version you are running"
}

variable "elasticsearch_cluster_name" {
  description = "Name of the elasticsearch cluster"
}

variable "elasticsearch_psp_enable" {
  description = "Create PodSecurityPolicy for ES resources"
}

variable "elasticsearch_rbac_enable" {
  description = "Create RBAC for ES resources"
}

variable "elasticsearch_client_resources" {
  description = "Kubernetes resources for Elasticsearch client node"
}

variable "elasticsearch_client_replicas" {
  description = "Num of replicas of Elasticsearch client node"
}

variable "elasticsearch_client_persistence_disk_size" {
  description = "Persistence disk size in each Elasticsearch client node"
}

variable "elasticsearch_master_resources" {
  description = "Kubernetes resources for Elasticsearch master node"
}

variable "elasticsearch_master_minimum_replicas" {
  description = "The value for discovery.zen.minimum_master_nodes. Should be set to (master_eligible_nodes / 2) + 1. Ignored in Elasticsearch versions >= 7."
}

variable "elasticsearch_master_replicas" {
  description = "Num of replicas of Elasticsearch master node"
}

variable "elasticsearch_master_persistence_disk_size" {
  description = "Persistence disk size in each Elasticsearch master node"
}

variable "elasticsearch_data_resources" {
  description = "Kubernetes resources for Elasticsearch data node"
}

variable "elasticsearch_data_replicas" {
  description = "Num of replicas of Elasticsearch data node"
}

variable "elasticsearch_data_persistence_disk_size" {
  description = "Persistence disk size in each Elasticsearch data node"
}

##########
# Jaeger
##########
variable "jaeger_release_name" {
  description = "The Jaeger helm release name."
  type        = string
}

variable "jaeger_chart_repository" {
  description = "The Jaeger helm chart repository."
  type        = string
}

variable "jaeger_chart_version" {
  description = "The Jaeger helm chart version."
  type        = string
}

variable "jaeger_chart_name" {
  description = "The Jaeger helm chart name."
  type        = string
}

# ############
# # Grafana-Faro
# ############

# variable "faro_release_name" {
#   description = "The faro helm release name."
#   type        = string
# }

# variable "faro_chart_repository" {
#   description = "The faro helm chart repository."
#   type        = string
# }

# variable "faro_chart_name" {
#   description = "The faro helm chart name."
#   type        = string
# }

# variable "faro_chart_version" {
#   description = "The faro helm chart version."
#   type        = string
# }

############
# Loki
############

variable "loki_release_name" {
  description = "The faro helm release name."
  type        = string
}

variable "loki_chart_repository" {
  description = "The faro helm chart repository."
  type        = string
}

variable "loki_chart_name" {
  description = "The faro helm chart name."
  type        = string
}

############
# Grafana
############

variable "grafana_username" {
  description = "The Grafana username."
  type        = string
}

##########
# Fluentd
##########
variable "fluentd_deployment_name" {
  description = "The fluentd helm release name."
  type        = string
}

variable "fluentd_chart_repository" {
  description = "The fluentd helm chart repository."
  type        = string
}

variable "fluentd_chart_name" {
  description = "The fluentd helm chart name."
  type        = string
}

variable "fluentd_chart_version" {
  description = "The fluentd helm chart version."
  type        = string
}

##########
# Telegraf
##########
variable "telegraf_deployment_name" {
  description = "The telegraf helm release name."
  type        = string
}

variable "telegraf_chart_repository" {
  description = "The telegraf helm chart repository."
  type        = string
}

variable "telegraf_chart_name" {
  description = "The telegraf helm chart name."
  type        = string
}

variable "telegraf_chart_version" {
  description = "The telegraf helm chart version."
  type        = string
}

##########
# Influxdb_v2
##########
variable "influxdb_deployment_name" {
  description = "The influxdb helm release name."
  type        = string
}

variable "influxdb_chart_repository" {
  description = "The influxdb helm chart repository."
  type        = string
}

variable "influxdb_chart_name" {
  description = "The influxdb helm chart name."
  type        = string
}

variable "influxdb_chart_version" {
  description = "The influxdb helm chart version."
  type        = string
}

variable "influxdb_organization" {
  description = "The influxdb org."
  type        = string
}

variable "influxdb_bucket" {
  description = "The influxdb bucket."
  type        = string
}

variable "influxdb_user" {
  description = "The influxdb user."
  type        = string
}
