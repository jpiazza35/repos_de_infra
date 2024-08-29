# Tarmac DevOps | Terraform Modules

This is a directory with a compilation of popular Terraform modules used for some Tarmac DevOps projects.

- Note: you might find some project-specific variables and resource names. If so, please rename them according to your project's needs.

## Structure ##

The `.tf` files within the modules are named per what they manage e.g. `alias.tf` manages the aliases we use for all the AWS accounts.

## How it works ##
How this code works is that in order for the resources written in the module directories to be applied and created, we need to run the Terraform commands in the appropriate AWS account directory. For example if we want to create the resources for a specific module, we need to have a `main.tf` file in a folder like `my_folder/example_account`. 
Once in this folder, we can initialize, plan and apply the changes with TF commands. 
The `main.tf` file there contains all modules needed for that AWS account and connects to directories created in the `terraform_modules` dir.

## Tool Versions ##
Terraform versions used in this repository are 0.14.11 and 1.1.3

Note: these Terraform versions are specific to the project where the modules were created and used.
You should pick the Terraform version that meets your project's requirements. 

## Terraform Modules within this repository
- account-alias
- api-gw
- code-pipeline
- codecommit
- config
- ecr
- ecs
- iam
- kms
- open-search
- organizations
- rds
- redis
- route53
- s2s-vpn
- s3
- secrets-manager
- sns
- sqs
- sso
- transit-gw
- vpc
- waf


