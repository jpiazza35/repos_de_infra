[![Terraform Plan/Apply for SS Tools](https://github.com/clinician-nexus/shared-services-iac/actions/workflows/ss_tools.yml/badge.svg?branch=main)](https://github.com/clinician-nexus/shared-services-iac/actions/workflows/ss_tools.yml)

[![GitHub Runner](https://github.com/clinician-nexus/shared-services-iac/actions/workflows/github-runner.yml/badge.svg?branch=main)](https://github.com/clinician-nexus/shared-services-iac/actions/workflows/github-runner.yml)

## shared-services-iac
This repository contains the IAC for DevOps shared services.

Terraform modules supporting shared services resources in the `SS_TOOLS` AWS Account.

To deploy resources from this repository, we utilize terraform workspaces
```
# Initialize the terraform directory
terraform init

# Select the correct workspace
terraform workspace select sharedservices

# Generate an execution plan to review resources to be created
terraform plan

```
Any changes to the `SS_TOOLS` account need to be done via a CI/CD Pipeline. There is a GitHub Action that gets triggered during a PR to generate the plan for code review.

Once the review is approved and merged into the `main` branch, a different pipleine will be triggered to create the Infrastructure changes in the `SS_TOOLS` account.

### phpIPAM
To get the next available subnet in the /23 range:
```
## Get next available VPC Cidr
resource "phpipam_first_free_subnet" "new_subnet" {
  count            = local.default
  parent_subnet_id = phpipam_subnet.ranges["10.202.0.0"].id
  subnet_mask      = 23
  description      = "<AWS_ACCOUNT_NAME>"
  is_full          = true
  show_name        = true
}
```
You can then use the value that it outputs like this:
```
output vpc {
  value = format("%s/%s", phpipam_first_free_subnet.new_subnet[0].subnet_address, phpipam_first_free_subnet.new_subnet[0].subnet_mask)
}
```

### Vault
To connect to Vault via the UI, go to [Vault](https://cliniciannexus.com:8200), the url is <https://vault.cliniciannexus.com:8200>. Select the oidc option, enter the `Role` for your team or permission level, e.g `devs` and click `Sign in`. 

An Azure OIDC Pop Up will ask for you to authenticate and once that is succesful, you will be signed in to Vault. If you leave the `Role` blank, it will sign you in to Vault with default `list` permissions and you will be unable to read any existing secrets.


To sign in to Vault via the cli, set the following variable(s) locally. ***This assumes you have installed the vault cli***
```bash
## Install Vault
## Mac:
brew tap hashicorp/tap
brew install hashicorp/tap/vault

## linux 
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vault

## Windows
Invoke-WebRequest -Uri https://releases.hashicorp.com/vault/1.13.1/vault_1.13.1_windows_386.zip -OutFile "vault.zip"

## Set Vault Address
## Mac and Linux
export VAULT_ADDR=https://vault.cliniciannexus.com:8200

## Windows
set VAULT_ADDR=https://vault.cliniciannexus.com:8200

## Log in via OIDC
vault login -method oidc role=<your_role> 
```
