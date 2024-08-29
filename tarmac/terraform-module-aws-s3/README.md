# terraform-s3-module
Terraform S3 module published by Clinician Nexus.

## Getting Started
The intended usage of this module is in other repositories and modules. In those repos, the following steps should be taken:

1. Setup concrete values for the variables listed in `variables.tf`. 
1.1 If you need to test the module you build locally, create a `terraform.tfvars` file.
1.2 Run `terraform init`.
1.3 Run `terraform plan` to plan a run.
1.4 Run `terraform apply` to apply the configuration.
2. For Terraform Cloud/Scalr usage, set the values in the workspace's variables.
