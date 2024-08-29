resource "aws_ssm_parameter" "root_token" {
  count  = local.default
  name   = "/${var.app}/root/token"
  type   = "SecureString"
  value  = "init"
  key_id = aws_kms_key.key[count.index].id
  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "aws_ssm_parameter" "root_pass" {
  count  = local.default
  name   = "/${var.app}/root/pass"
  type   = "SecureString"
  value  = "init"
  key_id = aws_kms_key.key[count.index].id
  lifecycle {
    ignore_changes = [
      value
    ]
  }
}
