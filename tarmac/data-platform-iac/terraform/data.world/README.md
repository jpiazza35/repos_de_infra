## data.world service

[data.world](https://cliniciannexus.app.data.world/) is a data catalotg platform
This service collects metadata from our data sources.
List of data sources we collect:
- MSSQL
- PostgreSQL
- Databricks
- Redshift
- Tableau
- AWS S3

### Prerequisities

- Have Docker up and running.
- Secrets are stored in Hachicorp Vault, you will need access to `data-platform` folder.
- Terraform CLI installed locally
- Vault CLI installed locally
- Contact DevOps team for any questions.

### Dockerfile
Since Redshift and AWS S3 require special condition in the driver image, we are bulding custom docker image with Redshift driver and AWS IAM Credentials file.
_#TODO_ create CICD for docker image
This docker is build and pushed manually.

Steps to build the docker image:
```bash
cd Dockerfile
# Build for MacOS M1/M2
docker build -t <ImageTag> --build-arg BASE_IMAGE=datadotworld/dwcc:2.148 .
# Build for Linux
docker build --platform linux/amd64 -t <ImageTag> --build-arg BASE_IMAGE=datadotworld/dwcc:2.148 .

# Tagging image
docker tag <ImageTag> <ECR_URL>:<ECR_TAG>

# Push image to AWS ECR
docker push <ECR_URL>:<ECR_TAG>
```

### Terraform
This repo creates all infrastructure for deploying _data.world_ collector agent.
For adding new _data source_ you need to add new source to **locals.tf** file which is located in [data.world/d_data_platform](./d_data_platform/locals.tf)
Also you need to add new data source in the python script. For detailed information read the readme in the module located [here](./d_data_platform/lambda/README.md).

Deploying new data sources to the infra:
```terraform
# Change the directory where your main module is located
# example cd d_data_platform
cd <moduleFolder>

# Export variables for Hachicorp Vault
export VAULT_ADDR=https://vault.cliniciannexus.com:8200

# Login to Hachicorp Vault
vault login -method=oidc role=<YourRole>

# Initialize module
terraform init

# Check and verify plan
terraform plan

# Deploy new configuration
terraform apply
```

For any questions contact Devops team
