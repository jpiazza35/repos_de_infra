resource "aws_dynamodb_table" "my-terraform-lock" {
  count        = local.default
  name         = var.dynamodb_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
