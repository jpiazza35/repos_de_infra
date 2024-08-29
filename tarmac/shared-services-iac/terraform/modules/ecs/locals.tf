locals {

  taskdefs = [
    for t in var.ecs_task : {
      for d in t.container_task_definitions : d.task_name => d
    }
    if t != []
  ][0]

  taskdef = [
    for d in local.taskdefs : d
  ]

  task_env_files = [
    for t in var.ecs_task : [
      for c in t.container_task_definitions : {
        for idx, f in(c.environment_files != null ? c.environment_files : []) : f.value => f
      }
      if c.environment_files != null && c.environment_files != []
    ]
    if t.container_task_definitions != null && t.container_task_definitions != []
  ]


  get_env_files = length(local.task_env_files) > 0 ? [
    for i in try(flatten(local.task_env_files)[0], []) : i.value
    if i != []
  ] : null

  # re2 ASCII character classes
  # https://github.com/google/re2/wiki/Syntax
  classes = {
    digit = "/\"(-[[:digit:]]|[[:digit:]]+)\"/"
  }

  definition = [
    for t in local.taskdef : {
      name   = try(t.task_name, format("%s-%s-task-definition", var.cluster["app"], var.cluster["env"]))
      image  = try(t.image_url, format("%s.dkr.ecr.%s.amazonaws.com/%s-ecr-repo:latest", data.aws_caller_identity.current.account_id, data.aws_region.current.name, var.cluster["app"]))
      cpu    = try(t.cpu, null)
      memory = try(t.memory, null)
      portMappings = [
        {
          containerPort = try(t.container_port, null)
          hostPort      = try(t.container_host_port, null)
        }
      ]
      essential        = try(t.essential, true)
      command          = try(t.command, null)
      environment      = try(t.environment_variables, null)
      environmentFiles = try(t.environment_files, null)
      healthCheck = {
        command  = try(t.health_check_command, null)
        interval = coalesce(t.health_check_interval, 5)
        timeout  = coalesce(t.health_check_timeout, 5)
        retries  = coalesce(t.health_check_retries, 3)
      }
      mountPoints = try(t.mount_points, null)
      volumesFrom = try(t.volumes_from, null)
      dependsOn   = try(t.depends_on, null)
      working_dir = try(t.working_dir, null)
      logConfiguration = {
        logDriver = coalesce(t.log_driver, "awslogs")
        options = {
          awslogs-create-group  = coalesce(t.awslogs_create_group, "true")
          awslogs-group         = coalesce(t.awslogs_group_path, format("/ecs/%s", var.cluster["app"]))
          awslogs-region        = coalesce(t.region, data.aws_region.current.name)
          awslogs-stream-prefix = coalesce(t.log_stream_prefix, var.cluster["app"])
        }
      }
      secrets = try(t.secrets, null)
    }
  ]

}
