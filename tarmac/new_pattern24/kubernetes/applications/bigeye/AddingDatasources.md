# Adding New Data Sources to Bigeye UI

This document provides instructions for the Data Team to add new databases to the Bigeye UI for monitoring.

## Instructions

1. **Select the Database to Add**: Identify the database you want to monitor from the Kubernetes configuration map. Each database is identified by a unique identifier within the configuration.

2. **Log into Bigeye UI**: A
    - Access the Bigeye user interface with the credentials provided to you by the DevOps team.
        - https://app.bigeye.com/w/258/catalog/data-sources

3. **Navigate to Add Source**:
    - In the Bigeye UI, click on the 'Add source' button.
        - <img width="123" alt="image" src="https://github.com/clinician-nexus/kubernetes/assets/133695630/3142ceca-7506-4fe0-b35b-269a581c32de">
    - Choose the appropriate data source type for your database.
        - <img width="781" alt="image" src="https://github.com/clinician-nexus/kubernetes/assets/133695630/8e4d0fce-ee97-47d1-aa42-06de4d7fbd4f">

4. **Configure Connection**:
    - Select the 'Connect with in-VPC agent' option.
        - <img width="790" alt="image" src="https://github.com/clinician-nexus/kubernetes/assets/133695630/2efe71f2-452c-4661-b103-cfd8f142525f">
     
5. **Add Data Source Name**:
    - Enter the name of the database exactly as it appears in the Kubernetes configuration. This ensures consistency and proper connection to the correct data source.
        - <img width="786" alt="image" src="https://github.com/clinician-nexus/kubernetes/assets/133695630/b4ef048d-a27a-413c-aad7-4171027e6502">

6. **Save and Test Connection**: After adding the database, save the configuration and use the 'Test connection' feature to verify that Bigeye can communicate with the database.

## Additional Information

- For any changes to the database configurations or to add new databases to the Kubernetes cluster, please refer to the configuration maps and secrets in this directory.
- If you need to update or modify the agent configuration, please open a Pull Request with the necessary changes for review by the DevOps team.

## Support

If you encounter any issues or require assistance, please contact the DevOps team on the '#ask-devops' channel on Slack.
