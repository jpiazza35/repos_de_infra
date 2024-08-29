variable "helm_release_timeout_seconds" {
  description = "Time in seconds to wait for any individual kubernetes operation during a helm release."
  default     = 180
}

variable "max_history" {
  description = "Max History for Helm"
  default     = 1
}

variable "metric_server_release_namespace" {
  description = "The namespace Helm will install the chart under"
}

variable "metric_server_chart_name" {
  description = "The name of the Helm chart to install"
}

variable "metric_server_chart_version" {
  description = "The Metric-Server helm chart version."
  type        = string
}

variable "metric_server_release_name" {
  description = "The name of the Helm release"
}

variable "metric_server_chart_repository" {
  description = "The repository where the Helm chart is stored"
}

variable "helm_recreate_pods" {
  type        = bool
  description = "Perform pods restart during upgrade/rollback"
  default     = true
}

variable "helm_skip_crds" {
  type        = bool
  description = "Skip installing CRDs"
  default     = false
}

variable "helm_cleanup_on_fail" {
  type        = bool
  description = "Deletion new resources created in this upgrade if the upgrade fails"
  default     = true
}
