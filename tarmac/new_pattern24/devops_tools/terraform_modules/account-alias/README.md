# AWS account alias

This is the directory where the AWS account alias is defined. This module creates the following resources:

- AWS accounts aliases

## Structure ##

The `.tf` files in this module are named per what they manage e.g. `alias.tf` manages the aliases we use for all the AWS accounts.

## How it works ##
How this code works is that in order for the resources written in this directory to be applied and created, we need to run the Terraform commands in the appropriate AWS account directory. For example if we want to create the alias for the AWS `example-account`, we need to go into `my_folder/example_account` directory and initialize, plan and apply the changes with TF commands. The `main.tf` file there contains all modules needed for that AWS account and connects to directories created in the `modules` dir, just like this `terraform_modules/account-alias` one.

## Tool Versions ##
Terraform version used in this repository is 1.1.3

Note: this Terraform version is specific to the project where the module was created and used.
You should pick the Terraform version that meets your project's requirements. 
