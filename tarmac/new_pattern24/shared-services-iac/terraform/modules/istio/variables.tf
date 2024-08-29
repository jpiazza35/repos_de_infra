variable "env" {
  description = "The environment"
}

variable "basenamechart" {
  description = "name of the chart release"
  type        = string
}

variable "cluster_domain_name" {
  description = "The cluster domain - used by externalDNS and certmanager to create URLs"
}

variable "chartVersion" {
  description = "version of the chart"
  type        = string
}

variable "istiodname" {
  description = "name of the chart release for istiod"
  type        = string
}

variable "helm_namespace" {
  description = "Namespace hosting istio resources"
}
variable "helm_release_timeout_seconds" {
  description = "Time in seconds to wait for any individual kubernetes operation during a helm release."
}

variable "istio_ingress_autoscaling_minReplicas" {
  description = "autoscaling.minReplicas for istio ingress"
  type        = string
}

variable "istio_ingress_autoscaling_maxReplicas" {
  description = "autoscaling.maxReplicas for istio ingress"
  type        = string
}

variable "istio_ingress_service_type" {
  description = "service.type for istio ingress"
  type        = string
}

variable "istio_ingress_hostname" {
  description = "Istio ingress hostname."
  type        = string
}
