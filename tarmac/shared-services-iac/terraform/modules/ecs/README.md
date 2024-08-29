## ECS 
This module contains code for deploying an ECS Cluster, ECS Service, ECS Task, App Autoscaling for the service as well as supporting resources such as cloudwatch log groups and an EC2 Security Group.

To create resources in this module, copy the sample terraform.tfvars file in this directory into your codebase. Call the module in a `.tf` file
```
module ecs {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//ecs"

  cluster = var.cluster
  capacity_providers = var.capacity_provider
  ecs_service = var.ecs_service
  ecs_task = var.ecs_task
  autoscaling = var.autoscaling
  security_group = var.security_group
  cloudwatch_log_group = var.cloudwatch_log_group
  tags = merge(
    var.tags,
    {}
  )
}
```

For the ECS Task Definition, you can either pass a complete json configuration to the `var.ecs_task["task_definition"]` variable, or pass values to `var.ecs_task["container_task_definitions]` to have the task definition be created for you using the values you specify.

Autoscaling is disabled by default, to create an autoscaling target and policies, change the value of `var.autoscaling["enabled"]` to `true`.

There are examples of how to use this module in the [examples](./examples/) directory.
