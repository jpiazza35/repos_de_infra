# AWS ORGANIZATIONS

This is the directory where all AWS Organization resources are defined. This module creates the following resources:

- AWS Organization
- AWS Organizational Units
- AWS Accounts
- AWS Organization Policies
- AWS Organization Policy Attachments

## Structure ##

The `.tf` files in this module are named per what they manage e.g. `organization.tf` creates the AWS Organizations terraform resources.

## How it works ##
How this code works is that in order for the resources written in this directory to be applied and created, we need to run the Terraform commands in the appropriate AWS account directory. For example if we want to create AWS organizations and accounts in the AWS `example-account`, we need to go into `my_folder/example_account` directory and initialize, plan and apply the changes with TF commands. The `main.tf` file there contains all modules needed for that AWS account and connects to directories created in the `terraform_modules` dir, just like this `terraform_modules/organizations` one.

## Tool Versions ##
Terraform version used in this repository is 1.1.3

Note: this Terraform version is specific to the project where the module was created and used.
You should pick the Terraform version that meets your project's requirements. 

## WARNING:
Deleting an AWS Account Resource on Terraform will only remove the AWS account from an organization. Terraform will not close the account. The member account must be prepared to be a standalone account beforehand. See the AWS Organizations documentation for more information.