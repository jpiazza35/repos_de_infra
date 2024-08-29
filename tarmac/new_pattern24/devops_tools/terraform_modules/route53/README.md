# AWS Route53

This is a terraform repository for AWS Route53. This module will control all of the DNS related resources within all AWS accounts. This module creates the following resources:

- ACM certificates
- Route53 zones and records

## Tool Versions ##
Terraform version used in this repository is 0.14.11

Note: this Terraform version is specific to the project where the module was created and used.
You should pick the Terraform version that meets your project's requirements. 

## How it works ##
How this code works is that in order for the resources written in this directory to be applied and created, we need to run the Terraform commands in the appropriate AWS account directory.

We create the NS records for all the subzones in the corresponding parent zone with this DNS module. We need to do that in order for our AWC ACM certificates (also managed with this module) to be validated.
We have ACM public certificates for all zones and subzones, those are the public SSL certificates used in the API gateways and in the ALB HTTPS termination.