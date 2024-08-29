# AWS S3

This is the directory where all AWS S3 Bucket resources are defined. This module creates the following resources:

- S3 Buckets
- S3 Bucket Policies
- S3 Bucket Public Access Block
- S3 Bucket notifications

## Structure ##

The `.tf` files in this module are named per what they manage e.g. `s3.tf` manages all resources for creating S3 buckets. The `data.tf` file(s) contains all data sources for AWS resources that have been created using other Terraform modules like other security groups, IAM roles(s), load balancer(s) etc.

## How it works ##
How this code works is that in order for the resources written in this directory to be applied and created, we need to run the Terraform commands in the appropriate AWS account directory. For example if we want to create the S3 bucket resoruces on AWS `example-account`, we need to go into `my_folder/example_account` directory and initialize, plan and apply the changes with TF commands. The `main.tf` file there contains all modules needed for that AWS account and connects to directories created in the `terraform_modules` dir, just like this `terraform_modules/s3` one.

## Tool Versions ##
Terraform version used in this repository is 1.1.3

Note: this Terraform version is specific to the project where the module was created and used.
You should pick the Terraform version that meets your project's requirements. 
