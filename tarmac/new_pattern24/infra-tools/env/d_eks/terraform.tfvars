aws_region = "us-east-1"
env        = "dev"
product    = "mpt"

k8s_cluster_name                        = "cluster-dev-oGcMTi"
argocd_release_namespace                = "mpt-apps"
argocd_release_name                     = "argo-cd"
argocd_chart_repository                 = "https://argoproj.github.io/argo-helm"
dependency_update                       = true
argocd_chart_name                       = "argo-cd"
argocd_chart_version                    = "5.24.0"
set_cluster_enabled                     = true
argocd_sso_integration_enabled          = true
argocd_sso_integration_domain_name      = "https://argocd.dev.cliniciannexus.com/"
argocd_sso_integration_clientid         = "6b02ea69-8217-4bf6-8aa5-a1ea05bf0264"
argocd_sso_integration_tennantid        = "5fe40ed0-dfbc-4a82-8a07-d07314934c3a"
argocd_sso_integration_client_secret    = "TjFOOFF+WXM1LkFtWjlHSWhHdXEtU1ljanM0amNhcUROVk05TmFsTA=="
argocd_sso_integration_group_id         = "433d0a32-f628-46cd-be92-4b5061143343"
argocd_slack_notifications_enabled      = true
argocd_slack_notifications_slack_secret = "xoxb-2858832715412-4954420694581-v4lCtXeTa84notOZkTqnwuUp"

istio_namespace        = "istio-system"
istio_chart_repository = "https://istio-release.storage.googleapis.com/charts"
istio_chart_version    = "1.17.1"

istio_base_chart_name = "base"
istio_base_helm_name  = "istio-base"

istiod_chart_name = "istiod"
istiod_helm_name  = "istiod"

istio_ingress_enabled                 = true
istio_ingress_chart_name              = "gateway"
istio_ingress_name                    = "mpt-apps-istio-ingress"
istio_ingress_helm_name               = "istio-ingressgateway"
istio_ingress_hostname                = "istio.dev.cliniciannexus.com"
istio_ingress_autoscaling_minReplicas = 1
istio_ingress_autoscaling_maxReplicas = 3
istio_ingress_service_type            = "NodePort"

install_cert_manager_crds             = true
cert_manager_namespace                = "certs-manager"
cert_manager_release_name             = "cert-manager"
cert_manager_chart_repository         = "https://charts.jetstack.io"
cert_manager_chart_name               = "cert-manager"
cert_manager_dns_zone                 = "dev.cliniciannexus.com"
cert_manager_dns_zone_id              = "Z004204123F6EY4T2V5AE"
istio_dns_record                      = "istio.dev.cliniciannexus.com"
istio_cert_secret_name                = "istio-cert-secret"
cert_manager_security_context_fsgroup = "1001"

istio_gw_type          = "ingressgateway"
istio_gw_name          = "istio-gateway"
istio_gw_port_name     = "https"
istio_gw_port          = 443
istio_gw_port_protocol = "HTTPS"

istio_vs_namespace    = "istio-mpt-apps"
mpt_ui_vs_name        = "mpt-ui-service"
mpt_ui_vs_port_number = 443

create_kiali_namespace        = false
create_custom_kiali_resources = true
kiali_release_name            = "kiali-operator"
kiali_chart_repository        = "https://kiali.org/helm-charts"
kiali_chart_name              = "kiali-operator"
kiali_auth_strategy           = "token"