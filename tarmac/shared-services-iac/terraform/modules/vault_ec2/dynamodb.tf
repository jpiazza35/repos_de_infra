resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = format("%s-%s", var.env, var.app)
  billing_mode   = "PROVISIONED"
  hash_key       = "Path"
  range_key      = "Key"
  read_capacity  = 30
  write_capacity = 30

  attribute {
    name = "Path"
    type = "S"
  }
  attribute {
    name = "Key"
    type = "S"
  }

  tags = {
    Name           = format("%s-%s", var.env, var.app)
    Environment    = var.env
    backup         = "daily"
    SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
  }
}
