resource "aws_ecs_task_definition" "sonatype_td" {
  count                    = local.default
  family                   = var.sonatype_app
  execution_role_arn       = aws_iam_role.sonatype_execution[count.index].arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.sonatype_task_definition_cpu
  memory                   = var.sonatype_task_definition_memory
  task_role_arn            = aws_iam_role.sonatype_task[count.index].arn


  container_definitions = jsonencode([
    {
      name      = "sonatype-nexus"
      image     = var.sonatype_task_container_image
      cpu       = var.sonatype_task_container_cpu
      memory    = var.sonatype_task_container_memory
      essential = true
      ulimits = [
        {
          name      = "nofile"
          hardLimit = 65536
          softLimit = 65536
        }
      ]
      portMappings = [
        #artifactory
        {
          containerPort = 8081
          hostPort      = 8081
        },
        {
          containerPort = 8082
          hostPort      = 8082
        },
        {
          containerPort = 8083
          hostPort      = 8083
        },
        {
          containerPort = 8084
          hostPort      = 8084
        },
        {
          containerPort = 8085
          hostPort      = 8085
        },
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.main[0].name
          awslogs-stream-prefix = var.sonatype_app
          awslogs-region        = var.region
        }
      },
      healthCheck : {
        command : [
          "CMD-SHELL",
          "curl -h http://localhost:8081"
        ],
        interval : 60,
        timeout : 50,
        retries : 5
      },
      mountPoints = [
        {
          "containerPath" : "/nexus-data",
          "sourceVolume" : "efs-nexus",
          "readOnly" : false
        },
      ],
      environment : [
        {
          "name" : "a-global-property",
          "value" : "somevalue"
        },
      ],
    },
  ])


  volume {
    name = "efs-nexus"
    efs_volume_configuration {
      file_system_id          = var.sonatype_efs_id
      root_directory          = "/"
      transit_encryption      = "ENABLED"
      transit_encryption_port = 2999
      authorization_config {
        access_point_id = var.sonatype_efs_access_point_id
        iam             = "DISABLED"
      }
    }
  }

  runtime_platform {
    operating_system_family = var.sonatype_operating_system_family
    cpu_architecture        = var.sonatype_cpu_architecture
  }

  tags = merge(
    var.tags,
    {
      Name           = "sonatype_artifactory"
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    },
  )
}
