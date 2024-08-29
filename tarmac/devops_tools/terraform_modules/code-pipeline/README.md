# AWS Code Pipeline

This is a terraform repository for AWS Code Pipeline. This module creates the following resources:

- AWS Code Pipeline
- AWS S3 Buckets
- AWS IAM Roles and Policies
- AWS CloudWatch Event Rules and Targets
- AWS Cloud Trail

## Structure ##

The `.tf` files in this module are named per what they manage e.g. `pipeline.tf` creates an AWS Code Pipeline instance. The `data.tf` file(s) contains all data sources for AWS resources that have been created using other Terraform modules.

## How it works ##
How this code works is that in order for the resources written in this directory to be applied and created, we need to run the Terraform commands in the appropriate AWS account directory. For example if we want to create a Code Pipeline instance, we need to go into `my_folder/example_account` directory and initialize, plan and apply the changes with TF commands. The `main.tf` file there contains all modules needed for that AWS account and connects to directories created in the `terraform_modules` dir, just like this `terraform_modules/code-pipeline` one.

## Tool Versions ##
Terraform version used in this repository is 0.14.11

Note: this Terraform version is specific to the project where the module was created and used.
You should pick the Terraform version that meets your project's requirements. 