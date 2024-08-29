resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket_prefix == "" ? var.s3_bucket_name : "${var.s3_bucket_prefix}-${var.s3_bucket_name}"
  tags   = merge(var.tags, var.s3_bucket_envs)
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = var.s3_bucket_acl
}

resource "aws_s3_bucket_website_configuration" "s3_bucket_configuration" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  index_document {
    suffix = var.s3_bucket_configuration_index
  }

  error_document {
    key = var.s3_bucket_configuration_error
  }
  ## Have some troubles here, need a routing_rule=json not working with this format
  dynamic "routing_rule" {
    for_each = var.s3_bucket_routing_rule_enable ? ["true"] : []
    content {
      condition {
        key_prefix_equals = var.s3_bucket_key_prefix_equals
      }
      redirect {
        replace_key_prefix_with = var.s3_bucket_replace_key_prefix_with
      }
    }
  }
  #TODO: posible solution
  #routing_rule = var.s3_bucket_routing_rule_enable ? concat(var.s3_bucket_routing_condition,var.s3_bucket_routing_redirect) : {}
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_block" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = var.s3_bucket_block_public_acls
  block_public_policy     = var.s3_bucket_block_public_policy
  restrict_public_buckets = var.s3_bucket_block_public_restrict
  ignore_public_acls      = var.s3_bucket_block_public_ignore_acls
}

#TODO: reuse s3 module to create this bucket
resource "aws_s3_bucket" "s3_bucket_log" {
  bucket = var.s3_bucket_prefix == "" ? var.s3_bucket_log_name : "${var.s3_bucket_prefix}-${var.s3_bucket_log_name}"
  tags   = merge(var.tags, var.s3_bucket_envs)
}

#Same ACL from s3 web bucket
resource "aws_s3_bucket_acl" "s3_bucket_log_acl" {
  bucket = aws_s3_bucket.s3_bucket_log.id
  acl    = var.s3_bucket_acl
}
#Same Blocks from s3 web bucket
resource "aws_s3_bucket_public_access_block" "s3_bucket_log_block" {
  bucket                  = aws_s3_bucket.s3_bucket_log.id
  block_public_acls       = var.s3_bucket_block_public_acls
  block_public_policy     = var.s3_bucket_block_public_policy
  restrict_public_buckets = var.s3_bucket_block_public_restrict
  ignore_public_acls      = var.s3_bucket_block_public_ignore_acls
}

#TODO: reuse s3 module to create this bucket
resource "aws_s3_bucket" "load_balancer_bucket_log" {
  bucket = var.load_balancer_bucket_log_name
  tags   = var.tags
}

#Same Blocks from s3 web bucket
resource "aws_s3_bucket_public_access_block" "load_balancer_bucket_log_block" {
  bucket                  = aws_s3_bucket.load_balancer_bucket_log.id
  block_public_acls       = var.s3_bucket_block_public_acls
  block_public_policy     = var.s3_bucket_block_public_policy
  restrict_public_buckets = var.s3_bucket_block_public_restrict
  ignore_public_acls      = var.s3_bucket_block_public_ignore_acls
}

resource "aws_s3_bucket_policy" "load_balancer_bucket_access" {
  bucket = aws_s3_bucket.load_balancer_bucket_log.bucket
  policy = templatefile("../../modules/s3/load_balancer_access.json", {
    environment = var.environment
    account     = var.account_id_lb_aws
  })
}

resource "aws_s3_bucket" "s3_bucket_datalake" {
  bucket = var.s3_bucket_datalake_name
  tags   = merge(var.tags, var.s3_bucket_envs)
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_datalake_block" {
  bucket                  = aws_s3_bucket.s3_bucket_datalake.id
  block_public_acls       = var.s3_bucket_block_public_acls
  block_public_policy     = var.s3_bucket_block_public_policy
  restrict_public_buckets = var.s3_bucket_block_public_restrict
  ignore_public_acls      = var.s3_bucket_block_public_ignore_acls
}


resource "aws_s3_bucket" "s3_bucket_scripts" {
  bucket = var.s3_bucket_scripts_name
  tags   = merge(var.tags, var.s3_bucket_envs)
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_scripts_block" {
  bucket                  = aws_s3_bucket.s3_bucket_scripts.id
  block_public_acls       = var.s3_bucket_block_public_acls
  block_public_policy     = var.s3_bucket_block_public_policy
  restrict_public_buckets = var.s3_bucket_block_public_restrict
  ignore_public_acls      = var.s3_bucket_block_public_ignore_acls
}


