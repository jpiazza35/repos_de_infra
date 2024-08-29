resource "aws_elasticsearch_domain" "open_search" {
  count = var.create_opensearch ? 1 : 0

  domain_name           = "${var.tags["Moniker"]}-${var.tags["Application"]}-open-search"
  elasticsearch_version = var.elasticsearch_version

  ebs_options {
    ebs_enabled = var.open_search_ebs_volume_size > 0 ? true : false
    volume_size = var.open_search_ebs_volume_size
    volume_type = var.open_search_ebs_volume_type
  }

  encrypt_at_rest {
    enabled = var.open_search_encrypt_at_rest_enabled
  }

  domain_endpoint_options {
    enforce_https       = var.domain_endpoint_options_enforce_https
    tls_security_policy = var.domain_endpoint_options_tls_security_policy
  }

  cluster_config {
    instance_count           = var.open_search_instance_count
    instance_type            = var.open_search_instance_type
    dedicated_master_enabled = var.open_search_dedicated_master_enabled
    dedicated_master_count   = var.open_search_dedicated_master_enabled ? var.open_search_dedicated_master_count : null
    dedicated_master_type    = var.open_search_dedicated_master_enabled ? var.open_search_dedicated_master_type : null
    zone_awareness_enabled   = var.open_search_zone_awareness_enabled
    warm_enabled             = var.open_search_warm_enabled
    warm_count               = var.open_search_warm_enabled ? var.open_search_warm_count : null
    warm_type                = var.open_search_warm_enabled ? var.open_search_warm_type : null

    dynamic "zone_awareness_config" {
      for_each = var.open_search_availability_zone_count > 1 ? [true] : []
      content {
        availability_zone_count = var.open_search_availability_zone_count
      }
    }
  }

  node_to_node_encryption {
    enabled = var.open_search_node_to_node_encryption_enabled
  }

  advanced_security_options {
    enabled                        = var.open_search_advanced_security_options_enabled
    internal_user_database_enabled = var.open_search_internal_user_database_enabled

    master_user_options {
      master_user_arn      = var.open_search_internal_user_database_enabled ? "" : ""
      master_user_name     = var.open_search_internal_user_database_enabled ? var.open_search_master_user_name : ""
      master_user_password = var.open_search_internal_user_database_enabled ? var.open_search_master_user_password : ""
    }
  }

  # For multi-az change open_search_zone_awareness_enabled,
  # open_search_availability_zone_count and private_subnets variables.
  vpc_options {
    security_group_ids = [element(concat(aws_security_group.open_search.*.id, tolist([""])), 0)]
    subnet_ids         = var.private_subnets
  }

  snapshot_options {
    automated_snapshot_start_hour = var.open_search_automated_snapshot_start_hour
  }

  tags = var.tags

  depends_on = [aws_iam_service_linked_role.open_search]
}

resource "aws_elasticsearch_domain_policy" "open_search" {
  count = var.create_opensearch ? 1 : 0

  domain_name     = element(concat(aws_elasticsearch_domain.open_search.*.domain_name, tolist([""])), 0)
  access_policies = element(concat(data.template_file.open_search.*.rendered, tolist([""])), 0)

  depends_on = [aws_elasticsearch_domain.open_search]
}
