# AWS ECS

This is the directory where all AWS ECS resources are defined. This module creates the following resources:

- ECS cluster(s)
- ECS service(s)
- ECS task definition(s)
- ECS container definition(s)
- ECS task role and policies
- Autoscaling for ECS
- Target group(s) and rule(s) for ALB
- Internal zone DNS record(s) in Route53
- ECS service discovery
- Cloudwatch log group(s) and alarm(s)

## Structure ##
The `.tf` files in this module are named per what they manage e.g. `ecs.tf` manages all resources directly connected with ECS like clusters, services, task definitions. The `data.tf` file(s) contains all data sources for AWS resources that have been created using other Terraform modules like other security groups, IAM roles(s), load balancer(s) etc.

## How it works ##
How this code works is that in order for the resources written in this directory to be applied and created, we need to run the Terraform commands in the appropriate AWS account directory. For example if we want to create the ECS on the AWS `example-account`, we need to go into `my_folder/example_account` directory and initialize, plan and apply the changes with TF commands. The `main.tf` file there contains all modules needed for that AWS account and connects to directories created in the `terraform_modules` dir, just like this `terraform_modules/ecs` one.

This module creates the ECS services for all the applications, those are managed within the `ecs.tf` file. 


## Task power ##
When it comes to setting the vCPU and memory for the tasks running, we have variables for that which are set in all product `main.tf` files. The variables are:
- `cpu` - vCPU value for a task
- `memory` - memory value

**Important** thing to mention here that even though these are separated, they cannot be set on whichever value. For the accepted values and combinations, please refer to the Fargate task size tables on the following documentation link:
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size

## Autoscaling ##
We have set up two types of autoscaling for the ECS services in the code, scheduled and utilization based. You can find those in the files named per the autoscaling type. How it works is that the ECS services are down to 0 tasks running after **6:30pm UTC** every day and completely off during weekends. 

The utilization autoscaling is used in all applications and environments and is currently based on CPU utiliziation on the ECS tasks. We have an alarm set on the CPU utilization in `cloudwatch.tf` and the action for it is to trigger the autoscaling up or down, based on the percentage of CPU used. If another metric is needed for autoscaling to happen, we would need to add another alarm in that file and then connect the `alarm_actions` to the corresponding autoscaling action.

## Tool Versions ##
Terraform version used in this repository is 0.14.11

Note: this Terraform version is specific to the project where the module was created and used.
You should pick the Terraform version that meets your project's requirements. 
