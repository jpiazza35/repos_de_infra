resource "aws_ecs_task_definition" "incident_bot" {
  count                    = local.default
  family                   = var.incident_bot_app
  execution_role_arn       = aws_iam_role.execution[count.index].arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.incident_bot_task_definition_cpu
  memory                   = var.incident_bot_task_definition_memory
  task_role_arn            = aws_iam_role.task[count.index].arn


  container_definitions = jsonencode([
    {
      "name" : "incident-bot",
      "image" : var.incident_bot_task_container_image,
      "cpu" : var.incident_bot_task_container_cpu,
      "portMappings" : [
        {
          "name" : "incident-bot-3000-tcp",
          "containerPort" : 3000,
          "hostPort" : 3000,
          "protocol" : "tcp",
          "appProtocol" : "http"
        }
      ],
      "essential" : true,
      "environment" : [
        {
          "name" : "POSTGRES_USER",
          "value" : "${jsondecode(data.aws_secretsmanager_secret_version.incident_bot[count.index].secret_string)["username"]}"
        },
        {
          "name" : "POSTGRES_PASSWORD",
          "value" : "${jsondecode(data.aws_secretsmanager_secret_version.incident_bot[count.index].secret_string)["password"]}"
        },
        {
          "name" : "POSTGRES_DB",
          "value" : "${jsondecode(data.aws_secretsmanager_secret_version.incident_bot[count.index].secret_string)["database"]}"
        },
        {
          "name" : "SLACK_APP_TOKEN",
          "value" : "${jsondecode(data.aws_secretsmanager_secret_version.incident_bot[count.index].secret_string)["SLACK_APP_TOKEN"]}"
        },
        {
          "name" : "SLACK_BOT_TOKEN",
          "value" : "${jsondecode(data.aws_secretsmanager_secret_version.incident_bot[count.index].secret_string)["SLACK_BOT_TOKEN"]}"
        },
        {
          "name" : "SLACK_USER_TOKEN",
          "value" : "${jsondecode(data.aws_secretsmanager_secret_version.incident_bot[count.index].secret_string)["SLACK_USER_TOKEN"]}"
        },
        {
          "name" : "PAGERDUTY_API_TOKEN",
          "value" : "${jsondecode(data.aws_secretsmanager_secret_version.incident_bot[count.index].secret_string)["PAGERDUTY_API_TOKEN"]}"
        },
        {
          "name" : "PAGERDUTY_API_USERNAME",
          "value" : "${jsondecode(data.aws_secretsmanager_secret_version.incident_bot[count.index].secret_string)["PAGERDUTY_API_USERNAME"]}"
        },
        {
          "name" : "DEFAULT_WEB_ADMIN_PASSWORD",
          "value" : "${jsondecode(data.aws_secretsmanager_secret_version.incident_bot[count.index].secret_string)["DEFAULT_WEB_ADMIN_PASSWORD"]}"
        },
        {
          "name" : "FLASK_APP_SECRET_KEY",
          "value" : "${jsondecode(data.aws_secretsmanager_secret_version.incident_bot[count.index].secret_string)["FLASK_APP_SECRET_KEY"]}"
        },
        {
          "name" : "JWT_SECRET_KEY",
          "value" : "${jsondecode(data.aws_secretsmanager_secret_version.incident_bot[count.index].secret_string)["JWT_SECRET_KEY"]}"
        },
        {
          "name" : "STATUSPAGE_API_KEY",
          "value" : "${jsondecode(data.aws_secretsmanager_secret_version.incident_bot[count.index].secret_string)["STATUSPAGE_API_KEY"]}"
        },
        {
          "name" : "STATUSPAGE_PAGE_ID",
          "value" : "${jsondecode(data.aws_secretsmanager_secret_version.incident_bot[count.index].secret_string)["STATUSPAGE_PAGE_ID"]}"
        },
        {
          "name" : "POSTGRES_HOST",
          "value" : "localhost"
        },
        {
          "name" : "POSTGRES_PORT",
          "value" : "5432"
        },
        {
          "name" : "CONFIG_FILE_PATH",
          "value" : "/config/incident-bot/config.yaml"
        },
        {
          "name" : "STATUSPAGE_URL",
          "value" : "https://cliniciannexus.statuspage.io"
        },
        {
          "name" : "FLASK_DEBUG_MODE_ENABLED",
          "value" : "false"
        }
      ],
      "healthCheck" : {
        "command" : [
          "CMD-SHELL",
          "curl -f http://localhost:3000 || exit 1"
        ],
        "interval" : 30,
        "timeout" : 5,
        "retries" : 3
      },
      "mountPoints" : [],
      "volumesFrom" : [],
      "dependsOn" : [
        {
          "containerName" : "db",
          "condition" : "HEALTHY"
        }
      ],
      "workingDirectory" : "/incident-bot",
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-create-group" : "true",
          "awslogs-group" : aws_cloudwatch_log_group.main[0].name,
          "awslogs-region" : var.region,
          "awslogs-stream-prefix" : "incident-bot"
        }
      }
    },
    {
      "name" : "db",
      "image" : "postgres:15",
      "cpu" : var.incident_bot_task_container_cpu,
      "portMappings" : [
        {
          "name" : "db-5432-tcp",
          "containerPort" : 5432,
          "hostPort" : 5432,
          "protocol" : "tcp",
          "appProtocol" : "http"
        }
      ],
      "essential" : true,
      "command" : [
        "postgres",
        "-c",
        "log_statement=all",
        "-c",
        "log_destination=stderr"
      ],
      "environment" : [
        {
          "name" : "POSTGRES_USER",
          "value" : "${jsondecode(data.aws_secretsmanager_secret_version.incident_bot[count.index].secret_string)["username"]}"
        },
        {
          "name" : "POSTGRES_PASSWORD",
          "value" : "${jsondecode(data.aws_secretsmanager_secret_version.incident_bot[count.index].secret_string)["password"]}"
        },
        {
          "name" : "POSTGRES_DB",
          "value" : "${jsondecode(data.aws_secretsmanager_secret_version.incident_bot[count.index].secret_string)["database"]}"
        },
        {
          "name" : "PGDATA",
          "value" : "/var/lib/postgresql/data/pgdata"
        },
      ],
      "mountPoints" : [
        {
          "containerPath" : "/var/lib/postgresql/data",
          "sourceVolume" : "efs-incident-bot",
          "readOnly" : false
        },
      ],
      "volumesFrom" : [],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-create-group" : "true",
          "awslogs-group" : aws_cloudwatch_log_group.main[0].name,
          "awslogs-region" : var.region,
          "awslogs-stream-prefix" : "incident-bot-db"
        }
      },
      "healthCheck" : {
        "command" : [
          "CMD-SHELL",
          "pg_isready"
        ],
        "interval" : 45,
        "timeout" : 5,
        "retries" : 5
      }
    }
    ]
  )

  volume {
    name = "efs-incident-bot"
    efs_volume_configuration {
      file_system_id          = var.incident_bot_efs_id
      root_directory          = "/"
      transit_encryption      = "ENABLED"
      transit_encryption_port = 2999
      authorization_config {
        access_point_id = var.incident_bot_efs_access_point_id
        iam             = "ENABLED"
      }
    }
  }

  runtime_platform {
    operating_system_family = var.incident_bot_operating_system_family
    cpu_architecture        = var.incident_bot_cpu_architecture
  }

  tags = merge(
    var.tags,
    {
      Name           = "incident_bot"
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    },
  )
}
