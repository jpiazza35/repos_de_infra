module "bastion" {
  source = "../../modules/bastion"

  properties    = var.config
  public_subnet = data.aws_subnet.public_subnet.id

  tags = {
    Name = "bastion"
    Env  = "poc"
  }
}
