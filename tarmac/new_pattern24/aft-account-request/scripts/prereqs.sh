# Create the Azure Active Directory application.
az ad app create --display-name GithubActionsOIDC

# Create a service principal
## Replace the $appID with the appId from your JSON output.
#az ad sp create --id $appId
az ad sp create --id "a2a723dc-fa86-403e-b42e-170dcb733a8b"

# Create Resource Group
# az group create -l eastus -n Infrastructure

# Create a new role assignment by subscription and object
## Replace $subscriptionId with your subscription ID, $resourceGroupName with your resource group name, and $assigneeObjectId with generated assignee-object-id (the newly created service principal object id).
#az role assignment create --role contributor --subscription $subscriptionId --assignee-object-id  $assigneeObjectId --assignee-principal-type ServicePrincipal --scope /subscriptions/$subscriptionId/resourceGroups/$resourceGroupName
az role assignment create --role contributor --subscription "d21b76ef-cf72-4197-b24a-9669b0cc9895" --assignee-object-id "390d72be-b6a2-42d0-9a82-9c48c7d08182" --assignee-principal-type ServicePrincipal --scope /subscriptions/d21b76ef-cf72-4197-b24a-9669b0cc9895

# Add federated credentials
## Replace APPLICATION-OBJECT-ID with the objectId (generated while creating app) for your Azure Active Directory application.
## Set a value for CREDENTIAL-NAME to reference later.
## Set the subject. The value of this is defined by GitHub depending on your workflow:
## Jobs in your GitHub Actions environment: repo:< Organization/Repository >:environment:< Name >
## For Jobs not tied to an environment, include the ref path for branch/tag based on the ref path used for triggering the workflow: repo:< Organization/Repository >:ref:< ref path>. For example, repo:n-username/ node_express:ref:refs/heads/my-branch or repo:n-username/ node_express:ref:refs/tags/my-tag.
## For workflows triggered by a pull request event: repo:< Organization/Repository >:pull_request.
#az rest --method POST --uri 'https://graph.microsoft.com/beta/applications/<APPLICATION-OBJECT-ID>/federatedIdentityCredentials' --body '{"name":"<CREDENTIAL-NAME>","issuer":"https://token.actions.githubusercontent.com","subject":"repo:organization/repository:environment:Production","description":"Testing","audiences":["api://AzureADTokenExchange"]}'
az rest --method POST --uri 'https://graph.microsoft.com/beta/applications/390d72be-b6a2-42d0-9a82-9c48c7d08182/federatedIdentityCredentials' --body '{"name":"githubactionsoidc","issuer":"https://token.actions.githubusercontent.com","subject":"repo:clinician-nexus/infra-terraform-modules:ref:refs/heads/main","description":"Testing","audiences":["api://AzureADTokenExchange"]}'