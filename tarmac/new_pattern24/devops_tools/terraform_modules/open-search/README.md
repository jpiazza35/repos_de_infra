# AWS OpenSearch Service (successor to Amazon Elasticsearch Service)

This is a terraform repository for AWS Open Search Service. This module creates the following resources:

- AWS Open Search Domain
- Open Search Domain Policy
- Open Search Role
- Open Search Security Group

## Structure ##

The `.tf` files in this module are named per what they manage e.g. `sg-open-search.tf` creates the security group and rules for Open Search. The `data.tf` file(s) contains all data sources for AWS resources that have been created using other Terraform modules.

## How it works ##
How this code works is that in order for the resources written in this directory to be applied and created, we need to run the Terraform commands in the appropriate AWS account directory. For example if we want to create the Open Search Cluster for the AWS `example-account`, we need to go into `my_folder/example_account` directory and initialize, plan and apply the changes with TF commands. The `main.tf` file there contains all modules needed for that AWS account and connects to directories created in the `terraform_modules` dir, just like this `terraform_modules/open-search` one.

## Tool Versions ##
Terraform version used in this repository is 1.1.3

Note: this Terraform version is specific to the project where the module was created and used.
You should pick the Terraform version that meets your project's requirements. 

# AWS OpenSearch Service details

Amazon OpenSearch Service (successor to Amazon Elasticsearch Service) is a managed service that makes it easy to deploy, operate, and scale OpenSearch clusters in the AWS Cloud. 

OpenSearch is a fully open-source search and analytics engine for use cases such as log analytics, real-time application monitoring, and clickstream analysis. For more information, see the OpenSearch documentation: https://opensearch.org/docs/

We have OpenSearch clusters (v1.0) running in CoreOU / logging & monitoring account.

OpenSearch Service domains offer encryption of data at rest, a security feature that helps prevent unauthorized access to our data. The feature uses AWS KMS to store and manage your encryption keys and the Advanced Encryption Standard algorithm with 256-bit keys (AES-256) to perform the encryption. We have it enabled, and this feature encrypts the following aspects of our domains:
    * All indices (including those in UltraWarm storage)
    * OpenSearch logs
    * Swap files
    * All other data in the application directory
    * Automated snapshots

To login and get access to the OpenSearch indexes, you will need VPN access and the administrator credentials for OpenSearch Dashboards.

Using those credentials, you will be allowed to manage users which are located in an internal database.


You can find more information about this here: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/encryption-at-rest.html