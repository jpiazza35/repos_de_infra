/*resource "aws_instance" "instance" {
  ami = var.instance_ami
  instance_type = var.instance_type
  tags = merge(var.tags, var.instance_tags)
  user_data = data.template_file.instance_user_data.rendered
  iam_instance_profile = var.instance_secret_manager_profile.name
  key_name = aws_key_pair.instnaces_key_pair.key_name
  root_block_device {
    volume_type = "gp2"
    volume_size = var.instance_volume_size
  }
  network_interface {
    network_interface_id = aws_network_interface.instance_interface.id
    device_index         = 0
  }
}
resource "aws_network_interface" "instance_interface" {
  subnet_id   = element(var.instance_subnet, 0) 
  tags = {
    Name = "primary_network_interface"
  }
  #security_groups      = var.instance_security_group
}
resource "aws_key_pair" "instnaces_key_pair" {
  key_name = "automation-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCUwK9YBEUikOV/8aHBVwYCKkd3qH/sn9dczM6j3jucqm/E1xid1Kbk1u/NNE8zm1P4z6oKLjkHsJb+CTeochRoC2IjuHvvoHP+l7kXhtJ2TLAL2DmNeLLgHHb2VN0TJaxFFQ2Vt8PMoLoE1nonj4hkxeRlfFfUE/VYTyt1ogC2hVWVImzp5r+JBbNChh8rnitgNGGxoJhk7iVQNzj5jqR16IbKabqy3RlLRN9x1cz0sXzv+6k1K0OYkn8uBmUMxWjLwmAoUyZfltTJAnm+l88FUc6krczHDRpkiQYlhcbbZC2NKNA8QqAz7MKxAdfzseEqHs03N3ktf2VSgkbqum/b"
}
*/

/* code to add volume to ec2 
resource "aws_ebs_volume" "instance_volume" {
  availability_zone = var.instance_volume_az
  size              = var.instance_volume_size
  tags              = var.tags
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/xvda"
  volume_id   = aws_ebs_volume.instance_volume.id
  instance_id = aws_instance.instance.id
}*/


resource "aws_instance" "instance2" {
  ami                  = var.instance_ami
  instance_type        = var.instance_type
  tags                 = merge(var.tags, var.instance_tags)
  user_data            = data.template_file.instance_user_data2.rendered
  iam_instance_profile = var.instance_secret_manager_profile.name
  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }
  network_interface {
    network_interface_id = aws_network_interface.instance_interface2.id
    device_index         = 0
  }
}
resource "aws_network_interface" "instance_interface2" {
  subnet_id = element(var.instance_subnet, 0)
  tags = {
    Name = "primary_network_interface"
  }
}
