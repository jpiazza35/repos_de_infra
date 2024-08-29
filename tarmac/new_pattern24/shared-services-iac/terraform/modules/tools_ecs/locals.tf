locals {
  default = terraform.workspace == "sharedservices" ? 1 : 0

  task_environment = [
    for k, v in var.task_container_environment : {
      name  = k
      value = v
    }
  ]

  target_group_portMaps = length(var.target_groups) > 0 ? distinct([
    for tg in var.target_groups : {
      containerPort = contains(keys(tg), "container_port") ? tg.container_port : var.task_container_port
      protocol      = contains(keys(tg), "protocol") ? lower(tg.protocol) : "tcp"
    }
  ]) : []

  db_target_group_portMaps = length(var.target_groups) > 0 ? distinct([
    for tg in var.target_groups : {
      containerPort = var.mysql_port
      protocol      = "tcp"
    }
  ]) : []

  task_environment_files = [
    for file in var.task_container_environment_files : {
      value = file
      type  = "s3"
    }
  ]
}
