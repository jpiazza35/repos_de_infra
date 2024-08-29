resource "aws_dynamodb_table" "sso_users" {
  name           = var.dyndb_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = var.dyndb_read_capacity
  write_capacity = var.dyndb_write_capacity
  hash_key       = var.dyndb_sso_users_list_hash_key
  range_key      = var.dyndb_sso_users_list_range_key

  attribute {
    name = var.dyndb_sso_users_list_hash_key
    type = "S"
  }

  attribute {
    name = var.dyndb_sso_users_list_range_key
    type = "S"
  }

  tags = var.tags
}

# resource "aws_dynamodb_table" "iam_failed_login" {
#   name           = var.dyndb_iam_failed_table_name
#   billing_mode   = "PROVISIONED"
#   read_capacity  = var.dyndb_read_capacity
#   write_capacity = var.dyndb_write_capacity
#   hash_key       = var.dyndb_failed_logins_hash_key
#   range_key      = var.dyndb_failed_logins_range_key

#   attribute {
#     name = var.dyndb_failed_logins_hash_key
#     type = "S"
#   }

#   attribute {
#     name = var.dyndb_failed_logins_range_key
#     type = "S"
#   }

#   tags = var.tags
# }

# resource "aws_dynamodb_table" "sso_failed_login" {
#   name           = var.dyndb_sso_failed_table_name
#   billing_mode   = "PROVISIONED"
#   read_capacity  = var.dyndb_read_capacity
#   write_capacity = var.dyndb_write_capacity
#   hash_key       = var.dyndb_failed_logins_hash_key
#   range_key      = var.dyndb_failed_logins_range_key

#   attribute {
#     name = var.dyndb_failed_logins_hash_key
#     type = "S"
#   }

#   attribute {
#     name = var.dyndb_failed_logins_range_key
#     type = "S"
#   }

#   tags = var.tags
# }