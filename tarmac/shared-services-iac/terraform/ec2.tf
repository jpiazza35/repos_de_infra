/* module "bastion_ec2" {
  source  = "./modules/ec2"
  app     = "bastion"
  env     = "shared_services"
  enabled = true

  asg_min                     = 1
  asg_max                     = 1
  asg_desired                 = 1
  associate_public_ip_address = true
  vpc_id                      = data.aws_vpc.vpc[0].id
  ami_to_find = {
    name  = "RHEL-8.6*"
    owner = "309956199498"
  }

  additional_volumes = [
    {
      "device_name"           = "/dev/xvdf"
      "delete_on_termination" = true
      "encrypted"             = true
      "volume_size"           = 40
      "volume_type"           = "gp3"
    }
  ]

  tags = merge(
    var.tags,
    {
      Environment = var.env
      App         = "bastion"
      Resource    = "Managed by Terraform"
      Description = "Bastion EC2 Related Configuration"
      Team        = "DevOps"
    }
  )
} */
