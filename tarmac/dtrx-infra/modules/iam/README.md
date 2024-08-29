# AWS IAM

This is a terraform repository for AWS Identity Access Management. This module will control all of the IAM related resources within the root AWS account.

## Tool Versions ##
Terraform version used in this repository is 1.0.11

## How it works ##
How this code works is that in order for the resources written in this directory to be applied and created, we need to run the Terraform commands in the appropriate AWS account directory. For example if we want to create the IAM resources in the root AWS account, we need to go into `rootaws` directory and initialize, plan and apply the changes with TF commands. The `main.tf` file there contains all modules needed for that AWS account and connects to directories created in the `modules` dir, just like this `modules/iam` one.
