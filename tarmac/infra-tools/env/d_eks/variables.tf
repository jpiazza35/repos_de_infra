variable "k8s_cluster_name" {
  description = "Kubernetes cluster name used to generate kubeconfig file"
  type        = string
}

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

variable "istio_chart_version" {
  description = "Version of the Istio helm chart."
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
variable "istio_ingress_enabled" {
  description = "Enable/disable ingres istio"
}

variable "istio_ingress_name" {
  description = "Istio Ingress name."
}

variable "istio_ingress_hostname" {
  description = "spec.rules.host in the Istio ingress resource."
  type        = string
}

variable "istio_ingress_chart_name" {
  description = "name of the istiod  Helm chart to deploy"
  type        = string
}

variable "istio_ingress_helm_name" {
  description = "The name for the Istio ingress helm chart."
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

#################ARGOCD  VARIABLES##########################
##                                                        ##
############################################################

variable "argocd_release_namespace" {
  description = "Namespace where argocd will be installed"
  type        = string
}

variable "argocd_release_name" {
  description = "release of the ArgoCD Helm chart to deploy"
  type        = string
}

variable "argocd_chart_repository" {
  description = "repository of the ArgoCD Helm chart to deploy"
  type        = string
}

variable "dependency_update" {
  description = "Indicates if dependencies of the ArgoCD chart should be updated before installation"
  type        = bool
}

variable "argocd_chart_name" {
  description = "name of the ArgoCD Helm chart to deploy"
  type        = string
}

variable "argocd_chart_version" {
  description = "Version of the ArgoCD Helm chart to deploy"
  type        = string
}

variable "set_cluster_enabled" {
  description = "this is the set that make the cluster enabled"
  type        = bool
}

variable "argocd_sso_integration_enabled" {
  description = "Enable/disable SSO Integration for ArgoCD"
  default     = false
}

variable "argocd_sso_integration_domain_name" {
  description = "ArgoCD Domain Name"
  default     = "https://argocd.dev.cliniciannexus.com/"
}

variable "argocd_sso_integration_clientid" {
  description = "ClientID in Azure Portal for ArgoCD App"
  default     = ""
}

variable "argocd_sso_integration_group_id" {
  description = "GroupID in Azure Portal for ArgoCD App"
  default     = ""
}

variable "argocd_sso_integration_tennantid" {
  description = "TennantID in Azure Portal for ArgoCD App"
  default     = ""
}

variable "argocd_sso_integration_client_secret" {
  description = "Client Secret (Application) in Azure Portal for ArgoCD App"
  default     = ""
}

variable "argocd_slack_notifications_enabled" {
  description = "Enable/disable Slack Notifications for ArgoCD"
  default     = false
}

variable "argocd_slack_notifications_slack_secret" {
  description = "Slack Secret for Slack Notifications"
  type        = string
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

########### ISTIO VIRTUAL SERVICES VARIABLES ###############
##                                                        ##
############################################################

variable "istio_vs_namespace" {
  description = "The Istio Virtual Services namespace."
  type        = string
}

variable "mpt_ui_vs_name" {
  description = "name of the istiod  Helm chart to deploy"
  type        = string
}

variable "mpt_ui_vs_port_number" {
  description = "name of the chart release for istiod"
  type        = string
}

################# CERT MANAGER VARIABLES ###################
##                                                        ##
############################################################
variable "cert_manager_namespace" {
  description = "namespace for cert-manager"
  type        = string
}

variable "cert_manager_dns_zone" {
  description = "The DNS zone used in Cert Manager."
  type        = string
}

variable "cert_manager_dns_zone_id" {
  description = "The DNS zone ID used in Cert Manager."
  type        = string
}

variable "cert_manager_release_name" {
  description = "name of the chart release for cert manager"
  type        = string
}

variable "cert_manager_chart_repository" {
  description = "repository of the cert_manager Helm chart to deploy"
  type        = string
}

variable "cert_manager_chart_name" {
  description = "name of the  cert_manager Helm chart to deploy"
  type        = string
}

variable "install_cert_manager_crds" {
  description = "Whether to create CRDs for cert manager."
  type        = bool
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

################# KIALI VARIABLES ##########################
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

variable "kiali_auth_strategy" {
  description = "The auth.strategy for Kiali."
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
