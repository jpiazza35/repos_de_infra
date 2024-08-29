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

variable "prometheus_release_name" {
  description = "The name of the prometheus Helm release"
}
