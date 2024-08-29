variable "environment" {
  description = "The environment"
}

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