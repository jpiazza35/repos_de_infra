
#################KIALI VARIABLES###########################
##                                                        ##
############################################################

variable "kiali_release_name" {
  description = "name of the chart release for kiali"
  type        = string
}

variable "kiali_chart_repository" {
  description = "repository of the kiali Helm chart to deploy"
  type        = string
}


variable "kiali_chart_name" {
  description = "name of kiali Helm chart to deploy"
  type        = string
}


variable "istio_namespace" {
  description = "it is the same namespace where istio base and istiod is deployed, so we use the same"
  type        = string

}

variable "create_kiali_namespace" {
  description = "Whether to create a namespace for Kiali."
  type        = bool
}

variable "create_custom_kiali_resources" {
  description = "Whether to create custom Kiali resources."
  type        = bool
}


variable "kiali_auth_strategy" {
  description = "The auth.strategy for Kiali."
  type        = string

}