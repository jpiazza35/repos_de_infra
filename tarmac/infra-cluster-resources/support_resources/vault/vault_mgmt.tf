module "eks_external_secrets" {
  source             = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//vault_external_secrets?ref=1.0.78"
  k8s_serviceaccount = var.k8s_serviceaccount
  env                = var.environment
  vault_url          = var.vault_url
  cluster_name       = local.cluster_name
  depends_on = [
    module.eks_mgmt
  ]
}


module "eks_vault_auth" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//vault_mgmt?ref=1.0.78"
  providers = {
    aws.source = aws
    aws.target = aws
  }
  env                = var.environment
  paths              = var.paths
  cluster_name       = local.cluster_name
  k8s_serviceaccount = var.k8s_serviceaccount
  depends_on = [
    module.eks_external_secrets
  ]
}

data "template_file" "external_secrets_template" {
  template = file("${path.module}/files/external_secrets.yaml")
  vars = {
    environment = var.environment
    namespace   = var.mpt_namespace
  }
}

resource "null_resource" "external_secrets_apps" {
  # Trigger each time the template changes
  triggers = {
    external_secrets_template = sha256(data.template_file.external_secrets_template.rendered)
  }
  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.external_secrets_template.rendered}\nEOF"
  }
  depends_on = [module.eks_mgmt, module.eks_vault_auth]
}

data "template_file" "external_secrets_preview_template" {
  template = file("${path.module}/files/external_secrets_preview.yaml")
  vars = {
    environment = var.preview_environment
    namespace   = var.mpt_preview_namespace
  }
}

resource "null_resource" "external_secrets_preview_apps" {
  count = var.environment == "prod" ? 1 : 0
  # Trigger each time the template changes
  triggers = {
    external_secrets_template = sha256(data.template_file.external_secrets_preview_template.rendered)
  }
  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.external_secrets_preview_template.rendered}\nEOF"
  }
  depends_on = [module.eks_mgmt, module.eks_vault_auth]
}

data "template_file" "external_secrets_ps" {
  template = file("${path.module}/files/external_secrets_ps.yaml")
  vars = {
    environment = var.environment
    namespace   = var.ps_namespace
  }
}

resource "null_resource" "external_secrets_ps" {
  # Trigger each time the template changes
  triggers = {
    external_secrets_template = sha256(data.template_file.external_secrets_ps.rendered)
  }
  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.external_secrets_ps.rendered}\nEOF"
  }
  depends_on = [module.eks_mgmt, module.eks_vault_auth]
}

data "template_file" "external_secrets_preview_ps" {
  template = file("${path.module}/files/external_secrets_preview_ps.yaml")
  vars = {
    environment = var.preview_environment
    namespace   = var.ps_preview_namespace
  }
}

resource "null_resource" "external_secrets_preview_ps" {
  count = var.environment == "prod" ? 1 : 0
  # Trigger each time the template changes
  triggers = {
    external_secrets_template = sha256(data.template_file.external_secrets_preview_ps.rendered)
  }
  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.external_secrets_preview_ps.rendered}\nEOF"
  }
  depends_on = [module.eks_mgmt, module.eks_vault_auth]
}
