variable "confluent_chart_name" {
  default = "confluent-for-kubernetes"
}

variable "confluent_release_name" {
  type = string
}

variable "confluent_release_namespace" {
  type = string
}

variable "confluent_repository" {
  default     = "https://packages.confluent.io/helm"
  description = "The repository where the Helm chart is stored"
}

variable "helm_release_timeout_seconds" {
  description = "Time in seconds to wait for any individual kubernetes operation during a helm release."
  default     = 360
}