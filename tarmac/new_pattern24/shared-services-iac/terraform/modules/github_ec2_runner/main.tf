module "ec2" {
  source        = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//ec2?ref=42db87a12c9c7255c97aef446fd5eff6961960d8"
  enabled       = true
  app           = var.app
  env           = var.env
  instance_type = var.instance_type

  user_data = base64encode(templatefile("user_data.sh.tftpl", {
    repository_url = var.repository_url
    token          = var.github_token
    runner_name    = var.runner_name
    labels         = join(",", var.runner_labels)
  }))
}