lambda_properties = {
  function_name     = "ecs_executor"
  description       = "Triger for ECS Task definition with custom event parameters"
  handler           = "run_task.lambda_handler"
  architectures     = "x86_64"
  runtime_version   = "python3.10"
  timeout           = 60
  memory_size       = 128
  ephemeral_storage = 512
}
