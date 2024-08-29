resource "aws_instance" "vpn" {

  ami           = var.instance_ami
  ebs_optimized = true
  instance_type = var.instance_type
  monitoring    = false
  key_name      = var.key_pair
  subnet_id     = element(tolist(var.public_subnets), 0)
  # private_ip                  = var.private_ip
  vpc_security_group_ids      = [aws_security_group.vpn.id]
  source_dest_check           = true
  disable_api_termination     = true
  associate_public_ip_address = true

  # root_block_device {
  #   volume_type           = var.ebs_type
  #   volume_size           = var.root_volume_size
  #   delete_on_termination = true
  # }

  tags = merge(
    {
      "Name" = "${var.tags["Environment"]}-server"
    },
    var.tags,
  )

  volume_tags = merge(
    {
      "Name" = "vol-${var.tags["Environment"]}-server-root"
    },
    var.tags,
  )
}

resource "aws_eip" "vpn" {
  vpc        = true
  instance   = aws_instance.vpn.id
  depends_on = [aws_instance.vpn]

  tags = {
    Name = "${var.tags["Environment"]}-server-eip"
  }
}
