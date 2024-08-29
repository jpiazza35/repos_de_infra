# AWS ORGANIZATIONS

This is the directory where all AWS Organization resources are defined. This module creates and manages the following resources:

- AWS Organizational Units
- AWS Accounts
- AWS Organization Policies
- AWS Organization Policy Attachments

## Structure ##

The `.tf` files in this module are named per what they manage e.g. `organization.tf` creates the AWS Organizations terraform resources.

## How it works ##
How this code works is that in order for the resources written in this directory to be applied and created, we need to run the Terraform commands in the appropriate AWS account directory. For example if we want to create AWS organizations and accounts in the root AWS account, we need to go into `rootaws` directory and initialize, plan and apply the changes with TF commands. The `main.tf` file there contains all modules needed for that AWS account and connects to directories created in the `modules` dir, just like this `modules/organizations` one.

## Control Tower Setup ##
The `control-tower-accounts.csv` file contains all the information needed in the `control-tower.tf` so that a new AWS account is created, enrolled into Control Tower and an SSO user for it created and connected for access. The following is the format that .csv file has:

| account_name | account_owner_email | sso_user_first_name | sso_user_last_name | sso_user_email  | org_unit | provisioned_product_name |
| ------------ | ------------------- | ------------------- | ------------------ | --------------- | -------- | ------------------------ |
| Individuals_JDoe | AWS-Individuals_JDoe-Root@cliniciannexus.com | John | Doe | john.doe@cliniciannexus.com | Individuals | Individuals_JDoe |

## Tool Versions ##
Terraform version used in this repository is 1.3.6

## WARNING:
Deleting an AWS Account Resource on Terraform will only remove the AWS account from an organization. Terraform will not close the account. The member account must be prepared to be a standalone account beforehand. See the AWS Organizations documentation for more information - https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_close.html