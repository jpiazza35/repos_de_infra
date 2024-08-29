dynamodb_args = {
  users = {
    hash_key       = "user_id"
    hash_key_type  = "S"
    range_key      = "last_activity_date"
    range_key_type = "S"
    read_capacity  = 5
    write_capacity = 5
    billing_mode   = "PROVISIONED"
    attribute_definitions = [
      {
        name = "usertype"
        type = "S"
      }
    ]
    global_secondary_indexes = [
      {
        name            = "UserTypeIndex"
        hash_key        = "usertype"
        hash_key_type   = "S"
        range_key       = "last_activity_date"
        range_key_type  = "S"
        projection_type = "ALL"
        read_capacity   = 5
        write_capacity  = 5
      }
    ]
  },
  projects = {
    hash_key       = "project_id"
    hash_key_type  = "S"
    range_key      = "published_date"
    range_key_type = "S"
    read_capacity  = 5
    write_capacity = 5
    billing_mode   = "PROVISIONED"
    attribute_definitions = [
      {
        name = "public"
        type = "B"
      },
      {
        name = "authorid"
        type = "S"
      },
    ]
    global_secondary_indexes = [
      {
        name            = "PublicIndex"
        hash_key        = "public"
        hash_key_type   = "B"
        range_key       = "authorid"
        range_key_type  = "S"
        projection_type = "ALL"
        read_capacity   = 5
        write_capacity  = 5
      }
    ]
  }
}
