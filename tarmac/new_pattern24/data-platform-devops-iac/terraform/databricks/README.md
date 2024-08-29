# terraform-template
This repo provides a template for creating a new Terraform project. The goal is to standardize the basic directory and file structure so that we all "speak" the same language.

## Directory and File details
```/
│   .gitignore                              # Default Terraform .gitignore   
│   README.md                               
│
└───terraform                               # All Terraform code under the 'terraform' directory
    │   backend.tf                          # Terraform backend state configuration
    │   data_sources.tf                     # Data sources outside of Terraform
    │   locals.tf                           # Locally scoped variable definitions
    │   main.tf                             # Main Terraform code 
    │   outputs.tf                          # Output variables
    │   providers.tf                        # Terraform provider configuration - global to the project
    │   terraform.tfvars                    # Variable assignments for this project
    │   variables.tf                        # Input variables
    │
    └───modules                             # All modules added in sub-directories under this directory
        └───module_name                     # A service type or resource group specific name (i.e. s3, ec2, eks-cluster, vault)
                data_sources.tf             # Data sources outside of Terraform
                locals.tf                   # Locally scoped variable definitions - only available in this module
                outputs.tf                  # Output variables - variables returned by the module
                providers.tf                # 'required_providers' configuration, if needed. See: https://developer.hashicorp.com/terraform/language/modules/develop/providers
                resource_name.tf            # Individual Terraform files for each resource type in this module. (s3, ec2, networking, security)
                variables.tf                # Input variables
```