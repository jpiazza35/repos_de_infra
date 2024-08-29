resource "aws_ecs_task_definition" "task" {
  count                    = local.default
  family                   = var.app
  execution_role_arn       = aws_iam_role.execution[count.index].arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_definition_cpu
  memory                   = var.task_definition_memory
  task_role_arn            = aws_iam_role.task[count.index].arn

  dynamic "ephemeral_storage" {
    for_each = var.task_definition_ephemeral_storage == 0 ? [] : [var.task_definition_ephemeral_storage]
    content {
      size_in_gib = var.task_definition_ephemeral_storage
    }
  }
  container_definitions = jsonencode([
    {
      name      = "phpipam-web"
      image     = "163032254965.dkr.ecr.${var.region}.amazonaws.com/phpipam-web-ecr-repo:latest"
      cpu       = 128
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        },
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.main[0].name
          awslogs-stream-prefix = var.app
          awslogs-region        = var.region
        }
      },
      healthCheck : {
        command : [
          "CMD-SHELL",
          "mysqladmin ping -h phpipam-mariadb.c247fifybbbt.us-east-1.rds.amazonaws.com"
        ],
        interval : 5,
        timeout : 5,
        retries : 3
      },
      ephemeralStorage = {
        sizeInGiB = 4
      },
      mountPoints = [
        {
          "containerPath" : "/phpipam/css/images/logo",
          "sourceVolume" : "phpipam-logo",
          "readOnly" : false
        },
        {
          "containerPath" : "/usr/local/share/ca-certificates",
          "sourceVolume" : "phpipam-ca",
          "readOnly" : true
        },
      ],
      environment : [
        {
          "name" : "hostname",
          "value" : "phpipam-web"
        },
        {
          "name" : "TZ",
          "value" : "America/New_York"
        },
        {
          "name" : "IPAM_DATABASE_HOST",
          "value" : "${var.rds_endpoint}"
        },
        {
          "name" : "IPAM_DATABASE_PASS",
          "value" : "${jsondecode(data.aws_secretsmanager_secret_version.rds_password[count.index].secret_string)["password"]}"
        },
        {
          "name" : "IPAM_DATABASE_PORT",
          "value" : "3306"
        },
        {
          "name" : "IPAM_DATABASE_USER",
          "value" : "${jsondecode(data.aws_secretsmanager_secret_version.rds_password[count.index].secret_string)["username"]}"
        },
        {
          "name" : "IPAM_DATABASE_NAME",
          "value" : "phpipam"
        },
      ],
    },
    {
      name         = "phpipam-cron"
      image        = "163032254965.dkr.ecr.${var.region}.amazonaws.com/phpipam-cron-ecr-repo:latest"
      cpu          = 128
      memory       = 256
      essential    = true
      portMappings = [],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.main[0].name
          awslogs-stream-prefix = "ecs"
          awslogs-region        = "${var.region}"
        }
      },
      ephemeralStorage = {
        sizeInGiB = 4
      },
      mountPoints = [],
      healthCheck : {
        command : [
          "CMD-SHELL",
          "mysqladmin ping -h phpipam-mariadb.c247fifybbbt.us-east-1.rds.amazonaws.com"
        ],
        interval : 5,
        timeout : 5,
        retries : 3
      },
      environment : [
        {
          "name" : "TZ",
          "value" : "America/New_York"
        },
        {
          "name" : "IPAM_DATABASE_HOST",
          "value" : "${var.rds_endpoint}"
        },
        {
          "name" : "IPAM_DATABASE_PASS",
          "value" : "${jsondecode(data.aws_secretsmanager_secret_version.rds_password[count.index].secret_string)["password"]}"
        },
        {
          "name" : "IPAM_DATABASE_USER",
          "value" : "${jsondecode(data.aws_secretsmanager_secret_version.rds_password[count.index].secret_string)["username"]}"
        },
        {
          "name" : "IPAM_DATABASE_NAME",
          "value" : "phpipam"
        },
        {
          "name" : "SCAN_INTERVAL",
          "value" : "1h"
        },
      ],
    },
  ])

  volume {
    name = "phpipam-logo"
  }

  volume {
    name = "phpipam-ca"
  }

  volume {
    name = "phpipam-db-data"
  }

  runtime_platform {
    operating_system_family = var.operating_system_family
    cpu_architecture        = var.cpu_architecture
  }

  dynamic "placement_constraints" {
    for_each = var.placement_constraints
    content {
      expression = lookup(placement_constraints.value, "expression", null)
      type       = placement_constraints.value.type
    }
  }

  dynamic "proxy_configuration" {
    for_each = var.proxy_configuration
    content {
      container_name = proxy_configuration.value.container_name
      properties     = lookup(proxy_configuration.value, "properties", null)
      type           = lookup(proxy_configuration.value, "type", null)
    }
  }

  dynamic "volume" {
    for_each = var.volume
    content {
      name      = volume.value.name
      host_path = lookup(volume.value, "host_path", null)

      dynamic "docker_volume_configuration" {
        for_each = lookup(volume.value, "docker_volume_configuration", [])
        content {
          scope         = lookup(docker_volume_configuration.value, "scope", null)
          autoprovision = lookup(docker_volume_configuration.value, "autoprovision", null)
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
          transit_encryption      = lookup(efs_volume_configuration.value, "transit_encryption", null)
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
    {
      Name = "phpipam"
    },
  )
}
