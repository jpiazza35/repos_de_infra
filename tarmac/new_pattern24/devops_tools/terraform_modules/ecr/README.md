# AWS ECR - Elastic Container Registry

This is a terraform repository for AWS ECR (Elastic Container Registry). This module creates the following resources:

- AWS Elastic Container Registry
- Elastic Container Registry Policies
- Elastic Container Registry Role

## Structure ##

The `.tf` files in this module are named per what they manage e.g. `ecr-role.tf` creates an AWS role for ECR. The `data.tf` file(s) contains all data sources for AWS resources that have been created using other Terraform modules.

## How it works ##
How this code works is that in order for the resources written in this directory to be applied and created, we need to run the Terraform commands in the appropriate AWS account directory. For example if we want to create the the Elastic Container Registries, we need to go into `my_folder/example_account` directory and initialize, plan and apply the changes with TF commands. The `main.tf` file there contains all modules needed for that AWS account and connects to directories created in the `terraform_modules` dir, just like this `terraform_modules/ecr` one.

## Tool Versions ##
Terraform version used in this repository is 0.14.11

Note: this Terraform version is specific to the project where the module was created and used.
You should pick the Terraform version that meets your project's requirements. 

## AWS ECR Details
This container image registry service is fully managed by AWS and it is secure, scalable, and reliable.

We have different policies to restrict access to our ECR repositories depending on the application. Those policies can be found on the iam_policies directory and are also use to separate Production and Non-Production repositories.

Image scanning is activated on push in all ECR repositories, AWS uses the Common Vulnerabilities and Exposures (CVEs) database from the open-source Clair project. This is the block used for that purpose in our repositories:

  image_scanning_configuration {
    scan_on_push = true
  }

To prevent image tags from being overwritten, we configure ECR repositories to be immutable in Production environments. If you attempt to push an image with a tag that is already in the repository, an ImageTagAlreadyExistsException error will be returned:

image_tag_mutability = "IMMUTABLE"

In the alerts module, we have a specific file for ECR (ecr-alerts.tf). If High or Critical vulnerabilities are found after an image scan, an alert will be send to the SQS queue.


Official documentation about Amazon ECR: https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html