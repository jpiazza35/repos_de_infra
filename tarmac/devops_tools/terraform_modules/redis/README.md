# AWS ElastiCache for Redis

This is the directory where all AWS Redis Elasticache resources are defined.

## Structure ##

The `.tf` files in this module are named per what they manage e.g. `redis.tf` manages all resources directly connected with Redis like clusters, services, task definitions. The `data.tf` file(s) contains all data sources for AWS resources that have been created using other Terraform modules like other security groups, IAM roles(s), load balancer(s) etc.

## How it works ##
How this code works is that in order for the resources written in this directory to be applied and created, we need to run the Terraform commands in the appropriate AWS account directory. For example if we want to create the Redis on AWS `example-account`, we need to go into `my_folder/example_account` directory and initialize, plan and apply the changes with TF commands. The `main.tf` file there contains all modules needed for that AWS account and connects to directories created in the `terraform_modules` dir, just like this `terraform_modules/redis` one.

The Elasticache cluster(s) use RBAC as a method of authentication, the users and user groups are created manually via the AWS console.

When enabled, AWS creates a `default` user that has full access to the Elasticache. We need to create a new user group named `redis-users` and put that user in it. AWS then recommends to swap this user by creating a new user with the username `default`.
After this has been completed we can create the app user which we named `threedss`, assign it a strong password and access string to give it admin permissions.



Reference:
https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/Clusters.RBAC.html#Users-management

## Tool Versions ##
Terraform version used in this repository is 0.14.11

Note: this Terraform version is specific to the project where the module was created and used.
You should pick the Terraform version that meets your project's requirements. 
