locals {

  template_vars = {
    project = "devops",

    env = var.environment,

    name = "letsencrypt-${var.environment}",

    email = "devops@cliniciannexus.com",

    namespace = var.cert_manager_release_namespace,

    cluster_name = local.cluster_name[0]

    cluster_name = var.cluster_name == "" ? [
      for c in [
        for eks in data.aws_eks_clusters.cluster.names : eks
      ] : c
    ] : [var.cluster_name]

  }

  issuer_helm_chart_values = templatefile(
    "${path.module}/certs/values.yaml.tpl",
    local.template_vars
  )

}
