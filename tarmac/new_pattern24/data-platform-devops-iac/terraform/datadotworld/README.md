## data.world service

### Terraform
This repo creates all infrastructure for deploying _data.world_ collector agent.

[data.world](https://cliniciannexus.app.data.world/) is a data catalotg platform
This service collects metadata from our data sources.
List of data sources we collect:
- MSSQL
- PostgreSQL
- Databricks
- Redshift
- Tableau
- AWS S3


### Steps to add new source or database
- If you want to add new database from existing source configuration, create PR with change request to `main` branch.  
Add new database in configuration you want to update  in `locals.tf` file located in [data.world/p_data_platform](./p_data_platform/locals.tf).   
Then create PR towards `main` branch and notify DevOps team on [#devops-general](https://app.slack.com/client/T02R8QGM1C4/C04JY7VQ7NC) Slack channel.   

```bash
# checkout from main branch
git pull origin main
git checkout -b <featureBranchName> main
```

- To add new data source (example, new PostgreSQL or S3 Bucket), you need to update `locals.tf` file with new block located in [data.world/p_data_platform](./p_data_platform/locals.tf), add Vault path in `data.tf` file located [here](./p_data_platform/data.tf).   
If you add new data source not listed in our documentation, then you need to add `python lambda` with proper configuration provided by `data.world` [official](https://docs.data.world/en/98671-data-world-collector-instructions-by-data-source.html) documentation.   
for example, you want to add new data source like `fivetran` you need to add `elif` condition in both functions.

```python
# add elif in lambda_handler function 

elif init_command == 'catalog-fivetran':
    event_data = {
        "catalog-fivetran": init_command,
        "db_host": database_host,
        "db_user": database_user,
        "db_pass": database_pass,
        "db_name": database_name,
        "init_command": init_command,
        "ecs_cluster": ecs_cluster_event,
        "upload_location": upload_location,
        "security_group": security_group_event,
        "container_name": container_name_event
    }
    event_data_list.append(event_data)
```

this append event_data variable which is later used in `run_task_with_event_data` function and passed to ecs task as overrides.
```python
# add elif in run_task_with_event_data function

elif 'catalog-fivetran' in event_data:
    init_command = event_data['catalog-fivetran']
    overrides = {
        'containerOverrides': [
            {
                'name': container_name,
                'command': [
                    f"{init_command}",
                    "--agent=catalog-sources",
                    "--site=cliniciannexus",
                    "--no-log-upload=false",
                    "--upload=true",
                    f"--api-token={dataworld_api_token}",
                    "--output=/data",
                    f"--name={init_command}",
                    f"--upload-location={upload_location}",
                    f"--fivetran-apikey={db_user}",
                    f"--fivetran-apisecret={db_pass}"
                ],
            },
        ]
    }
```


_IMPORTANT_
Secret in Vault must contain 3 values
- hostname
- username
- password

```terraform
# data.tf file example
data "vault_generic_secret" "change_resource_id" {
  path = "change_path_of_secret"
}

# locals.tf file example
# PostgreSQL Server
changeDbId = {
  db_type = "catalog-postgres"
  db_host = data.vault_generic_secret.change_resource_id.data["hostname"]
  db_user = data.vault_generic_secret.change_resource_id.data["username"]
  db_pass = data.vault_generic_secret.change_resource_id.data["password"]
  db_names = [
    "List of database name(s)"
  ]
  upload_location_dataset = "metadata upload location"
}
```
Then again repeat step with creating PR towards `main` branch and notify DevOps team on [#devops-general](https://app.slack.com/client/T02R8QGM1C4/C04JY7VQ7NC) Slack channel.

### Prerequisites
- Have Docker up and running.
- Secrets are stored in Hachicorp Vault, you will need access to `data-platform` folder.
- Terraform CLI installed locally
- Vault CLI installed locally
- Contact DevOps team for any questions.

### Dockerfile
Since Redshift and AWS S3 require special condition in the driver image, we are bulding custom docker image with Redshift driver and AWS IAM Credentials file.   
~~_#TODO_ create CICD for docker image~~

Docker image is build automatically when merged to main branch and its pushed to ECR repo.
Location of Dockerfile is placed under `Dockerfile` folder.

For any questions contact Devops team
