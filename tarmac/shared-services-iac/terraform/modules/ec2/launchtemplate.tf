resource "aws_launch_template" "app" {
  count = local.default

  name = "lt-${var.app}-${var.env}-${data.aws_region.current[count.index].name}"

  image_id      = data.aws_ami.ubuntu[count.index].id
  instance_type = var.instance_type
  key_name      = aws_key_pair.bastion[count.index].key_name
  user_data     = var.user_data

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = var.vol_size
      volume_type           = var.vol_type
      encrypted             = true
      kms_key_id            = aws_kms_key.key[count.index].arn
      delete_on_termination = true
    }
  }

  dynamic "block_device_mappings" {
    for_each = { for idx, volume in var.additional_volumes : idx => {
      device_name           = lookup(volume, "device_name", "/dev/xvdf")
      delete_on_termination = lookup(volume, "delete_on_termination", false)
      encrypted             = lookup(volume, "encrypted", false)
      volume_size           = lookup(volume, "volume_size", 30)
      volume_type           = lookup(volume, "volume_type", "gp2")
    } }
    content {
      device_name = block_device_mappings.value.device_name
      ebs {
        delete_on_termination = block_device_mappings.value.delete_on_termination
        encrypted             = block_device_mappings.value.encrypted
        volume_size           = block_device_mappings.value.volume_size
        volume_type           = block_device_mappings.value.volume_type
      }
    }
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2[count.index].arn
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  lifecycle {
    create_before_destroy = true
  }

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    security_groups = [
      aws_security_group.bastion[count.index].id
    ]
    delete_on_termination = true
  }

  update_default_version = true

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = format("%s-%s", var.env, var.app)
    }
  }

  tags = merge(
    var.tags,
    tomap(
      {
        "Name"         = "lt-${var.app}-${var.env}-${data.aws_region.current[count.index].name}"
        SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
      }
    )
  )

}
