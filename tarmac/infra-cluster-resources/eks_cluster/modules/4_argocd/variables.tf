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
  description = "Whether to keep CRDs after helm chart uninstall."
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

variable "argocd_slack_notifications_slack_secret" {
  description = "Slack Secret for Slack Notifications"
  type        = string
}

variable "argocd_url" {
  description = "The base URL of the ArgoCD instance"
  type        = string
}

variable "argocd_sync_interval_time" {
  description = "Time in seconds for the sync interval time (10s, 20s...)"
  type        = string
}

variable "mpt_namespace" {
  description = "The map of namespaces where MPT apps are installed."
  type        = string
}

variable "mpt_preview_namespace" {
  description = "MPT Preview namespace name."
  type        = string
}

variable "preview_environment" {
  description = "The preview environment where MPT apps are installed."
  type        = string
}

variable "environment" {
  description = "tag name for the environment"
  type        = string
}

variable "helm_charts_branch_name" {
  description = "The branch in helm-charts repo that ArgoCD is deploying from."
  type        = string
}

variable "slack_channel" {
  description = "The slack channel in which to sent ArgoCD notifications."
  type        = string
}

variable "ps_namespace" {
  description = "The namespace where PS apps are installed."
  type        = string
}

variable "ps_preview_namespace" {
  description = "Performance Suite Preview namespace name."
  type        = string
}
