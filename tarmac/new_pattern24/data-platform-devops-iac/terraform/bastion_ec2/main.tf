module "bastion_ec2" {
  source  = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//bastion_ec2"
  app     = var.app
  env     = var.env
  enabled = var.enabled

  asg_min                     = 1
  asg_max                     = 1
  asg_desired                 = 1
  associate_public_ip_address = true
  vpc_id                      = data.aws_vpc.vpc.id

  tags = merge(
    var.tags,
    {
      Environment    = var.env
      App            = var.app
      Resource       = "Managed by Terraform"
      Description    = "Bastion EC2 Related Configuration"
      Team           = "DevOps"
      SourceCodeRepo = "https://github.com/clinician-nexus/data-platform-devops-iac"
    }
  )
}
