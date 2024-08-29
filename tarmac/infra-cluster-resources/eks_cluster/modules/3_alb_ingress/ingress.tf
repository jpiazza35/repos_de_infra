# ##ingress.yaml File

resource "null_resource" "apps-namespace" {

  provisioner "local-exec" {
    command = "kubectl get namespace | grep -q ${var.ingress_mpt_namespace} || kubectl create namespace ${var.ingress_mpt_namespace}"
  }
}

resource "null_resource" "monitoring_namespace" {

  provisioner "local-exec" {
    command = <<-EOT
      kubectl get namespace | grep -q ${var.ingress_monitoring_namespace} || 
      kubectl create namespace ${var.ingress_monitoring_namespace}
      kubectl patch namespace ${var.ingress_monitoring_namespace} -p '{"metadata": {"labels": {"istio-injection": "enabled"}}}'
      kubectl patch namespace ${var.ingress_monitoring_namespace} -p '{"metadata": {"labels": {"ns": "${var.ingress_monitoring_namespace}"}}}'
      kubectl patch namespace ${var.ingress_monitoring_namespace} -p '{"metadata": {"annotations": {"name": "${var.ingress_monitoring_namespace}"}}}'  
    EOT
  }
}

resource "kubectl_manifest" "alb_oidc_cluster_role" {
  yaml_body = templatefile("${path.module}/oidc/ClusterRole.yaml", {
  })
}

resource "kubectl_manifest" "alb_oidc_cluster_role_binding" {
  yaml_body = templatefile("${path.module}/oidc/ClusterRoleBinding.yaml", {
  })
}

resource "kubectl_manifest" "kubecost_oidc" {
  yaml_body = templatefile("${path.module}/oidc/kubecost.yaml", {
    ingress_kubecost_namespace  = var.ingress_kubecost_namespace,
    kubecost_oidc_client_id     = base64encode(data.vault_generic_secret.kubecost.data["azure_oidc_clientID"]),
    kubecost_oidc_client_secret = base64encode(data.vault_generic_secret.kubecost.data["azure_oidc_clientSecret"]),
  })
}

resource "null_resource" "ingress" {
  triggers = {
    ingress = sha256(templatefile("${path.module}/ingress.yaml", {
      environment                                = var.environment
      private_subnet_ids                         = join(", ", var.private_subnet_ids)
      ingress_mpt_alb_name                       = var.ingress_mpt_alb_name
      ingress_mpt_namespace                      = var.ingress_mpt_namespace
      argocd_release_namespace                   = var.argocd_release_namespace
      ingress_group_name                         = var.ingress_group_name
      ingress_mpt_host                           = var.ingress_mpt_host
      ingress_argocd_host                        = var.ingress_argocd_host
      ingress_mpt_name                           = var.ingress_mpt_name
      ingress_argocd_name                        = var.ingress_argocd_name
      ingress_name_app_organization_grpc_service = var.ingress_name_app_organization_grpc_service
      ingress_name_app_user_grpc_service         = var.ingress_name_app_user_grpc_service
      ingress_name_app_survey_grpc_service       = var.ingress_name_app_survey_grpc_service
      ingress_name_app_incumbent_grpc_service    = var.ingress_name_app_incumbent_grpc_service
      ingress_name_app_user_api_swagger          = var.ingress_name_app_user_api_swagger
      ingress_name_app_mpt_project_swagger       = var.ingress_name_app_mpt_project_swagger
      ingress_name_app_survey_api_swagger        = var.ingress_name_app_survey_api_swagger
      ingress_name_app_incumbent_api_swagger     = var.ingress_name_app_incumbent_api_swagger
      ingress_swagger_endpoint                   = var.ingress_swagger_endpoint
      ingress_mpt_apps_healthcheck_endpoint      = var.ingress_mpt_apps_healthcheck_endpoint
      ingress_certificate_arn                    = var.ingress_certificate_arn
      ingress_monitoring_name                    = var.ingress_monitoring_name
      ingress_monitoring_namespace               = var.ingress_monitoring_namespace
      ingress_monitoring_host                    = var.ingress_monitoring_host
      ingress_k8s_dashboard_name                 = var.ingress_k8s_dashboard_name
      ingress_k8s_dashboard_host                 = var.ingress_k8s_dashboard_host
      k8s_dashboard_release_namespace            = var.k8s_dashboard_release_namespace
      ingress_kubecost_name                      = var.ingress_kubecost_name
      ingress_kubecost_host                      = var.ingress_kubecost_host
      ingress_kubecost_namespace                 = var.ingress_kubecost_namespace
      kubecost_oidc_tenant_id                    = var.kubecost_oidc_tenant_id
      kubecost_oidc_secret_name                  = var.kubecost_oidc_secret_name
      ingress_ps_name                            = var.ingress_ps_name
      ingress_ps_namespace                       = var.ingress_ps_namespace
      ingress_ps_host                            = var.ingress_ps_host
      ingress_ps_apps_healthcheck_endpoint       = var.ingress_ps_apps_healthcheck_endpoint
    }))
  }
  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${templatefile("${path.module}/ingress.yaml", {
      environment                                = var.environment
      private_subnet_ids                         = join(", ", var.private_subnet_ids)
      ingress_mpt_alb_name                       = var.ingress_mpt_alb_name
      ingress_mpt_namespace                      = var.ingress_mpt_namespace
      argocd_release_namespace                   = var.argocd_release_namespace
      ingress_group_name                         = var.ingress_group_name
      ingress_mpt_host                           = var.ingress_mpt_host
      ingress_argocd_host                        = var.ingress_argocd_host
      ingress_mpt_name                           = var.ingress_mpt_name
      ingress_argocd_name                        = var.ingress_argocd_name
      ingress_name_app_organization_grpc_service = var.ingress_name_app_organization_grpc_service
      ingress_name_app_user_grpc_service         = var.ingress_name_app_user_grpc_service
      ingress_name_app_survey_grpc_service       = var.ingress_name_app_survey_grpc_service
      ingress_name_app_incumbent_grpc_service    = var.ingress_name_app_incumbent_grpc_service
      ingress_name_app_user_api_swagger          = var.ingress_name_app_user_api_swagger
      ingress_name_app_mpt_project_swagger       = var.ingress_name_app_mpt_project_swagger
      ingress_name_app_survey_api_swagger        = var.ingress_name_app_survey_api_swagger
      ingress_name_app_incumbent_api_swagger     = var.ingress_name_app_incumbent_api_swagger
      ingress_swagger_endpoint                   = var.ingress_swagger_endpoint
      ingress_mpt_apps_healthcheck_endpoint      = var.ingress_mpt_apps_healthcheck_endpoint
      ingress_certificate_arn                    = var.ingress_certificate_arn
      ingress_monitoring_name                    = var.ingress_monitoring_name
      ingress_monitoring_namespace               = var.ingress_monitoring_namespace
      ingress_monitoring_host                    = var.ingress_monitoring_host
      ingress_k8s_dashboard_name                 = var.ingress_k8s_dashboard_name
      ingress_k8s_dashboard_host                 = var.ingress_k8s_dashboard_host
      k8s_dashboard_release_namespace            = var.k8s_dashboard_release_namespace
      ingress_kubecost_name                      = var.ingress_kubecost_name
      ingress_kubecost_host                      = var.ingress_kubecost_host
      ingress_kubecost_namespace                 = var.ingress_kubecost_namespace
      kubecost_oidc_tenant_id                    = var.kubecost_oidc_tenant_id
      kubecost_oidc_secret_name                  = var.kubecost_oidc_secret_name
      kubecost_oidc_secret_name                  = var.kubecost_oidc_secret_name
      ingress_ps_name                            = var.ingress_ps_name
      ingress_ps_namespace                       = var.ingress_ps_namespace
      ingress_ps_host                            = var.ingress_ps_host
      ingress_ps_apps_healthcheck_endpoint       = var.ingress_ps_apps_healthcheck_endpoint
    })}\nEOF"
  }
  depends_on = [null_resource.apps-namespace, kubectl_manifest.kubecost_oidc]
}

## Preview ingress

resource "null_resource" "ingress_preview" {
  count = var.environment == "prod" ? 1 : 0
  triggers = {
    ingress = sha256(templatefile("${path.module}/ingress_preview.yaml", {
      environment                                = var.preview_environment
      private_subnet_ids                         = join(", ", var.private_subnet_ids)
      ingress_mpt_alb_name                       = var.ingress_mpt_alb_name
      mpt_preview_namespace                      = var.mpt_preview_namespace
      ingress_group_name                         = var.ingress_group_name
      ingress_mpt_preview_host                   = var.ingress_mpt_preview_host
      ingress_mpt_name                           = var.ingress_mpt_name
      ingress_name_app_organization_grpc_service = var.ingress_name_app_organization_grpc_service
      ingress_name_app_user_grpc_service         = var.ingress_name_app_user_grpc_service
      ingress_name_app_survey_grpc_service       = var.ingress_name_app_survey_grpc_service
      ingress_name_app_incumbent_grpc_service    = var.ingress_name_app_incumbent_grpc_service
      ingress_name_app_user_api_swagger          = var.ingress_name_app_user_api_swagger
      ingress_name_app_mpt_project_swagger       = var.ingress_name_app_mpt_project_swagger
      ingress_name_app_survey_api_swagger        = var.ingress_name_app_survey_api_swagger
      ingress_name_app_incumbent_api_swagger     = var.ingress_name_app_incumbent_api_swagger
      ingress_swagger_endpoint                   = var.ingress_swagger_endpoint
      ingress_mpt_apps_healthcheck_endpoint      = var.ingress_mpt_apps_healthcheck_endpoint
      ingress_certificate_arn                    = var.ingress_certificate_arn
      ingress_ps_name                            = var.ingress_ps_name
      ingress_ps_preview_alb_name                = var.ingress_ps_preview_alb_name
      ps_preview_namespace                       = var.ps_preview_namespace
      ingress_ps_preview_host                    = var.ingress_ps_preview_host
      ingress_ps_preview_group_name              = var.ingress_ps_preview_group_name
      public_subnet_ids                          = join(", ", var.public_subnet_ids)
      ingress_ps_apps_healthcheck_endpoint       = var.ingress_ps_apps_healthcheck_endpoint
    }))
  }
  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${templatefile("${path.module}/ingress_preview.yaml", {
      environment                                = var.preview_environment
      private_subnet_ids                         = join(", ", var.private_subnet_ids)
      ingress_mpt_alb_name                       = var.ingress_mpt_alb_name
      mpt_preview_namespace                      = var.mpt_preview_namespace
      ingress_group_name                         = var.ingress_group_name
      ingress_mpt_preview_host                   = var.ingress_mpt_preview_host
      ingress_mpt_name                           = var.ingress_mpt_name
      ingress_name_app_organization_grpc_service = var.ingress_name_app_organization_grpc_service
      ingress_name_app_user_grpc_service         = var.ingress_name_app_user_grpc_service
      ingress_name_app_survey_grpc_service       = var.ingress_name_app_survey_grpc_service
      ingress_name_app_incumbent_grpc_service    = var.ingress_name_app_incumbent_grpc_service
      ingress_name_app_user_api_swagger          = var.ingress_name_app_user_api_swagger
      ingress_name_app_mpt_project_swagger       = var.ingress_name_app_mpt_project_swagger
      ingress_name_app_survey_api_swagger        = var.ingress_name_app_survey_api_swagger
      ingress_name_app_incumbent_api_swagger     = var.ingress_name_app_incumbent_api_swagger
      ingress_swagger_endpoint                   = var.ingress_swagger_endpoint
      ingress_mpt_apps_healthcheck_endpoint      = var.ingress_mpt_apps_healthcheck_endpoint
      ingress_certificate_arn                    = var.ingress_certificate_arn
      ingress_ps_name                            = var.ingress_ps_name
      ingress_ps_preview_alb_name                = var.ingress_ps_preview_alb_name
      ps_preview_namespace                       = var.ps_preview_namespace
      ingress_ps_preview_host                    = var.ingress_ps_preview_host
      ingress_ps_preview_group_name              = var.ingress_ps_preview_group_name
      public_subnet_ids                          = join(", ", var.public_subnet_ids)
      ingress_ps_apps_healthcheck_endpoint       = var.ingress_ps_apps_healthcheck_endpoint
    })}\nEOF"
  }
  depends_on = [null_resource.apps-namespace]
}