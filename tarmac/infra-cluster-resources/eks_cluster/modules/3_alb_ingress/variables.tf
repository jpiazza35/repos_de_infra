variable "ingress_mpt_alb_name" {
  description = "Name of the ALB to be created by the MPT ingress"
  type        = string
}

variable "ingress_mpt_namespace" {
  description = "Namespace where the MPT ingress will be installed"
  type        = string
}

variable "argocd_release_namespace" {
  description = "Namespace where argocd will be installed"
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

variable "ingress_mpt_preview_host" {
  description = "Host name for MPT PREVIEW Ingress"
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

variable "ingress_kubecost_host" {
  description = "Host name for kubecost Ingress"
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

variable "kubecost_oidc_tenant_id" {
  description = "OIDC Tenant ID"
  type        = string
}

variable "kubecost_oidc_secret_name" {
  description = "OIDC Secret Name"
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
  description = "Name for organization-grpc-service Ingress"
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

variable "ingress_certificate_arn" {
  description = "Ingress certificate Arn"
  type        = string
}

variable "environment" {
  description = "tag name for the environment"
  type        = string
}

variable "preview_environment" {
  description = "The preview environment where MPT apps are installed."
  type        = string
}

variable "private_subnet_ids" {
  description = "List of subnet IDs to create resources in"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of subnet IDs to create resources in"
  type        = list(string)
}

variable "ingress_swagger_endpoint" {
  description = "The ingress swagger endpoint."
  type        = string
}

variable "ingress_mpt_apps_healthcheck_endpoint" {
  description = "The healtcheck endpoint for the MPT apps."
  type        = string
}

variable "mpt_preview_namespace" {
  description = "namespace name for preview env"
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

variable "k8s_dashboard_release_namespace" {
  description = "The kubernetes-dashboard namespace."
  type        = string
}

variable "cluster_name" {}

variable "vpc" {}

variable "tags" {}

variable "ingress_ps_name" {
  description = "Name for PS Ingress"
  type        = string
}

variable "ingress_ps_host" {
  description = "Host name for PS Ingress"
  type        = string
}

variable "ingress_ps_namespace" {
  description = "Namespace where the MPT ingress will be installed"
  type        = string
}

variable "ingress_ps_apps_healthcheck_endpoint" {
  description = "The healtcheck endpoint for the PS apps."
  type        = string
}

variable "ps_preview_namespace" {
  description = "The preview Performance Suite apps namespace"
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

variable "ingress_ps_preview_alb_name" {
  description = "Name of the ALB to be created by the Preview PS ingress"
  type        = string
}
