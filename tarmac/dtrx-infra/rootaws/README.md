# Root AWS Account Datatrans

This is a terraform repository for the AWS Root AWS Account for Datatrans.

## Tool Versions ##
Terraform version used in this repository is 1.0.11

## Structure

## Naming convention
Naming Conventions & Tags

Resources:
<moniker>-<product>-<application>-<service>-<type>-<env>
(e.g. dtcloud-proxy-dashboard-app-ecs-prod)

Accounts:
<moniker>-<product>-<env>

Standard tags:
Environment [dev, test, prod]
Moniker [dtcloud, <<<something_else_in_the_future>>>]
Product [proxy, hub, payment, internal]
Application [dashboard, usage, http, auth, onboarding, appstatus, alerting]
Service [app, vault, cdn, aocs, backend, frontend]
Script [Terraform] 
ProjectID [JIRA_PROJECT_ID]
Repository [GITLAB_URL]
PCI [None, Connected-To, DSS, 3DS]