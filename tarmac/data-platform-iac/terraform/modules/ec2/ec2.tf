resource "aws_instance" "main" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  iam_instance_profile = var.iam_instance_profile

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.main.id]
  user_data              = var.user_data

  root_block_device {
    volume_type           = "gp2"
    delete_on_termination = true
    volume_size           = var.volume_size
  }

  tags = {
    Name           = "${var.env}-${var.app}-ec2"
    SourcecodeRepo = "https://github.com/clinician-nexus/data-platform-iac"
  }
}
