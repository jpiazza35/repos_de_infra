### Kiali
variable "helm_namespace" {
  description = "Namespace hosting kiali resources"
  default     = "istio-system"
}

variable "kiali_helm_chart_name" {
  type        = string
  default     = "kiali-operator"
  description = "Kiali operator Helm chart name to be installed"
}

variable "kiali_helm_chart_release_name" {
  type        = string
  default     = "kiali-operator"
  description = "Helm release name"
}

variable "kiali_helm_chart_version" {
  type        = string
  default     = "1.66"
  description = "Kiali operator Helm chart version."
}

variable "kiali_helm_chart_repo" {
  type        = string
  default     = "https://kiali.org/helm-charts"
  description = "Kiali operator repository name."
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Whether to create Kubernetes namespace with name defined by `namespace`."
}

variable "istio_namespace" {
  type        = string
  default     = "istio-system"
  description = "Name of the istio namespace"
}

variable "max_history" {
  description = "Max History for Helm"
  default     = 1
}
