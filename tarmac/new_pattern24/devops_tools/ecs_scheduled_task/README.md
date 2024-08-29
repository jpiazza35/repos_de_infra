# aws-ecs-scheduled-task

This is a terraform repo for AWS ECS scheduled task infrastructure used by "______________" service. 


## Structure

Each env has a separate sub-directory, where specific settings for prod and nonprod accounts are placed.

In the `module-ecs` you can find terraform scripts that are common for all environments. AWS resources that this module creates:

- ECS task definition
- CloudWatch event rule, event target
- IAM role, IAM policy
