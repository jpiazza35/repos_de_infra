# AWS SSO

This is the directory where all terraform supported AWS SSO resources are defined. This module creates/manages all SSO permissions sets, account assingments and policies created in the root AWS account.
The AWS SSO users and groups are created manually in the AWS console and then used in the aforementioned resources in the terraform scripts as data sources.

## Structure ##

The `.tf` files in this module are named per what they manage e.g. `permission-sets.tf` manages all AWS SSO Permission Sets resources. The `data.tf` file(s) contains all data sources (of manually created AWS SSO resources in the console) like AWS SSO groups and users. Those need to be created in the account in order for terraform to use them as data sources.

The actual permissions are managed within the `policy-attachments.tf` and `policy-documents.tf`. 
The permissions that we create are located in `policy-documents.tf`, there we can edit all permissions related to a certain AWS SSO Permission Set. We then use `policy-attachments.tf` to attach those or for some we attach predefined AWS managed policies e.g. the `BillingPermissionSet` will have the AWS managed `Billing` IAM policy attached to it.

## How it works ##
How this code works is that in order for the resources written in this directory to be applied and created, we need to run the Terraform commands in the appropriate AWS account directory. For example if we want to create the SSO resources in the root AWS account, we need to go into `rootaws` directory and initialize, plan and apply the changes with TF commands. The `main.tf` file there contains all modules needed for that AWS account and connects to directories created in the `modules` dir, just like this `modules/sso` one.

## Resources

- AWS SSO Permission Sets
- AWS SSO assignments (assign a permission set to a group and then links that to an AWS accounts)
- IAM policies (used as inline policies in permission sets)
- IAM policy attachments that attach the inline policies to the permission sets

## AWS SSO Lambdas ##
Due to AWS SSO not being compliant to PCI standards in regards to password expiration policy and users inactivity policy, we had to develop a custom solution to monitor those and alert the Infosec team.
The solution includes 4 Lambda functions (all part of the SSO module) and a DynamoDB table:

- add-user Lambda that takes care of "watching" `CreateUser` events in Cloudtrail so when a new SSO user is created it gets put in the DynamoDB table
- remove-user Lambda that removes a user when the `DeleteUser` event is triggered in Cloudtrail
- password-expiration Lambda that "watches" for the `UpdatePassword` Cloudtrail SSO event and compares the full SSO users list from DynamoDB table and a list that it constructs for users that have triggered the event. The difference of those two lists are the users that **have not** changed their password in the last 85 days. It then sends a message to the SQS queue in Logging & Monitoring AWS account.
- user-inactivity Lambda that "watches" for the `Authenticate` Cloudtrail SSO event and does the same comparison as the password-expiraton Lambda based on this event. The difference list is the users that have not logged on to SSO in the last 85 days. It then sends the list to the same SQS queue.

## Tool Versions ##
Terraform version used in this repository is 1.0.11
