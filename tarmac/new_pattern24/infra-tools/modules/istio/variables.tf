variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "env" {
  description = "Environment where to deploy infrastructure."
  type        = string
}

variable "product" {
  description = "Clinician Nexus product suite name (e.g. MPT, PPMT etc.)"
  type        = string
}

#################ISTIO base VARIABLES#####################
##                                                        ##
############################################################

variable "istio_base_helm_name" {
  description = "name of the chart release for istio base"
  type        = string
}

variable "istio_namespace" {
  description = "Namespace where istiobase and istiod will be installed"
  type        = string
}

variable "istio_chart_repository" {
  description = "repository of the istio base and istiod Helm chart to deploy"
  type        = string
}

variable "istio_base_chart_name" {
  description = "name of the istio base Helm chart to deploy"
  type        = string
}

variable "istio_chart_version" {
  description = "Version of the Istio helm chart."
  type        = string
}

#################ISTIOD VARIABLES###########################
##                                                        ##
############################################################

variable "istiod_chart_name" {
  description = "name of the istiod  Helm chart to deploy"
  type        = string
}

variable "istiod_helm_name" {
  description = "name of the chart release for istiod"
  type        = string
}

#################ISTIO INGRESS VARIABLES####################
##                                                        ##
############################################################

variable "istio_ingress_chart_name" {
  description = "name of the istiod  Helm chart to deploy"
  type        = string
}

variable "istio_ingress_helm_name" {
  description = "name of the chart release for istio ingress"
  type        = string
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

################## CERT-MANAGER VARIABLES ##################
##                                                        ##
############################################################

variable "cert_manager_env" {
  description = "Cert maager environment."
  type        = string
}

variable "cert_manager_namespace" {
  description = "Cert manager namespace."
  type        = string
}

variable "cert_manager_project" {
  description = "Cert manager project name."
  type        = string
}

variable "cert_manager_role_trust_policy" {
  description = "The trust policy for the cert-manager IAM role."
  type        = string
}

variable "cert_manager_role_access_policy" {
  description = "The IAM policy granting access to AWS services to the cert-manager IAM role."
  type        = string
}

variable "cert_manager_release_name" {
  description = "Cert manager helm release name."
  type        = string
}

variable "cert_manager_chart_repository" {
  description = "Cert manager Helm chart repository."
  type        = string
}


variable "cert_manager_chart_name" {
  description = "Cert manager Helm chart name."
  type        = string
}

variable "install_cert_manager_crds" {
  description = "Whether to create CRDs for cert manager."
  type        = bool
}

variable "cert_manager_dns_zone" {
  description = "The DNS zone used in Cert Manager."
  type        = string
}

variable "cert_manager_dns_zone_id" {
  description = "The DNS zone ID used in Cert Manager."
  type        = string
}

variable "cert_manager_security_context_fsgroup" {
  description = "The Certs Manager securityContext.fsGroup."
  type        = string
}

variable "istio_dns_record" {
  description = "The DNS record for Istio GW used in Cert Manager certificate."
  type        = string
}

variable "istio_cert_secret_name" {
  description = "The secret name for Istio GW used in Cert Manager certificate."
  type        = string
}

### ISTIO INGRESS VARIABLES ###

variable "istio_ingress_enabled" {
  description = "Enable/disable ingress istio."
}

variable "istio_ingress_hostname" {
  description = "spec.rules.host in the Istio ingress resource."
  type        = string
}

variable "istio_ingress_name" {
  description = "Istio Ingress name."
}

### ISTIO GATEWAY VARIABLES ###
variable "istio_gw_type" {
  description = "The spec.selector for the Istio GW."
}

variable "istio_gw_name" {
  description = "Istio Gateway name."
}

variable "istio_gw_port" {
  description = "Istio GW port number."
  type        = string
}

variable "istio_gw_port_name" {
  description = "Istio GW port name."
  type        = string
}

variable "istio_gw_port_protocol" {
  description = "Istio GW port protocol."
  type        = string
}

#### ISTIO VIRTUALSERVICES VARIABLES #####
variable "istio_vs_namespace" {
  description = "The Istio Virtual Services namespace."
  type        = string
}

variable "mpt_ui_vs_name" {
  description = "The MPT UI Virtual Service name."
}

variable "mpt_ui_vs_port_number" {
  description = "The MPT UI VS port number."
  type        = string
}
