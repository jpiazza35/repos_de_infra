# Overview

- **bastion_ec2**: Configuration for a bastion EC2 instance to allow SSH access to private resources.
- **databricks**: Configuration for provisioning a Databricks workspace with networking, access controls, storage, and customer-managed keys.
- **ecr**: Configuration for creating ECR repositories for Docker images.
- **github-oidc**: Configuration for setting up OIDC authentication from Github to AWS.
- **trustgrid**: Configuration for deploying the TrustGrid agents for anomaly detection.

# Usage

1. Clone the repository: `git clone <repo_url>`.
2. Navigate into the `terraform` directory in the cloned repository: `cd data-platform-devops-iac/terraform`.
3. For each component (`bastion_ec2`, `databricks`, `ecr`, `github-oidc`, `trustgrid`), follow the next steps:
   - Navigate to the component directory, for example, `cd databricks`.
   - Initialize the Terraform working directory: `terraform init`.
   - Create a new workspace or select an existing one, based on the environment: `terraform workspace new <env>` or `terraform workspace select <env>`.
   - Create an execution plan: `terraform plan -var-file=tfvars/$(terraform workspace show)_terraform.tfvars`.
   - Apply the desired changes: `terraform apply -var-file=tfvars/$(terraform workspace show)_terraform.tfvars`.

Replace `<env>` with the environment name (e.g., `dev`, `prod`) in the commands above. This step ensures that the Terraform state for each environment is isolated in its own workspace.