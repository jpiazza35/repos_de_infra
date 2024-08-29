variable "create" {
  description = "Create helm release for external-dns"
  default     = false
}

variable "env" {
  description = "The environment"
  default     = "sharedservices"
}

variable "helm_release_timeout_seconds" {
  description = "Time in seconds to wait for any individual kubernetes operation during a helm release."
  default     = 180
}

variable "max_history" {
  description = "Max History for Helm"
  default     = 1
}

variable "helm_namespace" {
  description = "The namespace Helm will install the chart under"
  default     = "external-dns"
}

variable "helm_chart" {
  default     = "external-dns"
  description = "The name of the Helm chart to install"
}

variable "chart_version" {
  description = "Version of the Helm chart"
  default     = "1.12.2"
}

variable "helm_release" {
  default     = "external-dns"
  description = "The name of the Helm release"
}

variable "helm_repository" {
  default     = "https://kubernetes-sigs.github.io/external-dns"
  description = "The repository where the Helm chart is stored"
}

variable "cluster_name" {
  description = "Target cluster name"
}
