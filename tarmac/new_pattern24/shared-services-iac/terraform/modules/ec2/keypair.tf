resource "tls_private_key" "keypair" {
  count     = local.default
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion" {
  count      = local.default
  key_name   = format("%s-%s-keypair", var.env, var.app)
  public_key = tls_private_key.keypair[count.index].public_key_openssh
  tags = {
    Name = format("%s-%s-keypair", var.env, var.app)
  }
}

resource "aws_secretsmanager_secret" "private_key" {
  count      = local.default
  name       = format("%s_%s_ec2_private_key", var.env, var.app)
  kms_key_id = aws_kms_key.key[count.index].key_id
}

resource "aws_secretsmanager_secret" "public_key" {
  count      = local.default
  name       = format("%s_%s_ec2_public_key", var.env, var.app)
  kms_key_id = aws_kms_key.key[count.index].key_id
}

resource "aws_secretsmanager_secret_version" "public_key" {
  count         = local.default
  secret_id     = aws_secretsmanager_secret.public_key[count.index].id
  secret_string = tls_private_key.keypair[count.index].public_key_pem
}

resource "aws_secretsmanager_secret_version" "private_key" {
  count         = local.default
  secret_id     = aws_secretsmanager_secret.private_key[count.index].id
  secret_string = tls_private_key.keypair[count.index].private_key_pem
}
