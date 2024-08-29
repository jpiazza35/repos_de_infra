## Deployment

### Build Python Wheels
Follow these commands:

> 1) Clone repository and activate virtual env:
```bash
git git@github.com:clinician-nexus/data-platform-databricks-common.git
cd data-platform-databricks-common/

virtualenv .venv
source .venv/bin/activate
```
> 2) Initialize virtual environment:
```bash
pip install poetry
pip install aws

poetry config virtualenvs.create false
```

> 3) Setup Vault environment variables

Create an environment rc file
```
export VAULT_ADDR=<vault hostname>
export VAULT_TOKEN=<your vault token>
```

```bash
pip install direnv
direnv allow
```

> 4) Build wheels
```bash
poetry version patch
poetry build
```

### Deploy Build Artifacts
Copy build artifacts to s3.
```
bucket="prod-artifacts-467744931205"
s3_path="s3://$bucket/wheels/$FILE_PATH"
aws s3 cp $FILE_PATH $s3_path --profile p_databricks
```


### Terraform
Workspace options `prod`.
```shell

cd terraform/batch_jobs
# Initialize the terraform directory
terraform init

# Select the correct workspace
terraform workspace select prod

# Generate an execution plan to review resources to be created
terraform plan
```

A full build and deploy script can be found at `deploy_job.sh`. 