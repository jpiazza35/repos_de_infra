resource "aws_ecs_task_definition" "task" {
  for_each = {
    for idx, t in var.ecs_task : idx => t
  }
  family                   = coalesce(each.value.family, var.cluster["app"])
  ipc_mode                 = try(each.value.ipc_mode, null)
  pid_mode                 = try(each.value.pid_mode, null)
  execution_role_arn       = aws_iam_role.execution.arn
  network_mode             = coalesce(each.value.network_mode, "awsvpc")
  requires_compatibilities = try(each.value.requires_compatibilities, ["FARGATE"])
  cpu                      = coalesce(each.value.task_cpu, 256)
  memory                   = coalesce(each.value.task_memory, 512)
  task_role_arn            = each.value.task_role_arn != "" ? try(each.value.task_role_arn) : aws_iam_role.task.arn

  dynamic "ephemeral_storage" {
    for_each = {
      for idx, s in each.value.ephemeral_storage : idx => s
      if s.size_in_gib != null
    }

    content {
      size_in_gib = try(each.value.size_in_gib, 21)
    }
  }

  container_definitions = each.value.task_definitions == null ? jsonencode(local.definition) : each.value.task_definitions

  dynamic "inference_accelerator" {
    for_each = each.value.inference_accelerator != null ? [each.value.inference_accelerator] : []

    content {
      device_name = try(inference_accelerator.value.device_name, null)
      device_type = try(inference_accelerator.value.device_type, null)
    }
  }

  dynamic "runtime_platform" {
    for_each = [each.value.runtime_platform]

    content {
      operating_system_family = try(runtime_platform.value.operating_system_family, "LINUX")

      cpu_architecture = try(runtime_platform.value.cpu_architecture, "X86_64")
    }

  }

  dynamic "placement_constraints" {
    for_each = [each.value.placement_constraints] != [] ? each.value.placement_constraints : [{}]
    content {
      expression = try(placement_constraints.value.expression, null)
      type       = try(placement_constraints.value.type, "memberOf")
    }
  }

  dynamic "proxy_configuration" {
    for_each = each.value.proxy_configuration != null ? [each.value.proxy_configuration] : []
    content {
      container_name = try(proxy_configuration.value.container_name, null)
      properties     = try(proxy_configuration.value.properties, null)
      type           = try(proxy_configuration.value.type, "APPMESH")
    }
  }

  dynamic "volume" {
    for_each = each.value.volume != null ? each.value.volume : []
    content {
      name      = volume.value.name
      host_path = lookup(volume.value, "host_path", null)

      dynamic "docker_volume_configuration" {
        for_each = lookup(volume.value, "docker_volume_configuration", [])
        content {
          scope         = lookup(docker_volume_configuration.value, "scope", null)
          autoprovision = lookup(docker_volume_configuration.value, "autoprovision", false)
          driver        = lookup(docker_volume_configuration.value, "driver", null)
          driver_opts   = lookup(docker_volume_configuration.value, "driver_opts", null)
          labels        = lookup(docker_volume_configuration.value, "labels", null)
        }
      }

      dynamic "efs_volume_configuration" {
        for_each = lookup(volume.value, "efs_volume_configuration", [])
        content {
          file_system_id          = lookup(efs_volume_configuration.value, "file_system_id", null)
          root_directory          = lookup(efs_volume_configuration.value, "root_directory", null)
          transit_encryption      = lookup(efs_volume_configuration.value, "transit_encryption", "ENABLED")
          transit_encryption_port = lookup(efs_volume_configuration.value, "transit_encryption_port", null)

          dynamic "authorization_config" {
            for_each = length(lookup(efs_volume_configuration.value, "authorization_config", {})) == 0 ? [] : [lookup(efs_volume_configuration.value, "authorization_config", {})]
            content {
              access_point_id = lookup(authorization_config.value, "access_point_id", null)
              iam             = lookup(authorization_config.value, "iam", null)
            }
          }
        }
      }
    }
  }

  tags = merge(
    var.tags,
    {},
  )
}
