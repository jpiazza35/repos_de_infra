resource "aws_msk_cluster" "msk" {
  count = var.create ? 1 : 0

  broker_node_group_info {
    az_distribution = var.broker_node_az_distribution
    client_subnets = var.broker_node_client_subnets == [] ? data.aws_subnets.private.ids : concat(
      var.broker_node_client_subnets,
      data.aws_subnets.private.ids
    )

    dynamic "connectivity_info" {
      for_each = length(var.broker_node_connectivity_info) > 0 ? [var.broker_node_connectivity_info] : []

      content {
        dynamic "public_access" {
          for_each = try([connectivity_info.value.public_access], [])

          content {
            type = try(public_access.value.type, null)
          }
        }

        dynamic "vpc_connectivity" {
          for_each = try([connectivity_info.value.vpc_connectivity], [])

          content {
            dynamic "client_authentication" {
              for_each = try([vpc_connectivity.value.client_authentication], [])

              content {
                dynamic "sasl" {
                  for_each = try([client_authentication.value.sasl], [])

                  content {
                    iam   = try(sasl.value.iam, null)
                    scram = try(sasl.value.scram, null)
                  }
                }

                tls = try(client_authentication.value.tls, null)
              }
            }
          }
        }
      }
    }

    instance_type = var.broker_node_instance_type
    security_groups = var.broker_node_security_groups == [] ? [
      aws_security_group.sg.id
      ] : concat(
      var.broker_node_security_groups,
      [
        aws_security_group.sg.id
      ]
    )

    dynamic "storage_info" {
      for_each = length(var.broker_node_storage_info) > 0 ? [var.broker_node_storage_info] : []

      content {
        dynamic "ebs_storage_info" {
          for_each = try([storage_info.value.ebs_storage_info], [])

          content {
            dynamic "provisioned_throughput" {
              for_each = try([ebs_storage_info.value.provisioned_throughput], [])

              content {
                enabled           = try(provisioned_throughput.value.enabled, null)
                volume_throughput = try(provisioned_throughput.value.volume_throughput, null)
              }
            }

            volume_size = try(ebs_storage_info.value.volume_size, 64)
          }
        }
      }
    }
  }

  dynamic "client_authentication" {
    for_each = length(var.client_authentication) > 0 ? [var.client_authentication] : []

    content {
      dynamic "sasl" {
        for_each = try([client_authentication.value.sasl], [])

        content {
          iam   = try(sasl.value.iam, null)
          scram = try(sasl.value.scram, null)
        }
      }

      dynamic "tls" {
        for_each = try([client_authentication.value.tls], [])

        content {
          certificate_authority_arns = try(tls.value.certificate_authority_arns, null)
        }
      }

      unauthenticated = try(client_authentication.value.unauthenticated, null)
    }
  }

  cluster_name = var.name

  configuration_info {
    arn      = var.create_configuration ? aws_msk_configuration.config[0].arn : var.configuration_arn
    revision = var.create_configuration ? aws_msk_configuration.config[0].latest_revision : var.configuration_revision
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = var.encryption_at_rest_kms_key_arn

    encryption_in_transit {
      client_broker = var.encryption_in_transit_client_broker
      in_cluster    = var.encryption_in_transit_in_cluster
    }
  }

  enhanced_monitoring = var.enhanced_monitoring
  kafka_version       = var.kafka_version

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = var.cloudwatch_logs_enabled
        log_group = var.cloudwatch_logs_enabled ? local.cloudwatch_log_group : null
      }

      firehose {
        enabled         = var.firehose_logs_enabled
        delivery_stream = var.firehose_delivery_stream
      }

      dynamic "s3" {
        for_each = var.access_logs["enabled"] ? [var.access_logs] : []

        content {
          enabled = s3.value.enabled
          bucket  = s3.value.bucket
          prefix  = s3.value.prefix
        }
      }
    }
  }

  number_of_broker_nodes = var.number_of_broker_nodes

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = var.jmx_exporter_enabled
      }
      node_exporter {
        enabled_in_broker = var.node_exporter_enabled
      }
    }
  }

  storage_mode = var.storage_mode

  timeouts {
    create = try(var.timeouts.create, null)
    update = try(var.timeouts.update, null)
    delete = try(var.timeouts.delete, null)
  }

  # required for appautoscaling
  lifecycle {
    ignore_changes = [
      broker_node_group_info[0].storage_info[0].ebs_storage_info[0].volume_size,
    ]
  }

  tags = var.tags
}

######## VPC Connection
resource "aws_msk_vpc_connection" "vpc" {
  for_each = { for k, v in var.vpc_connections : k => v if var.create }

  authentication     = each.value.authentication
  client_subnets     = each.value.client_subnets
  security_groups    = each.value.security_groups
  target_cluster_arn = aws_msk_cluster.msk[0].arn
  vpc_id             = each.value.vpc_id

  tags = merge(
    var.tags,
    try(each.value.tags, {})
  )
}

######## Configuration

resource "aws_msk_configuration" "config" {
  count = var.create && var.create_configuration ? 1 : 0

  name              = coalesce(var.configuration_name, var.name)
  description       = var.configuration_description
  kafka_versions    = [var.kafka_version]
  server_properties = join("\n", [for k, v in var.configuration_server_properties : format("%s = %s", k, v)])
}
