variable "aws_region" {
  type = string
}

variable "environment" {
  description = "tag name for the environment"
  type        = string
}

variable "preview_environment" {
  description = "tag name for the environment"
  type        = string
  default     = "preview"
}

variable "use_node_group_name_prefix" {
  description = "Whether to use name prefix for EKS node group name."
  type        = bool
  default     = false
}

variable "cluster_version" {
  description = "define the eks version to deploy the cluster where Rancher'll run on"
  type        = string
}

variable "services_cidr" {
  description = "CIDR block for the services"
  type        = string
}

variable "min_size" {
  description = "min"
  type        = number
}

variable "max_size" {
  description = "max size of the autoescaling cluster node groups"
  type        = number
}

variable "des_size" {
  description = "desired size of the autoescaling cluster node groups"
  type        = number
}

variable "is_eks_api_public" {
  description = "make api public available"
  type        = bool
}

variable "is_eks_api_private" {
  description = "make api private available"
  type        = bool
}

variable "asg_metrics_lambda_name" {
  description = "The name for the ASG metrics enabler Lambda."
  type        = string
}

variable "asg_metrics_lambda_runtime" {
  description = "The runtime for the ASG metrics enabler Lambda."
  type        = string
}


##var for creation of additional namespaces

variable "mpt_preview_namespace" {
  description = "MPT Preview namespace name."
  type        = string
}

variable "ps_namespace" {
  description = "The Performance Suite apps namespace"
  type        = string
}

variable "ps_preview_namespace" {
  description = "The preview Performance Suite apps namespace"
  type        = string
}

#AWS-auth Configmap roles
variable "iam_roles" {
  description = "IAM roles to add to the EKS aws-auth config maps"
  type = list(object({
    rolearn  = string
    rolename = string
    groups   = list(string)
  }))
}



variable "ebs_csi_addon_version" {
  description = ""
  type        = string
}

variable "coredns_addon_version" {
  description = "coredns EKS cluster add-on version."
  type        = string
}

variable "kube_proxy_addon_version" {
  description = "kube-proxy EKS cluster add-on version."
  type        = string
}

variable "instance_types" {
  description = "List of subnet IDs to create resources in"
  type        = list(string)
}

variable "capacity_type" {
  description = ""
  type        = string
}

variable "ami_type" {
  description = ""
  type        = string
}

variable "disk_size" {
  description = "Disk space of nodes"
  type        = number
}

variable "vault_url" {
  description = "Vault target URL"
  type        = string
}

### Vault Auth
variable "k8s_serviceaccount" {
  description = "serviceaccount for the vault auth"
  type        = string
}

variable "paths" {
  description = "paths to allow"
  type        = list(string)
}

# variable "cluster_name" {}

#################ARGOCD  VARIABLES##########################
##                                                        ##
############################################################

variable "argocd_release_namespace" {
  description = "Namespace where argocd will be installed"
  type        = string
}

variable "argocd_release_name" {
  description = "release of the ArgoCD Helm chart to deploy"
  type        = string
}

variable "argocd_chart_repository" {
  description = "repository of the ArgoCD Helm chart to deploy"
  type        = string
}

variable "dependency_update" {
  description = "Indicates if dependencies of the ArgoCD chart should be updated before installation"
  type        = bool
}

variable "argocd_chart_name" {
  description = "name of the ArgoCD Helm chart to deploy"
  type        = string
}

variable "argocd_chart_version" {
  description = "Version of the ArgoCD Helm chart to deploy"
  type        = string
}

variable "set_cluster_enabled" {
  description = "this is the set that make the cluster enabled"
  type        = bool
}

variable "argocd_keep_crds_uninstall" {
  description = "Whether to keep CRDs after ArgoCD helm chart uninstall."
  type        = bool
}

variable "argocd_sso_integration_enabled" {
  description = "Enable/disable SSO Integration for ArgoCD"
  default     = false
}

variable "argocd_sso_integration_domain_name" {
  description = "ArgoCD Domain Name"
  default     = "https://argocd.dev.cliniciannexus.com/"
}

variable "argocd_sso_integration_clientid" {
  description = "ClientID in Azure Portal for ArgoCD App"
  default     = ""
}

variable "argocd_sso_integration_group_id" {
  description = "GroupID in Azure Portal for ArgoCD App"
  default     = ""
}

variable "argocd_sso_integration_tennantid" {
  description = "TennantID in Azure Portal for ArgoCD App"
  default     = ""
}

variable "argocd_sso_integration_client_secret" {
  description = "Client Secret (Application) in Azure Portal for ArgoCD App"
  default     = ""
}

variable "argocd_slack_notifications_enabled" {
  description = "Enable/disable Slack Notifications for ArgoCD"
  default     = false
}

variable "argocd_sync_interval_time" {
  description = "Time in seconds for the sync interval time (10s, 20s...)"
  type        = string
}

variable "helm_charts_branch_name" {
  description = "The branch in helm-charts repo that ArgoCD is deploying from."
  type        = string
}

variable "argocd_preview_environment" {
  description = "The preview environment where MPT apps are installed."
  type        = string
}

variable "slack_channel" {
  description = "The slack channel in which to sent ArgoCD notifications."
  type        = string
}


#################MPT APPS  VARIABLES########################
##                                                        ##
############################################################

variable "mpt_namespace" {
  description = "The namespace where MPT apps are installed."
  type        = string
}

variable "incumbent_api_sa_annotation" {
  description = "The annotation added to the app-incumbent-api-service Service Account. Used to access both S3 and ECR via cross-account permissions."
  type        = string
}


# #################INGRESS  VARIABLES########################
# ##                                                       ##
# ###########################################################

variable "ingress_mpt_alb_name" {
  description = "Name of the ALB to be created by the MPT ingress"
  type        = string
}

variable "ingress_monitoring_namespace" {
  description = "Namespace where the monitoring ingress will be installed"
  type        = string
}

variable "ingress_group_name" {
  description = "Group Name for the MPT Ingress"
  type        = string
}

variable "ingress_mpt_host" {
  description = "Host name for MPT Ingress"
  type        = string
}

variable "ingress_argocd_host" {
  description = "Host name for ArgoCD Ingress"
  type        = string
}

variable "ingress_monitoring_host" {
  description = "Host name for monitoring stack Ingress"
  type        = string
}

variable "ingress_mpt_name" {
  description = "Name for MPT Ingress"
  type        = string
}

variable "ingress_argocd_name" {
  description = "Name for ArgoCD Ingress"
  type        = string
}

variable "ingress_monitoring_name" {
  description = "Name for the monitoring stack Ingress"
  type        = string
}

variable "ingress_name_app_organization_grpc_service" {
  description = "Name for app-organization-grpc-service Ingress"
  type        = string
}

variable "ingress_name_app_user_grpc_service" {
  description = "Name for app-user-grpc-service Ingress"
  type        = string
}

variable "ingress_name_app_survey_grpc_service" {
  description = "Name for app-survey-grpc-service Ingress"
  type        = string
}

variable "ingress_name_app_incumbent_grpc_service" {
  description = "Name for app-incumbent-grpc-service Ingress"
  type        = string
}

variable "ingress_name_app_user_api_swagger" {
  description = "Name for app-user-api-swagger Ingress"
  type        = string
}

variable "ingress_name_app_mpt_project_swagger" {
  description = "Name for app-mpt-project-swagger Ingress"
  type        = string
}

variable "ingress_name_app_survey_api_swagger" {
  description = "Name for app-survey-api-swagger Ingress"
  type        = string
}

variable "ingress_name_app_incumbent_api_swagger" {
  description = "Name for app_incumbent_api_swagger Ingress"
  type        = string
}

variable "ingress_swagger_endpoint" {
  description = "The ingress swagger endpoint."
  type        = string
}

variable "ingress_mpt_apps_healthcheck_endpoint" {
  description = "The healtcheck endpoint for the MPT apps."
  type        = string
}

variable "ingress_k8s_dashboard_name" {
  description = "The kubernetes-dashboard ingress name."
  type        = string
}

variable "ingress_k8s_dashboard_host" {
  description = "The kubernetes-dashboard ingress hostname."
  type        = string
}

variable "ingress_ps_name" {
  description = "Name for PS Ingress"
  type        = string
}

variable "ingress_ps_host" {
  description = "Host name for PS Ingress"
  type        = string
}

variable "ingress_ps_apps_healthcheck_endpoint" {
  description = "The healtcheck endpoint for the PS apps."
  type        = string
}

variable "ingress_ps_preview_host" {
  description = "Host name for PS Preview Ingress"
  type        = string
}

variable "ingress_ps_preview_group_name" {
  description = "Group Name for the PS Preview Ingress"
  type        = string
}

variable "ingress_mpt_preview_host" {
  description = "Host name for PS Preview Ingress"
  type        = string
}

variable "ingress_ps_preview_alb_name" {
  description = "Name of the ALB to be created by the Preview PS ingress"
  type        = string
}

variable "dns_zone_id" {}

#################KUBECOST  VARIABLES#######################
##                                                       ##
###########################################################

variable "kubecost_release_name" {
  description = "Name of release for Kubecost"
  type        = string
}

variable "kubecost_release_namespace" {
  description = "Namespace where Kubecost will be installed"
  type        = string
}

variable "kubecost_chart_repository" {
  description = "Repository for Kubecost HelmChart"
  type        = string
}

variable "kubecost_chart_name" {
  description = "Name of the Kubecost Chart"
  type        = string
}

variable "kubecost_chart_version" {
  description = "The Kubecost helm chart version."
  type        = string
}

variable "kubecost_storage_class" {
  description = "Storage class for Kubecost"
  type        = string
}

variable "ingress_kubecost_host" {
  description = "Ingress host for Kubecost"
  type        = string
}

variable "ingress_kubecost_name" {
  description = "Name for kubecost Ingress"
  type        = string
}

variable "ingress_kubecost_namespace" {
  description = "Namespace for kubecost Ingress"
  type        = string
}

variable "ingress_kubecost_alb_group" {
  description = "ALB group for kubecost Ingress"
  type        = string
}

variable "kubecost_oidc_tenant_id" {
  description = "OIDC Tenant ID"
  type        = string
}

variable "kubecost_oidc_secret_name" {
  description = "OIDC Secret Name"
  type        = string
}

#################K8S-DASHBOARD  VARIABLES##################
##                                                       ##
###########################################################

variable "k8s_dashboard_release_namespace" {
  description = "The kubernetes-dashboard helm release namespace."
  type        = string
}

variable "k8s_dashboard_release_name" {
  description = "The kubernetes-dashboard helm release name."
  type        = string
}

variable "k8s_dashboard_chart_repository" {
  description = "The kubernetes-dashboard helm chart repository."
  type        = string
}

variable "k8s_dashboard_chart_name" {
  description = "The kubernetes-dashboard helm chart name."
  type        = string
}

variable "k8s_dashboard_chart_version" {
  description = "The kubernetes-dashboard helm chart version."
  type        = string
}

#################METRIC-SERVER  VARIABLES##################
##                                                       ##
###########################################################

variable "metric_server_release_name" {
  description = "The name of the Helm release"
}
variable "metric_server_chart_repository" {
  description = "The metric server Helm chart repository."
}

variable "metric_server_chart_name" {
  description = "The name of the Helm chart to install"
}

variable "metric_server_chart_version" {
  description = "The version of the Helm chart to install"
}

variable "metric_server_release_namespace" {
  description = "The namespace Helm will install the chart under"
}

variable "helm_recreate_pods_metric" {
  description = "Perform pods restart during upgrade/rollback"
  type        = bool
}

variable "helm_cleanup_on_fail_metric" {
  type        = bool
  description = "Deletion new resources created in this upgrade if the upgrade fails"
}

variable "helm_release_timeout_seconds_metric" {
  description = "Time in seconds to wait for any individual kubernetes operation during a helm release."
}

variable "max_history_metric" {
  description = "Max History for Helm"
}

variable "helm_skip_crds_metric" {
  type        = bool
  description = "Skip installing CRDs"
}

#################CERT-MANAGER  VARIABLES###################
##                                                       ##
###########################################################

variable "cert_manager_release_namespace" {
  description = "The Cert-Manager helm release namespace."
  type        = string
}

variable "cert_manager_release_name" {
  description = "The Cert-Manager helm release name."
  type        = string
}

variable "cert_manager_chart_repository" {
  description = "The Cert-Manager helm chart repository."
  type        = string
}

variable "cert_manager_chart_name" {
  description = "The Cert-Manager helm chart name."
  type        = string
}

variable "cert_manager_chart_version" {
  description = "The Cert-Manager helm chart version."
  type        = string
}

variable "cert_manager_crds_helm_url" {
  description = "The Cert-Manager CRDs helm chart URL."
  type        = string
}

##################MONITORING  VARIABLES####################
##                                                       ##
###########################################################

variable "monitoring_namespace" {
  description = "Namespace where the monitoring resources will be installed"
  type        = string
}

variable "cni_metrics_namespace" {
  description = "The namespace where CNI PodMonitor will be installed."
}

variable "helm_releases_timeout_seconds" {
  description = "Time in seconds to wait for any individual kubernetes operation during a helm release."
}

variable "helm_releases_max_history" {
  description = "Max History for Helm"
}

### Grafana ###

variable "grafana_username" {
  description = "The Grafana username."
  type        = string
}

### Prometheus ###
variable "prometheus_release_name" {
  description = "The Prometheus helm release name."
  type        = string
}

variable "prometheus_chart_repository" {
  description = "The Prometheus helm chart repository."
  type        = string
}

variable "prometheus_chart_version" {
  description = "The Prometheus helm chart version."
  type        = string
}

variable "prometheus_chart_name" {
  description = "The Prometheus helm chart name."
  type        = string
}

variable "prometheus_helm_skip_crds" {
  type        = bool
  description = "Skip installing Prometheus CRDs"
}

variable "runbook_base_url" {
  description = "Prometheus runbook base URL."
}

variable "enable_prometheus_rules" {
  type        = bool
  description = "Adds PrometheusRules for alerts"
}

### Thanos ###
variable "enable_thanos_helm_chart" {
  description = "Enable or not Thanos Helm Chart - (do NOT confuse this with thanos sidecar within prometheus-operator)"
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

### Elasticsearch ###
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

### Jaeger ###

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

variable "jaeger_crds_helm_url" {
  description = "The Jaeger CRDs helm chart URL."
  type        = string
}
### Fluentd ###

variable "fluentd_deployment_name" {
  description = "The fluentd helm installation name."
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
