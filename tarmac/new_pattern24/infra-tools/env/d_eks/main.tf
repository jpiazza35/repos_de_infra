module "argocd" {
  source                                  = "../../modules/argocd"
  argocd_release_namespace                = var.argocd_release_namespace
  argocd_release_name                     = var.argocd_release_name
  argocd_chart_repository                 = var.argocd_chart_repository
  dependency_update                       = var.dependency_update
  argocd_chart_name                       = var.argocd_chart_name
  argocd_chart_version                    = var.argocd_chart_version
  set_cluster_enabled                     = var.set_cluster_enabled
  argocd_sso_integration_enabled          = var.argocd_sso_integration_enabled
  argocd_sso_integration_domain_name      = var.argocd_sso_integration_domain_name
  argocd_sso_integration_clientid         = var.argocd_sso_integration_clientid
  argocd_sso_integration_tennantid        = var.argocd_sso_integration_tennantid
  argocd_sso_integration_client_secret    = var.argocd_sso_integration_client_secret
  argocd_slack_notifications_enabled      = var.argocd_slack_notifications_enabled
  argocd_slack_notifications_slack_secret = var.argocd_slack_notifications_slack_secret
}

# module "istio" {
#   source     = "../../modules/istio"
#   aws_region = var.aws_region
#   env        = var.env
#   product    = var.product

#   istio_base_helm_name   = var.istio_base_helm_name
#   istio_namespace        = var.istio_namespace
#   istio_chart_repository = var.istio_chart_repository
#   istio_base_chart_name  = var.istio_base_chart_name
#   istio_chart_version    = var.istio_chart_version

#   istiod_helm_name                      = var.istiod_helm_name
#   istiod_chart_name                     = var.istiod_chart_name
#   istio_ingress_helm_name               = var.istio_ingress_helm_name
#   istio_ingress_chart_name              = var.istio_ingress_chart_name
#   istio_ingress_autoscaling_minReplicas = var.istio_ingress_autoscaling_minReplicas
#   istio_ingress_autoscaling_maxReplicas = var.istio_ingress_autoscaling_maxReplicas
#   istio_ingress_service_type            = var.istio_ingress_service_type

#   install_cert_manager_crds             = var.install_cert_manager_crds
#   cert_manager_env                      = var.env
#   cert_manager_namespace                = var.cert_manager_namespace
#   cert_manager_project                  = var.product
#   cert_manager_release_name             = var.cert_manager_release_name
#   cert_manager_chart_repository         = var.cert_manager_chart_repository
#   cert_manager_chart_name               = var.cert_manager_chart_name
#   cert_manager_dns_zone                 = var.cert_manager_dns_zone
#   cert_manager_dns_zone_id              = var.cert_manager_dns_zone_id
#   cert_manager_security_context_fsgroup = var.cert_manager_security_context_fsgroup
#   cert_manager_role_trust_policy        = data.aws_iam_policy_document.cert_manager_role_trust_policy.json
#   cert_manager_role_access_policy       = data.aws_iam_policy_document.cert_manager_role_access_policy.json
#   istio_dns_record                      = var.istio_dns_record
#   istio_cert_secret_name                = var.istio_cert_secret_name

#   istio_ingress_enabled  = var.istio_ingress_enabled
#   istio_ingress_hostname = var.istio_ingress_hostname
#   istio_ingress_name     = var.istio_ingress_name
#   istio_gw_type          = var.istio_gw_type
#   istio_gw_name          = var.istio_gw_name
#   istio_gw_port          = var.istio_gw_port
#   istio_gw_port_name     = var.istio_gw_port_name
#   istio_gw_port_protocol = var.istio_gw_port_protocol
#   istio_vs_namespace     = var.istio_vs_namespace
#   mpt_ui_vs_name         = var.mpt_ui_vs_name
#   mpt_ui_vs_port_number  = var.mpt_ui_vs_port_number
# }

# module "kiali" {
#   source                        = "../../modules/istio/kiali"
#   create_kiali_namespace        = var.create_kiali_namespace
#   create_custom_kiali_resources = var.create_custom_kiali_resources
#   kiali_release_name            = var.kiali_release_name
#   istio_namespace               = var.istio_namespace
#   kiali_chart_repository        = var.kiali_chart_repository
#   kiali_chart_name              = var.kiali_chart_name
#   kiali_auth_strategy           = var.kiali_auth_strategy
# }