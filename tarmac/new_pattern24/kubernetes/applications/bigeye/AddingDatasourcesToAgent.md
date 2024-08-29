# Adding New Data Sources to Bigeye Agent

This guide details the steps required for the Data Team to add new databases to the Bigeye Agent for monitoring through Kubernetes.

## Prerequisites

- Access to the Kubernetes repository.

## Instructions

1. **Access the Kubernetes Repository**:
   - Navigate to the Kubernetes repository where the Bigeye Agent configuration is stored.

2. **Identify the Server ConfigMap**:
   - Navigate to the [bigeye/base](https://github.com/clinician-nexus/kubernetes/blob/main/applications/bigeye/base) directory in the Kubernetes repository.
   - Access the specific server directory, for example, aws-va2-sql01.
   - Open the configmap.yaml file which contains the Bigeye Agent configuration.

3. **Edit the ConfigMap**:
   - Open the ConfigMap file (`configmap.yaml`) for editing.

4. **Add the New Data Source Configuration**:
   - Under the `sources` section of the `agent.yaml` data block, add a new entry for the database.
   - Specify the unique `identifier` and `databaseName`.

5. **Apply the Changes**:
   - Save the changes to the ConfigMap.
   - Open a pull request to  have it reviewed by the DevOps team and then deployed to the Kubernetes Cluster.

6. **Add the New Data Source to the Bigeye UI**:
   - Follow the instructions in the [Adding New Data Sources to Bigeye UI](https://github.com/clinician-nexus/kubernetes/blob/main/applications/bigeye/AddingDatasources.md)
## Example Entry

```yaml
- identifier: 'NEW_DATABASE_IDENTIFIER'
  connectionFactory:
    type: ${DB_TYPE}
    host: ${DB_HOST}
    port: ${DB_PORT}
    user: ${DB_USER}
    password: ${DB_PASSWORD}
    databaseName: NEW_DATABASE_NAME
```
#### Databaricks Data Source Example
```yaml
- identifier: 'DATABRICKS_IDENTIFIER'
  connectionFactory:
    type: spark
    host: ${DATABRICKS_HOST}
    port: ${DATABRICKS_PORT}
    user: DATABRICKS_SQL_WAREHOUSE_HTTP_PATH
    password: DATABRICKS_SERVICE_PRINCIPAL_TOKEN
    databaseName: ## This stays blank
```

## Additional Assistance

If you encounter any issues or require further assistance, please reach out to the DevOps team through the '#ask-devops' channel on Slack.
