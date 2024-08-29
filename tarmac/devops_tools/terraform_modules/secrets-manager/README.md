# AWS Secrets Manager

This is the directory where all AWS Secrets Manager resources are defined. This module creates the following resources:

- AWS Secrets Manager secret(s)
- AWS Secrets Manager secret(s) versions
- AWS Secrets Manager VPC endpoint

## Structure ##

The `.tf` files in this module are named per what they manage e.g. `secrets.tf` manages all resources directly connected with Secrets Manager like the secret(s) and their versions.

## How it works ##
How this code works is that in order for the resources written in this directory to be applied and created, we need to run the Terraform commands in the appropriate AWS account directory. For example if we want to create the secrets in the AWS `example-account`, we need to go into `my_folder/example_account` directory and initialize, plan and apply the changes with TF commands. The `main.tf` file there contains all modules needed for that AWS account and connects to directories created in the `terraform_modules` dir, just like this `terraform_modules/secretsmanager` one.

The way this works is that the actual values of the variables and secrets set in Secrets Manager will be managed manually via the AWS console. This terraform code only creates the secret as a resource itself.

## Tool Versions ##
Terraform version used in this repository is 1.1.3

Note: this Terraform version is specific to the project where the module was created and used.
You should pick the Terraform version that meets your project's requirements. 

## AWS Secrets Manager Details ##

Secrets Manager can be utilized to store, rotate, monitor, and control access to secrets such as database credentials, API keys, etc. To retrieve secrets, you simply replace hardcoded secrets in applications with a call to Secrets Manager APIs, eliminating the need to expose plaintext secret.

We've created secrets contains all credentials for OpenSearch. They were created and managed manually via the AWS console and then fetched in Terraform so the code uses the credentials.

The accounts using this module (such as Logging & Monitoring) have two terraform files used to fetch the credentials from AWS Secrets Manager: `data.tf` and `locals.tf`

## Fetching credentials ##

There is a connection between the following files in product accounts: data.tf -> locals.tf -> main.tf

This is an example of how the secrets are retrieved. In this case, this is the `AWS OpenSearch` product fetching the `master_user_name` and `master_user_password`.



The `data.tf` file is where `aws_secretsmanager_secret` resource retrieves the credentials we are looking for. On the other hand, `aws_secretsmanager_secret_version` retrieves its secret value:

data "aws_secretsmanager_secret" "credentials" {
  name = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-secrets"
}

data "aws_secretsmanager_secret_version" "credentials" {
  secret_id = data.aws_secretsmanager_secret.my_credentials.id
}

In `locals.tf` file, we get the decrypted part of the protected secret information that was originally provided as a string in `data.tf`.

locals {
  credentials = jsondecode(
    data.aws_secretsmanager_secret_version.my_credentials.secret_string
  )
}

Finally, in `main.tf` file is where we create the variable and specify the decrypted credential we need from `locals.tf`.

module "open-search" {
    source = "../../modules/open-search"
    .
    .
    open_search_master_user_name     = local.credentials.open_search_master_user_name
    open_search_master_user_password = local.credentials.open_search_master_user_password
    .
    .
  }

In this case, `open_search_master_user_password` is the actual key for the variable set in Secrets Manager. That means that the actual key/value pair if you open Secrets Manager would be something like: `open_search_master_user_password = SOME_VALUE`