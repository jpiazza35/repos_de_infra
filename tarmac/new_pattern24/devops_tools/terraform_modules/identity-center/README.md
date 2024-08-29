# AWS IAM Identity Center

This is the directory where all terraform supported AWS IAM Identity Center resources are defined. This module creates/manages all IAM Identity Center users, groups,permissions sets, account assignments and policies created in the root AWS account.

## Structure ##

The `.tf` files in this module are named per what they manage e.g. [permission-sets.tf](module/permission-sets.tf) manages all AWS IAM Identity Center Permission Sets resources. The `data.tf` file(s) contains all data sources (of manually created AWS IAM Identity Center resources in the console) like AWS IAM Identity Center groups and users. Those need to be created in the account in order for terraform to use them as data sources.

## How it works ##
How this code works is that in order for the resources written in this directory to be applied and created, we need to run the Terraform commands in the root AWS account. For that, we initialize, plan and apply the changes within the root of the IAM Identity Center module folder.

The permissions used for the permissions sets and with that the groups are attached with [policy-attachments.tf](module/policy-attachments.tf).
In the example code and module here, we only use data sources to fetch AWS IAM policies like Admin, ReadOnly and Billing. Those are set in the `permissions_sets` map variable declared in [main.tf](./main.tf).

**When a new user needs to be created**, what needs to be done is to change the [users-locals.tf ](./users-locals.tf) file. That file contains all the information needed to create a new IAM Identity Center user. Basically just copy/paste an existing user, edit the details about name, email, sso_groups that the new user needs to be part of and run plan and apply.

**When a new group needs to be created**, we need to change the [accounts-locals.tf ](./accounts-locals.tf). This file has the information about group names along with account ID, Permission Set name and principal type (which should always be "GROUP"). Remember that when adding a new group here, we also need to fill in the other details which will actually connect the newly created group to an AWS account and a IAM Identity Center Permission set. Without these, the group basically serves no purpose.

## Resources

- AWS IAM Identity Center Users
- AWS IAM Identity Center Groups
- AWS IAM Identity Center User - Group Memberships
- AWS IAM Identity Center Permission Sets
- AWS IAM Identity Center assignments (assign a permission set to a group and then links that to an AWS accounts)
- IAM policies (used as inline policies in permission sets)
- IAM policy attachments that attach the inline policies to the permission sets

## AWS IAM Identity Center and PCI ##
Due to AWS IAM Identity Center not being compliant to PCI standards in regards to password expiration policy and users inactivity policy, we had to develop a custom solution to monitor those and alert the appropriate team.
The solution includes 4 Lambda functions (all part of the IAM Identity Center module) and a DynamoDB table:

- add-user Lambda that takes care of "watching" `CreateUser` events in Cloudtrail so when a new IAM Identity Center user is created it gets put in the DynamoDB table
- remove-user Lambda that removes a user when the `DeleteUser` event is triggered in Cloudtrail
- password-expiration Lambda that "watches" for the `UpdatePassword` Cloudtrail IAM Identity Center event and compares the full IAM Identity Center users list from DynamoDB table and a list that it constructs for users that have triggered the event. The difference of those two lists are the users that **have not** changed their password in the last 85 days. It then sends a message to the SQS queue in Logging & Monitoring AWS account. **Important thing to note here is that the event is only triggerred when an IAM Identity Center admin (users managing the IAM Identity Center) will hit the Reset password button for a certain IAM Identity Center user. If the IAM Identity Center user follow the Forgot Password? process by themselves, they wont trigger the event and the Lambda will not be aware they have changed their password.**
- user-inactivity Lambda that "watches" for the `Authenticate` Cloudtrail IAM Identity Center event and does the same comparison as the password-expiraton Lambda based on this event. The difference list is the users that have not logged on to IAM Identity Center in the last 85 days. It then sends the list to the same SQS queue.

## Tool Versions ##
Terraform version used in this repository is 1.6.5
