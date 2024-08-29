# AWS Transit Gateway

This is the directory where all AWS Transit Gateway resources are defined. This module creates the following resources:

- Transit Gateway
- Routes and TGW attachments

## Structure ##

The `.tf` files in this module are named per what they manage e.g. `transit-gw.tf` manages the creation of the Transit Gateway itself.

## How it works ##
How this code works is that in order for the resources written in this directory to be applied and created, we need to run the Terraform commands in the appropriate AWS account directory. 

For example, if we need to create the Transit Gateway in the AWS `example-account` we need to go to `my_folder/example_account` and run the plan and apply there. 
What this module handles is the Transit Gateway, the routes and attachments needed to connect all VPCs from the other accounts to the Transit Gateway.

## Tool Versions ##
Terraform version used in this repository is 1.1.3

Note: this Terraform version is specific to the project where the module was created and used.
You should pick the Terraform version that meets your project's requirements. 
