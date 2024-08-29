aws_region                 = "us-east-1"
cluster_version            = "1.27"
use_node_group_name_prefix = true
min_size                   = 3
max_size                   = 5
des_size                   = 3
is_eks_api_public          = true
is_eks_api_private         = true
capacity_type              = "ON_DEMAND"
ami_type                   = "AL2_x86_64"
disk_size                  = 30
ebs_csi_addon_version      = "v1.21.0-eksbuild.1"
kube_proxy_addon_version   = "v1.27.4-eksbuild.2"
coredns_addon_version      = "v1.10.1-eksbuild.2"
vault_url                  = "https://vault.cliniciannexus.com:8200"
asg_metrics_lambda_name    = "lambda-asg-enable-metrics"
asg_metrics_lambda_runtime = "python3.9"

services_cidr = "10.202.28.0/23"

#replace me
environment    = "devops"
instance_types = ["t3.2xlarge"]

#auth map
iam_roles = [
  {
    rolearn  = "arn:aws:iam::964608896914:role/AWSReservedSSO_AWSAdministratorAccess_27de45d28707f812"
    rolename = "AWSReservedSSO_AWSAdministratorAccess_27de45d28707f812"
    groups   = ["system:masters"]
    username = "aws-sso-admin"
  },
  {
    rolearn  = "arn:aws:iam::964608896914:role/AWSReservedSSO_Account_Administrator_0c4eee6da33e281d"
    rolename = "AWSReservedSSO_Account_Administrator_0c4eee6da33e281d"
    groups   = ["system:masters"]
    username = "aws-sso-acc-admin"
  }
]

## Vault Auth
## Vault Management
k8s_serviceaccount = "vault-auth"

paths = [
  "dev",
  "devops",
  "qa",
  "prod"
]

## MPT vars

mpt_namespace               = "mpt"
incumbent_api_sa_annotation = "arn:aws:iam::472485266432:role/d_eks_oidc_role"

#namespace for preview env
mpt_preview_namespace = "mpt-preview"

## Argo vars


argocd_release_namespace           = "argocd"
argocd_release_name                = "argo-cd"
argocd_chart_repository            = "https://argoproj.github.io/argo-helm"
dependency_update                  = true
argocd_chart_name                  = "argo-cd"
argocd_chart_version               = "5.43.5"
set_cluster_enabled                = true
argocd_keep_crds_uninstall         = false
helm_charts_branch_name            = "main"
argocd_slack_notifications_enabled = false
argocd_sync_interval_time          = "15s"
argocd_preview_environment         = "" ## this is only for prod env
slack_channel                      = "devops-pipeline-alerts"


## Ingress vars

ingress_mpt_alb_name                       = "mpt-ingress"
ingress_monitoring_namespace               = "monitoring"
ingress_group_name                         = "mpt"
ingress_mpt_host                           = "mpt.devops.cliniciannexus.com"
ingress_mpt_preview_host                   = "" #it is just for prod that why it is empty
ingress_argocd_host                        = "argocd.devops.cliniciannexus.com"
ingress_monitoring_host                    = "monitoring.devops.cliniciannexus.com"
ingress_mpt_name                           = "mpt"
ingress_argocd_name                        = "argocd"
ingress_monitoring_name                    = "monitoring"
ingress_k8s_dashboard_name                 = "kubernetes-dashboard"
ingress_k8s_dashboard_host                 = "k8s.devops.cliniciannexus.com"
ingress_name_app_organization_grpc_service = "app-organization-grpc-service"
ingress_name_app_user_grpc_service         = "app-user-grpc-service"
ingress_name_app_survey_grpc_service       = "app-survey-grpc-service"
ingress_name_app_incumbent_grpc_service    = "app-incumbent-grpc-service"
ingress_name_app_user_api_swagger          = "app-user-api-swagger"
ingress_name_app_mpt_project_swagger       = "app-mpt-project-swagger"
ingress_name_app_survey_api_swagger        = "app-survey-api-swagger"
ingress_name_app_incumbent_api_swagger     = "app-incumbent-api-swagger"
ingress_mpt_apps_healthcheck_endpoint      = "/health"
ingress_swagger_endpoint                   = "/swagger"

## Performance Suite Ingress vars

ingress_ps_name                      = "ps"
ingress_ps_host                      = "ps.devops.cliniciannexus.com"
ingress_ps_apps_healthcheck_endpoint = "/health"
ingress_ps_preview_host              = "ps.preview.cliniciannexus.com"
ingress_ps_preview_group_name        = "ps-preview"
ingress_ps_preview_alb_name          = "ps-preview-ingress"

dns_zone_id = ""

## external-dns vars  ## TBA

## Kubecost vars

kubecost_release_name      = "kubecost"
kubecost_release_namespace = "kubecost"
kubecost_chart_repository  = "https://kubecost.github.io/cost-analyzer/"
kubecost_chart_name        = "cost-analyzer"
kubecost_chart_version     = "1.104.0"
kubecost_storage_class     = "gp2"
ingress_kubecost_host      = "kubecost.devops.cliniciannexus.com"
ingress_kubecost_name      = "kubecost"
ingress_kubecost_namespace = "kubecost"
ingress_kubecost_alb_group = "kubecost"
kubecost_oidc_tenant_id    = "5fe40ed0-dfbc-4a82-8a07-d07314934c3a"
kubecost_oidc_secret_name  = "kubecost-oidc"

## cert-manager vars

cert_manager_release_namespace = "cert-manager"
cert_manager_release_name      = "cert-manager"
cert_manager_chart_repository  = "https://charts.jetstack.io"
cert_manager_chart_name        = "cert-manager"
cert_manager_chart_version     = "1.12.3"
cert_manager_crds_helm_url     = "https://github.com/cert-manager/cert-manager/releases/download/v1.12.3/cert-manager.crds.yaml"

## k8s-dashboard vars

k8s_dashboard_release_name      = "kubernetes-dashboard"
k8s_dashboard_release_namespace = "kubernetes-dashboard"
k8s_dashboard_chart_repository  = "https://kubernetes.github.io/dashboard/"
k8s_dashboard_chart_name        = "kubernetes-dashboard"
k8s_dashboard_chart_version     = "6.0.8"

## metric-server vars

metric_server_release_name          = "metrics-server"
metric_server_release_namespace     = "kube-system"
metric_server_chart_repository      = "https://kubernetes-sigs.github.io/metrics-server/"
metric_server_chart_name            = "metrics-server"
metric_server_chart_version         = "3.11.0"
helm_recreate_pods_metric           = true
helm_cleanup_on_fail_metric         = true
helm_release_timeout_seconds_metric = 180
max_history_metric                  = 1
helm_skip_crds_metric               = false

## monitoring vars

monitoring_namespace          = "monitoring"
cni_metrics_namespace         = "kube-system"
helm_releases_timeout_seconds = 180
helm_releases_max_history     = 1

prometheus_release_name     = "prometheus"
prometheus_chart_repository = "https://prometheus-community.github.io/helm-charts"
prometheus_chart_version    = "47.5.0"
prometheus_chart_name       = "kube-prometheus-stack"
prometheus_helm_skip_crds   = false
runbook_base_url            = "https://runbooks.prometheus-operator.dev/runbook"
enable_prometheus_rules     = false

enable_thanos_helm_chart = false
thanos_release_name      = "thanos"
thanos_chart_repository  = "https://charts.bitnami.com/bitnami"
thanos_chart_version     = "12.2.1"
thanos_chart_name        = "thanos"

grafana_username = "admin"

elasticsearch_release_name     = "elasticsearch"
elasticsearch_chart_repository = "https://helm.elastic.co"
elasticsearch_chart_version    = "8.5.1"
elasticsearch_chart_name       = "elasticsearch"
elasticsearch_docker_image     = "docker.elastic.co/elasticsearch/elasticsearch"
elasticsearch_docker_image_tag = "8.8.2"
elasticsearch_major_version    = 8
elasticsearch_cluster_name     = "elasticsearch"
elasticsearch_psp_enable       = true
elasticsearch_rbac_enable      = true
elasticsearch_client_resources = {
  limits = {
    cpu    = "3"
    memory = "2048Mi"
  }
  requests = {
    cpu    = "0.5"
    memory = "512Mi"
  }
}
elasticsearch_client_replicas              = 1
elasticsearch_client_persistence_disk_size = "1Gi"
elasticsearch_master_resources = {
  limits = {
    cpu    = "1.5"
    memory = "1024M"
  }
  requests = {
    cpu    = "0.5"
    memory = "512M"
  }
}
elasticsearch_master_minimum_replicas      = 1
elasticsearch_master_replicas              = 1
elasticsearch_master_persistence_disk_size = "4Gi"
elasticsearch_data_resources = {
  limits = {
    cpu    = "1"
    memory = "2560Mi"
  }
  requests = {
    cpu    = "25m"
    memory = "2560Mi"
  }
}
elasticsearch_data_replicas              = 1
elasticsearch_data_persistence_disk_size = "30Gi"

jaeger_release_name     = "jaeger-operator"
jaeger_chart_repository = "https://jaegertracing.github.io/helm-charts"
jaeger_chart_version    = "2.46.1"
jaeger_chart_name       = "jaeger-operator"
jaeger_crds_helm_url    = "https://raw.githubusercontent.com/jaegertracing/helm-charts/main/charts/jaeger-operator/crds/crd.yaml"

## Performance Suite vars

ps_namespace         = "ps"
ps_preview_namespace = "ps-preview"

# Fluentd vars
fluentd_deployment_name  = "sc-fluentd"
fluentd_chart_repository = "https://charts.bitnami.com/bitnami"
fluentd_chart_name       = "fluentd"
fluentd_chart_version    = "5.9.3"

# Telegraf vars
telegraf_deployment_name  = "sc-telegraf"
telegraf_chart_repository = "https://helm.influxdata.com/"
telegraf_chart_name       = "telegraf"
telegraf_chart_version    = "1.8.34"

# Influxdb vars
influxdb_deployment_name  = "sc-influxdb"
influxdb_chart_repository = "https://helm.influxdata.com/"
influxdb_chart_name       = "influxdb2"
influxdb_chart_version    = "2.1.1"
influxdb_organization     = "sc"
influxdb_user             = "admin"
influxdb_bucket           = "monitoring"

