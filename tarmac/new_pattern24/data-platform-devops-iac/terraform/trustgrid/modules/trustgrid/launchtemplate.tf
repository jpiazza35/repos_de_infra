resource "aws_launch_template" "app" {


  name = "lt-${var.app}-${var.env}-${data.aws_region.current.name}"

  image_id               = data.aws_ami.trustgrid.id
  instance_type          = var.instance_type
  user_data              = base64encode(data.template_cloudinit_config.server_config.rendered)
  update_default_version = true

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = var.vol_size
      volume_type           = "gp2"
      encrypted             = true
      kms_key_id            = aws_kms_key.key.arn
      delete_on_termination = true
    }
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2.arn
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  # private subnet eni
  dynamic "network_interfaces" {
    for_each = { for n in var.eni : n => n
    if n == "data" }
    content {
      description                 = "${title(network_interfaces.key)} Trustgrid ENI"
      device_index                = network_interfaces.value
      associate_public_ip_address = false
      security_groups = [
        aws_security_group.ec2.id
      ]
      delete_on_termination = true
    }
  }

  # network_interfaces {
  #     description                 = "Management Trustgrid ENI"
  #     device_index                = 0
  #     #associate_public_ip_address = true
  #     security_groups = [
  #       aws_security_group.ec2.id
  #     ]
  #     delete_on_termination = true
  #     network_interface_id = local.ni_id[0]
  # }

  # public subnet eni
  # dynamic "network_interfaces" {
  #   for_each = aws_network_interface.public_ni[local.subnet_id[0]]

  #   content {
  #     description                 = "Management Trustgrid ENI"
  #     device_index                = 0
  #     associate_public_ip_address = true
  #     security_groups = [
  #       aws_security_group.ec2.id
  #     ]
  #     delete_on_termination = true
  #     network_interface_id = network_interfaces.value
  #   }
  # }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = format("%s-%s", var.app, var.env)
    }
  }

  tags = merge(
    var.tags,
    tomap(
      {
        "Name" = "lt-${var.app}-${var.env}-${data.aws_region.current.name}"
      }
    )
  )

}


resource "aws_launch_template" "secondary" {


  name = "lt-secondary-${var.app}-${var.env}-${data.aws_region.current.name}"

  image_id               = data.aws_ami.trustgrid.id
  instance_type          = var.instance_type
  user_data              = base64encode(data.template_cloudinit_config.server_config_secondary.rendered)
  update_default_version = true

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = var.vol_size
      volume_type           = "gp2"
      encrypted             = true
      kms_key_id            = aws_kms_key.key.arn
      delete_on_termination = true
    }
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2.arn
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  # private subnet eni
  dynamic "network_interfaces" {
    for_each = { for n in var.eni : n => n
    if n == "data" }
    content {
      description                 = "${title(network_interfaces.key)} Trustgrid ENI"
      device_index                = network_interfaces.value
      associate_public_ip_address = false
      security_groups = [
        aws_security_group.ec2.id
      ]
      delete_on_termination = true
    }
  }

  # network_interfaces {
  #     description                 = "Management Trustgrid ENI"
  #     device_index                = 0
  #     #associate_public_ip_address = true
  #     security_groups = [
  #       aws_security_group.ec2.id
  #     ]
  #     delete_on_termination = true
  #     network_interface_id = local.ni_id[0]
  # }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = format("%s-%s-secondary", var.app, var.env)
    }
  }

  tags = merge(
    var.tags,
    tomap(
      {
        "Name" = "lt-${var.app}-${var.env}-secondary-${data.aws_region.current.name}"
      }
    )
  )

}
