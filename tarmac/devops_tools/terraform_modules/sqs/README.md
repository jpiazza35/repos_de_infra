# AWS SQS | Simple Queue Service

This is the directory where the AWS SQS service is created and managed. This module creates the following resources:

- AWS SQS | Simple Queue Service

The SQS queue managed here is the Logging & Monitoring account one that is used by the DataTrans team to ingest alerts coming from all accounts.


## Structure ##

The `.tf` files in this module are named per what they manage e.g. `sqs.tf` manages the AWS SQS service for the Logging and Monitoring AWS account.

## How it works ##
How this code works is that in order for the resources written in this directory to be applied and created, we need to run the Terraform commands in the appropriate AWS account directory. For example if we want to create an AWS SQS resource for the AWS `example_account`, we need to go into `my_folder/example_account` directory and initialize, plan and apply the changes with TF commands. The `main.tf` file there contains all modules needed for that AWS account and connects to directories created in the `terraform_modules` dir, just like this `terraform_modules/sqs` one.


## Tool Versions ##
Terraform version used in this repository is 1.1.3

Note: this Terraform version is specific to the project where the module was created and used.
You should pick the Terraform version that meets your project's requirements. 
