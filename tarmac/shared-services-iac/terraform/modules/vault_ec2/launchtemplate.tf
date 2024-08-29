resource "aws_launch_template" "app" {
  count = local.default

  name = "lt-${var.app}-${var.env}-${data.aws_region.current[count.index].name}"

  image_id      = data.aws_ami.ubuntu[count.index].id
  instance_type = var.instance_type
  user_data = base64encode(templatefile("${path.module}/user_data/refresh.sh",
    {
      kms_key          = aws_kms_key.key[count.index].id
      vault_url        = "https://releases.hashicorp.com/vault/${var.vault_version}/vault_${var.vault_version}_linux_${local.arch_version[var.arch]}.zip"
      aws_region       = data.aws_region.current[count.index].name
      arch_version     = local.arch_version[var.arch]
      cluster_size     = var.asg_desired
      app_name         = var.app
      environment      = var.env
      cluster_dns_name = "${var.app}.cliniciannexus.com"
  }))

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = var.vol_size
      volume_type           = "gp2"
      encrypted             = true
      kms_key_id            = aws_kms_key.key[count.index].arn
      delete_on_termination = true
    }
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2[count.index].arn
  }

  lifecycle {
    create_before_destroy = true
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [
      aws_security_group.vault[count.index].id
    ]
    delete_on_termination = true
  }

  update_default_version = true

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = format("%s-%s-vault", var.env, var.app)
    }
  }

  tags = merge(
    var.tags,
    tomap(
      {
        "Name"           = "lt-${var.app}-${var.env}-${data.aws_region.current[count.index].name}"
        "SourcecodeRepo" = "https://github.com/clinician-nexus/shared-services-iac"
      }
    )
  )

}
