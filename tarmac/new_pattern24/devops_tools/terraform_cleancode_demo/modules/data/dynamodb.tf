resource "aws_dynamodb_table" "this" {
  name           = "${var.args.env}-${var.args.project}-${var.args.product}-${var.args.name}-dynamo-tbl"
  billing_mode   = var.args.billing_mode
  read_capacity  = var.args.read_capacity
  write_capacity = var.args.write_capacity

  hash_key  = var.args.hash_key
  range_key = var.args.range_key

  attribute {
    name = var.args.hash_key
    type = var.args.hash_key_type
  }

  attribute {
    name = var.args.range_key
    type = var.args.range_key_type
  }

  dynamic "attribute" {
    for_each = var.args.attribute_definitions
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.args.global_secondary_indexes
    content {
      name            = global_secondary_index.value.name
      hash_key        = global_secondary_index.value.hash_key
      range_key       = global_secondary_index.value.range_key
      projection_type = global_secondary_index.value.projection_type
      read_capacity   = global_secondary_index.value.read_capacity
      write_capacity  = global_secondary_index.value.write_capacity
    }
  }
}
