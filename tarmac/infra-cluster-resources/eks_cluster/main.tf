################################################################################
# EKS Module
################################################################################

module "eks_mgmt" {
  source = "./modules/1_eks"

  services_cidr      = var.services_cidr
  vpc_id             = data.aws_vpc.aws-vpc.id
  private_subnet_ids = data.aws_subnets.private_subnets.ids
  local_subnet_ids   = data.aws_subnets.local_subnets.ids
  aws_region         = var.aws_region

  cluster_name = local.cluster_name
  environment  = var.environment

  use_node_group_name_prefix = var.use_node_group_name_prefix

  cluster_version    = var.cluster_version
  key_name           = "${local.cluster_name}-eks-keypair"
  is_eks_api_public  = var.is_eks_api_public
  is_eks_api_private = var.is_eks_api_private

  asg_metrics_lambda_name    = var.asg_metrics_lambda_name
  asg_metrics_lambda_runtime = var.asg_metrics_lambda_runtime

  min_size = var.min_size
  max_size = var.max_size
  des_size = var.des_size

  acc_id                   = [data.aws_caller_identity.current.account_id]
  iam_roles                = var.iam_roles
  instance_types           = var.instance_types
  capacity_type            = var.capacity_type
  ami_type                 = var.ami_type
  disk_size                = var.disk_size
  ebs_csi_addon_version    = var.ebs_csi_addon_version
  coredns_addon_version    = var.coredns_addon_version
  kube_proxy_addon_version = var.kube_proxy_addon_version
  aws_admin_sso_role_arn   = local.sso_role_arn[0]
  mpt_namespace            = var.mpt_namespace
  mpt_preview_namespace    = var.mpt_preview_namespace
  ps_namespace             = var.ps_namespace
  ps_preview_namespace     = var.ps_preview_namespace
}

resource "null_resource" "kubectl_update" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.aws_region} --name ${local.cluster_name}"
  }
  depends_on = [module.eks_mgmt]
}


resource "random_string" "random_string" {
  length  = 6
  special = false
}



################################################################################
# SSH KEY
################################################################################

## SSH key for EKS nodes
### Create key
resource "tls_private_key" "eks_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

### Add to AWS
resource "aws_key_pair" "aws_eks_ssh_key" {
  key_name   = "${local.cluster_name}-eks-keypair"
  public_key = tls_private_key.eks_ssh_key.public_key_openssh
  tags = {
    Name           = "${local.cluster_name}-eks-keypair"
    SourcecodeRepo = "https://github.com/clinician-nexus/infra-cluster-resources"
  }
}

### Save to vault
resource "vault_generic_secret" "eks_ssh_key_vault_save" {
  path = "${var.environment}/secrets/${local.cluster_name}/eks_ssh_key"

  data_json = <<EOT
{
  "ssh_key": "${base64encode(tls_private_key.eks_ssh_key.private_key_pem)}"
}
EOT
}


################################################################################
## Cluster permissions
################################################################################

### Permissions
# # role binding for EKS cluster

# resource "kubectl_manifest" "authmap_rolebinding" {
#   yaml_body = yamldecode("${path.module}/files/rolebinding.yaml")

#   depends_on = [
#     null_resource.kubectl_update
#   ]
# }


################################################################################
# Kubernetes SA
################################################################################


resource "kubectl_manifest" "incumbent_api_sa" {
  yaml_body = templatefile("${path.module}/files/app-incumbent-api-sa.yaml", {
    namespace                   = var.mpt_namespace
    incumbent_api_sa_annotation = var.incumbent_api_sa_annotation
  })

  depends_on = [
    module.eks_mgmt, module.argocd, null_resource.kubectl_update
  ]
}


################################################################################
# Kubernetes SA for Preview
################################################################################

resource "kubectl_manifest" "incumbent_api_sa_preview" {
  count = var.environment == "prod" ? 1 : 0
  yaml_body = templatefile("${path.module}/files/app-incumbent-api-sa-preview.yaml", {
    namespace                   = var.mpt_preview_namespace
    incumbent_api_sa_annotation = var.incumbent_api_sa_annotation
  })

  depends_on = [
    module.eks_mgmt, module.argocd, null_resource.kubectl_update
  ]
}


module "acm" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//acm?ref=1.0.78"
  providers = {
    aws = aws
  }
  env             = var.environment
  dns_zone_id     = var.dns_zone_id
  dns_name        = var.environment == "prod" ? "cliniciannexus.com" : "${var.environment}.cliniciannexus.com"
  san             = var.environment == "prod" ? ["*.preview"] : [] # Add the new subdomain for prod environment in this case preview
  create_wildcard = true                                           ## Should a wildcard certificate be created, if omitted, you must specify value(s) for the `san` variable
  tags = merge(
    {
      Resource       = "Managed by Terraform"
      Description    = "DNS Related Configuration"
      Team           = "DevOps" ## Name of the team requesting the creation of the DNS resource
      SourcecodeRepo = "https://github.com/clinician-nexus/infra-cluster-resources"
    }
  )

  depends_on = [null_resource.kubectl_update, module.eks_mgmt]

}


###############################################################################
# AWS ACM VALIDATION
###############################################################################

module "aws_acm_validation" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//acm_validation?ref=1.0.78"
  providers = {
    aws            = aws
    aws.ss_network = aws.ss_network
  }
  env         = var.environment
  dns_name    = "cliniciannexus.com"
  dns_zone_id = var.dns_zone_id
  cert        = module.acm.cert

  depends_on = [module.acm, null_resource.kubectl_update, module.eks_mgmt]

}


################################################################################
## Ingress configuration
################################################################################

module "ingress" {
  source = "./modules/3_alb_ingress"

  providers = {
    aws            = aws
    aws.ss_network = aws.ss_network
  }

  environment                                = var.environment
  preview_environment                        = var.preview_environment
  private_subnet_ids                         = data.aws_subnets.private_subnets.ids
  public_subnet_ids                          = data.aws_subnets.public_subnets.ids
  ingress_mpt_alb_name                       = var.ingress_mpt_alb_name
  ingress_mpt_namespace                      = var.mpt_namespace
  argocd_release_namespace                   = var.argocd_release_namespace
  ingress_group_name                         = var.ingress_group_name
  ingress_mpt_host                           = var.ingress_mpt_host
  ingress_argocd_host                        = var.ingress_argocd_host
  ingress_mpt_name                           = var.ingress_mpt_name
  ingress_argocd_name                        = var.ingress_argocd_name
  ingress_monitoring_name                    = var.ingress_monitoring_name
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
  ingress_monitoring_namespace               = var.ingress_monitoring_namespace
  ingress_monitoring_host                    = var.ingress_monitoring_host
  mpt_preview_namespace                      = var.mpt_preview_namespace
  ingress_mpt_preview_host                   = var.ingress_mpt_preview_host
  ingress_k8s_dashboard_name                 = var.ingress_k8s_dashboard_name
  ingress_k8s_dashboard_host                 = var.ingress_k8s_dashboard_host
  k8s_dashboard_release_namespace            = var.k8s_dashboard_release_namespace
  ingress_kubecost_host                      = var.ingress_kubecost_host
  ingress_kubecost_name                      = var.ingress_kubecost_name
  ingress_kubecost_namespace                 = var.ingress_kubecost_namespace
  kubecost_oidc_tenant_id                    = var.kubecost_oidc_tenant_id
  kubecost_oidc_secret_name                  = var.kubecost_oidc_secret_name

  ingress_ps_name                      = var.ingress_ps_name
  ingress_ps_namespace                 = var.ps_namespace
  ingress_ps_host                      = var.ingress_ps_host
  ingress_ps_apps_healthcheck_endpoint = var.ingress_ps_apps_healthcheck_endpoint
  ps_preview_namespace                 = var.ps_preview_namespace
  ingress_ps_preview_host              = var.ingress_ps_preview_host
  ingress_ps_preview_group_name        = var.ingress_ps_preview_group_name
  ingress_ps_preview_alb_name          = var.ingress_ps_preview_alb_name

  ingress_certificate_arn = module.acm.arn

  cluster_name = local.cluster_name
  vpc          = data.aws_vpc.aws-vpc
  tags         = {}

  depends_on = [module.acm, module.external_dns]

}


################################################################################
## Argo Deployment
################################################################################

module "argocd" {
  source                                  = "./modules/4_argocd"
  environment                             = var.environment
  preview_environment                     = var.preview_environment
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
  argocd_sso_integration_client_secret    = data.vault_generic_secret.argocd_secret.data["sso_integration_client_secret"]
  argocd_slack_notifications_enabled      = var.argocd_slack_notifications_enabled
  argocd_slack_notifications_slack_secret = data.vault_generic_secret.argocd_secret.data["slack_notifications_slack_secret"]
  argocd_url                              = local.argocd_url
  mpt_namespace                           = var.mpt_namespace
  mpt_preview_namespace                   = var.mpt_preview_namespace
  ps_namespace                            = var.ps_namespace
  ps_preview_namespace                    = var.ps_preview_namespace
  helm_charts_branch_name                 = var.helm_charts_branch_name
  argocd_sync_interval_time               = var.argocd_sync_interval_time
  argocd_keep_crds_uninstall              = var.argocd_keep_crds_uninstall
  slack_channel                           = var.slack_channel

  depends_on = [null_resource.kubectl_update, module.eks_mgmt]
}


################################################################################
## Kubecost
################################################################################

module "kubecost" {
  source                     = "git::https://github.com/clinician-nexus/shared-services-iac.git//terraform/modules/kubecost?ref=1.0.78"
  kubecost_release_name      = var.kubecost_release_name
  kubecost_release_namespace = var.kubecost_release_namespace
  kubecost_chart_repository  = var.kubecost_chart_repository
  kubecost_chart_name        = var.kubecost_chart_name
  kubecost_chart_version     = var.kubecost_chart_version
  kubecost_storage_class     = var.kubecost_storage_class
  environment                = var.environment

  depends_on = [null_resource.kubectl_update, module.eks_mgmt]
}

##############################################################################
## External-dns
################################################################################


module "external_dns" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//external-dns?ref=1.0.78"

  providers = {
    aws            = aws
    aws.ss_network = aws.ss_network
  }

  env            = var.environment
  helm_namespace = "kube-system"

  depends_on = [null_resource.kubectl_update, module.eks_mgmt]
}

##############################################################################
## metric-server
################################################################################

module "metric_server" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//metrics-server?ref=1.0.78"

  metric_server_release_name      = var.metric_server_release_name
  metric_server_chart_repository  = var.metric_server_chart_repository
  metric_server_chart_name        = var.metric_server_chart_name
  metric_server_chart_version     = var.metric_server_chart_version
  metric_server_release_namespace = var.metric_server_release_namespace
  helm_recreate_pods              = var.helm_recreate_pods_metric
  helm_cleanup_on_fail            = var.helm_cleanup_on_fail_metric
  helm_release_timeout_seconds    = var.helm_release_timeout_seconds_metric
  max_history                     = var.max_history_metric
  helm_skip_crds                  = var.helm_skip_crds_metric

  depends_on = [null_resource.kubectl_update]
}

#############################################################################
# cert-manager
###############################################################################
resource "null_resource" "cert_manager_crds" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
      kubectl apply --namespace ${var.cert_manager_release_namespace} -f ${var.cert_manager_crds_helm_url}
    EOT
  }

  depends_on = [null_resource.kubectl_update]
}

module "cert_manager" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//cert-manager?ref=1.0.78"

  providers = {
    aws            = aws
    aws.ss_network = aws.ss_network
  }

  environment                    = var.environment
  cert_manager_release_name      = var.cert_manager_release_name
  cert_manager_release_namespace = var.cert_manager_release_namespace
  cert_manager_chart_repository  = var.cert_manager_chart_repository
  cert_manager_chart_name        = var.cert_manager_chart_name
  cert_manager_chart_version     = var.cert_manager_chart_version

  depends_on = [
    null_resource.cert_manager_crds
  ]
}

##############################################################################
## k8s-dashboard
################################################################################

module "kubernetes_dashboard" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//kubernetes-dashboard?ref=1.0.78"

  k8s_dashboard_release_name      = var.k8s_dashboard_release_name
  k8s_dashboard_release_namespace = var.k8s_dashboard_release_namespace
  k8s_dashboard_chart_repository  = var.k8s_dashboard_chart_repository
  k8s_dashboard_chart_name        = var.k8s_dashboard_chart_name
  k8s_dashboard_chart_version     = var.k8s_dashboard_chart_version
  prometheus_release_name         = var.prometheus_release_name

  depends_on = [null_resource.kubectl_update]
}

#############################################################################
# monitoring
###############################################################################

resource "null_resource" "jaeger_crds" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
      kubectl apply --namespace ${var.monitoring_namespace} -f ${var.jaeger_crds_helm_url}
    EOT
  }

  depends_on = [null_resource.kubectl_update]
}

module "monitoring" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//monitoring?ref=1.0.89"


  providers = {
    aws            = aws
    aws.ss_network = aws.ss_network
    aws.infra_prod = aws.infra_prod
  }

  environment = var.environment

  monitoring_namespace          = var.monitoring_namespace
  monitoring_ingress            = var.ingress_monitoring_host
  cni_metrics_namespace         = var.cni_metrics_namespace
  argocd_release_namespace      = var.argocd_release_namespace
  helm_releases_timeout_seconds = var.helm_releases_timeout_seconds
  helm_releases_max_history     = var.helm_releases_max_history

  prometheus_release_name     = var.prometheus_release_name
  prometheus_chart_repository = var.prometheus_chart_repository
  prometheus_chart_version    = var.prometheus_chart_version
  prometheus_chart_name       = var.prometheus_chart_name
  prometheus_helm_skip_crds   = var.prometheus_helm_skip_crds
  runbook_base_url            = var.runbook_base_url
  enable_prometheus_rules     = var.enable_prometheus_rules

  enable_thanos_helm_chart = var.enable_thanos_helm_chart
  thanos_release_name      = var.thanos_release_name
  thanos_chart_repository  = var.thanos_chart_repository
  thanos_chart_version     = var.thanos_chart_version
  thanos_chart_name        = var.thanos_chart_name

  grafana_username = var.grafana_username

  elasticsearch_release_name                 = var.elasticsearch_release_name
  elasticsearch_chart_repository             = var.elasticsearch_chart_repository
  elasticsearch_chart_version                = var.elasticsearch_chart_version
  elasticsearch_chart_name                   = var.elasticsearch_chart_name
  elasticsearch_docker_image                 = var.elasticsearch_docker_image
  elasticsearch_docker_image_tag             = var.elasticsearch_docker_image_tag
  elasticsearch_major_version                = var.elasticsearch_major_version
  elasticsearch_cluster_name                 = var.elasticsearch_cluster_name
  elasticsearch_psp_enable                   = var.elasticsearch_psp_enable
  elasticsearch_rbac_enable                  = var.elasticsearch_rbac_enable
  elasticsearch_client_resources             = var.elasticsearch_client_resources
  elasticsearch_client_replicas              = var.elasticsearch_client_replicas
  elasticsearch_client_persistence_disk_size = var.elasticsearch_client_persistence_disk_size
  elasticsearch_master_resources             = var.elasticsearch_master_resources
  elasticsearch_master_minimum_replicas      = var.elasticsearch_master_minimum_replicas
  elasticsearch_master_replicas              = var.elasticsearch_master_replicas
  elasticsearch_master_persistence_disk_size = var.elasticsearch_master_persistence_disk_size
  elasticsearch_data_resources               = var.elasticsearch_data_resources
  elasticsearch_data_replicas                = var.elasticsearch_data_replicas
  elasticsearch_data_persistence_disk_size   = var.elasticsearch_data_persistence_disk_size

  jaeger_release_name     = var.jaeger_release_name
  jaeger_chart_repository = var.jaeger_chart_repository
  jaeger_chart_version    = var.jaeger_chart_version
  jaeger_chart_name       = var.jaeger_chart_name

  fluentd_deployment_name  = var.fluentd_deployment_name
  fluentd_chart_repository = var.fluentd_chart_repository
  fluentd_chart_name       = var.fluentd_chart_name
  fluentd_chart_version    = var.fluentd_chart_version

  telegraf_chart_repository = var.telegraf_chart_repository
  telegraf_chart_name       = var.telegraf_chart_name
  telegraf_chart_version    = var.telegraf_chart_version
  telegraf_deployment_name  = var.telegraf_deployment_name

  influxdb_chart_name       = var.influxdb_chart_name
  influxdb_chart_version    = var.influxdb_chart_version
  influxdb_chart_repository = var.influxdb_chart_repository
  influxdb_deployment_name  = var.influxdb_deployment_name
  influxdb_organization     = var.influxdb_organization
  influxdb_user             = var.influxdb_user
  influxdb_bucket           = var.influxdb_bucket

  depends_on = [
    null_resource.jaeger_crds
  ]
}

