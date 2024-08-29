resource "aws_instance" "bastion_host" {
  ami                         = var.properties.ec2_ami_id
  instance_type               = var.properties.ec2_instance_type
  vpc_security_group_ids      = [aws_security_group.bastion_host_sg.id]
  key_name                    = var.properties.ec2_ssh_key_name
  subnet_id                   = var.public_subnet
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.bastion_profile.id
#  user_data = "" TBD

  tags = {
    Name = "${var.tags["Env"]}-${var.tags["Name"]}-host"
    env  = var.tags["Env"]
  }
}

resource "aws_eip" "bastion_host_ip" {
  vpc      = true
  instance = aws_instance.bastion_host.id

  tags = {
    Name = "${var.tags["Env"]}-${var.tags["Name"]}-eip"
    env  = var.tags["Env"]
  }

  depends_on = [aws_instance.bastion_host]
}
