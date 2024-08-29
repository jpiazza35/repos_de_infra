# AWS RDS

This is the directory where all AWS RDS resources are defined. This module creates the following resources:

- RDS cluster(s)
- RDS instance(s)
- RDS subnet group(s)
- RDS security group(s)

## Structure ##

The `.tf` files in this module are named per what they manage e.g. `rds.tf` manages all resources directly connected with RDS like clusters, instances. The `data.tf` file(s) contains all data sources for AWS resources that have been created using other Terraform modules like other security groups, IAM roles(s), load balancer(s) etc.

## How it works ##
How this code works is that in order for the resources written in this directory to be applied and created, we need to run the Terraform commands in the appropriate AWS account directory. For example if we want to create the RDS on AWS `example-account`, we need to go into `my_folder/example_account` directory and initialize, plan and apply the changes with TF commands. The `main.tf` file there contains all modules needed for that AWS account and connects to directories created in the `terraform_modules` dir, just like this `terraform_modules/rds` one.

## RDS Lambdas ##
This module also creates/manages 2 Lambda functions that automate some actions. The user-creation lambda is triggered when the RDS is created and it creates the RDS user in the PostgreSQL that is used for the IAM authentication.
The sql-automation lambda is triggered by a file uploaded in s3 named `script.sql` which can contain sql commands that we need to be executed in the PostgreSQL RDS instance. That lambda uses the RDS IAM auth user and does not use the master one. Currently it only accepts `script.sql` as a valid filename for the trigger, something that needs to be fixed/enhanced.

## Tool Versions ##
Terraform version used in this repository is 0.14.11

Note: this Terraform version is specific to the project where the module was created and used.
You should pick the Terraform version that meets your project's requirements. 
