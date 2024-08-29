# Introduction
This repo stores the Account Requests for Control Tower Account Factory for Terraform. This is where you place requests for accounts that you would like provisioned and managed by the AFT solution.

[![AWS Account AD Group Creation](https://github.com/clinician-nexus/aft-account-request/actions/workflows/azure_ad.yml/badge.svg)](https://github.com/clinician-nexus/aft-account-request/actions/workflows/azure_ad.yml)

### Request a new Account

AFT follows a GitOps model for creating and updating AWS Control Tower managed accounts. Account Request Terraform file should be created to provide necessary inputs to trigger AFT pipeline workflow for account vending. You can reference example Account Request you should have pushed to your chosen git repository for storing AFT Account Requests (link to instructions in deployment).

When account provisioning or updating is complete, the AFT pipeline workflow continues and runs AFT Account Provisioning Framework and Customizations steps.

Git push action will trigger ct-aft-account-request AWS CodePipeline in AFT management account to process your account request.

It will also trigger a Github Action that creates the Distribution Group List using the AWS Account Name in the format `AWS-<AWS_ACCOUNT_NAME>-Root@sullivancotter.com`

- **module name** must be unique per AWS account request.

- **module source** is path to Account Request terraform module provided by AFT - this should always be ```source = "./modules/aft-account-request"```

- **control_tower_parameters** captures mandatory inputs listed below to create AWS Control Tower managed account.
    - AccountEmail
    - AccountName
    - ManagedOrganizationalUnit
    - SSOUserEmail
    - SSOUserFirstName
    - SSOUserLastName
  

   Refer to https://docs.aws.amazon.com/controltower/latest/userguide/account-factory.html for more information.

- **account_tags** captures user defined keys and values to tag AWS accounts by required business criteria. Refer to https://docs.aws.amazon.com/organizations/latest/userguide/orgs_tagging.html for more information on Account Tags.

- **change_management_parameters** captures inputs listed below. As a customer you may want to capture reason for account request and who initiated the request.
    - change_requested_by
    - change_reason

- **custom_fields** captures custom keys and values. As a customer you may want to collect additional metadata which can be logged with the Account Request and also leveraged to trigger additional processing when vending or updating an account. This metadata can be referenced during account customizations which can determine the proper guardrails which should be deployed. For example, an account that is subject to regulatory compliance could deploy an additional config rule.

**This section is important.** Be sure to enter your `vpc_cidr` and `account name`, they are used to trigger the automated creation of a vpc in the new AWS account.

An example account request module can be found [here](./examples/account-request.tf)

Your account request block should look like this:
```
D_WORKLOAD = {
    account_name          = "D_WORKLOAD"
    ou                    = "Dev (ou-umm7-ij0iazzk)"
    account_owner         = "the best dev team"
    team                  = "software development ninjas"
    environment           = "dev"
    requested_by          = "John Doe"
    account_description   = "Account made for being anonymous"
    vpc_cidr_block        = "null"
    enable_public_subnet  = "false"
    create_vpc            = "false"
    region                = "us-east-1"
  }
```
<details open>
<summary>Available OUs in the Organization:</summary>
<br>
Security (ou-umm7-568ds8u5)
<br>
Workloads (ou-umm7-8hwmiqjc)
<br>
NonProd (ou-umm7-1afvzi98)
<br>
Applications (ou-umm7-6s5onbeq)
<br>
Datahub (ou-umm7-yqj8rtp7)
<br>
Dev (ou-umm7-ij0iazzk)
<br>
Stage (ou-umm7-jhgr5gh2)
<br>
Prod (ou-umm7-pnh6ffwk)
<br>
Applications (ou-umm7-9yawrhb0)
<br>
Datahub (ou-umm7-l4y1hl0j)
<br>
Infrastructure (ou-umm7-ngvsx463)
<br>
Individuals (ou-umm7-t0ajbdzb)
<br>
SharedServices (ou-umm7-t3fzzkf2)
<br>
PolicyStaging (ou-umm7-tb9bvesi)
<br>
Suspended (ou-umm7-w84iimi3)
<br>
</details>
```

- **account_customizations_name** (Optional) Name of a customer-provided Account Customization to be applied when the account is provisioned.

### Update Existing Account

You may update AFT provisioned accounts by updating previously submitted Account Requests. Git push action triggers the same Account Provisioning workflow to process account update request.

AFT supports updating of all non control_tower_parameters inputs and ManagedOrganizationalUnit of control_tower_parameters input. Remaining control_tower_parameters inputs cannot be changed.

### Submit Multiple Account Requests

Although AWS Control Tower Account Factory can process single request at any given time, AFT pipeline allows you to submit multiple Account Requests and queues all the requests to be processed by AWS Control Tower Account Factory in FIFO order.

You should create an Account Request Terraform file per account.
