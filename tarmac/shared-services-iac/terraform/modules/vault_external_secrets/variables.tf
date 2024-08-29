variable "k8s_serviceaccount" {
  default = "vault-auth"
}

variable "helm_release" {
  default = "vault-external-secrets"
}

variable "helm_repository" {
  default     = "https://charts.external-secrets.io"
  description = "The repository where the Helm chart is stored"
}

variable "helm_release_timeout_seconds" {
  description = "Time in seconds to wait for any individual kubernetes operation during a helm release."
  default     = 360
}

variable "injector_replicas" {
  default = 3
}

variable "enable_injector_leader" {
  default = true
}

variable "vault_url" {
  default = "https://vault.cliniciannexus.com:8200"
}

variable "env" {
  default = "dev"
}

variable "cluster_name" {
}