# AWS VPC

This is the directory where all AWS VPC resources are defined. This module creates the following resources:

- VPC(s)
- AWS IPAM / IPAM pools
- Subnets
- Route tables
- VPC endpoints

## Structure ##

The `.tf` files in this module are named per what they manage e.g. `vpc.tf` creates and manages the VPC(s). The `subnets.tf` file(s) creates/manages all subnets. The `data.tf` contains all existing data sources for AWS resources.

## How it works ##
How this code works is that in order for the resources written in this directory to be applied and created, we need to run the Terraform commands in the appropriate AWS account directory. For example if we want to create the VPC infra in the AWS `example-account`, we need to go into `my_folder/example_account` directory and initialize, plan and apply the changes with TF commands. The `main.tf` file there contains all modules needed for that AWS account and connects to directories created in the `terraform_modules` dir, just like this `terraform_modules/vpc` one.

## Tool Versions ##
Terraform version used in this repository is 1.1.3

Note: this Terraform version is specific to the project where the module was created and used.
You should pick the Terraform version that meets your project's requirements. 
