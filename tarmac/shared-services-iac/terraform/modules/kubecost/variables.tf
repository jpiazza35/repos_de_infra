variable "environment" {
  description = "Environment tag for the ingress"
  type        = string
}

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
