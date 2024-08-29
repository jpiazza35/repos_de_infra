variable "env" {
  description = "The environment"
  default     = "sharedservices"
}

variable "prefix" {
  description = "Prefix for thanos S3 Bucket"
  default     = "sstools"
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
  default     = "kube-system"
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

