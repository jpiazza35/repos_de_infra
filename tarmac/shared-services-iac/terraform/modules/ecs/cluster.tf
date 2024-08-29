resource "aws_ecs_cluster" "cluster" {
  name = format("%s-%s-ecs-cluster", lower(var.cluster["env"]), var.cluster["name_prefix"])

  setting {
    name  = var.cluster["settings"]["name"]
    value = var.cluster["settings"]["value"]
  }

  /* configuration {
    execute_command_configuration {
      logging = "DEFAULT" #var.ecs["config"]["exec"]["logging"]==  ? 
    }
  } */

  dynamic "configuration" {
    for_each = coalesce(var.cluster["configuration"], {})

    content {
      dynamic "execute_command_configuration" {
        for_each = try(configuration.value.execute_command_configuration, [{}])

        content {
          kms_key_id = try(execute_command_configuration.value.kms_key_id, null)
          logging    = try(execute_command_configuration.value.logging, "DEFAULT")

          dynamic "log_configuration" {
            for_each = try([execute_command_configuration.value.log_configuration], [])

            content {
              cloud_watch_encryption_enabled = try(log_configuration.value.cloud_watch_encryption_enabled, null)
              cloud_watch_log_group_name     = try(log_configuration.value.cloud_watch_log_group_name, null)
              s3_bucket_name                 = try(log_configuration.value.s3_bucket_name, null)
              s3_bucket_encryption_enabled   = try(log_configuration.value.s3_bucket_encryption_enabled, null)
              s3_key_prefix                  = try(log_configuration.value.s3_key_prefix, null)
            }
          }
        }
      }
    }
  }

  dynamic "service_connect_defaults" {
    for_each = coalesce(var.cluster["service_connect_defaults"], {})

    content {
      namespace = try(service_connect_defaults.value.namespace, aws_service_discovery_http_namespace.sdhn.arn)
    }
  }

  dynamic "setting" {
    for_each = [var.cluster["settings"]]

    content {
      name  = setting.value.name
      value = setting.value.value
    }
  }

  tags = merge(
    {
      Name = format("%s-%s-ecs-cluster", lower(var.cluster["env"]), var.cluster["name_prefix"])
    },
    var.tags,
    {
      Environment    = var.cluster["env"]
      App            = var.cluster["app"]
      Resource       = "Managed by Terraform"
      Description    = "${var.cluster["app"]} Related Configuration"
      Team           = var.cluster["team"]
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )

}

resource "aws_ecs_cluster_capacity_providers" "cluster" {
  for_each = {
    for cps in var.capacity_providers : cps.provider => cps
    if cps.provider != ""
  }

  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = [
    each.value.provider
  ]

  dynamic "default_capacity_provider_strategy" {
    for_each = [each.value]
    iterator = strategy

    content {
      capacity_provider = try(strategy.value.provider, strategy.key)
      base              = try(strategy.value.base, null)
      weight            = try(strategy.value.weight, null)
    }
  }

}

resource "aws_service_discovery_http_namespace" "sdhn" {
  name        = format("%s-%s-ecs-namespace", lower(var.cluster["env"]), lower(var.cluster["app"]))
  description = "${lower(var.cluster["app"])} Service Discovery HTTP Namespace"

  tags = merge(
    {
      Name = format("%s-%s-ecs-namespace", lower(var.cluster["env"]), lower(var.cluster["app"]))
    },
    var.tags,
    {
      Environment    = var.cluster["env"]
      App            = var.cluster["app"]
      Resource       = "Managed by Terraform"
      Description    = "${var.cluster["app"]} Related Configuration"
      Team           = var.cluster["team"]
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )

}
