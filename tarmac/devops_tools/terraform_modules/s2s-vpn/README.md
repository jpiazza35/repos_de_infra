# AWS Site to Site VPN

This is the directory where all AWS Site to Site VPN resources are defined. This module creates the following resources:

- VPC Customer Gateway
- VPN Connection

## Structure ##

The `.tf` files in this module are named per what they manage e.g. `vpn-connection.tf` manages the creation of the VPN connection.

## How it works ##
How this code works is that in order for the resources written in this directory to be applied and created, we need to run the Terraform commands in the appropriate AWS account directory. 

The VPN is connected to the TGW with routes which then is connected with attachments and routes to all AWS accounts where a VPN connection is needed.

## Tool Versions ##
Terraform version used in this repository is 1.1.3

Note: this Terraform version is specific to the project where the module was created and used.
You should pick the Terraform version that meets your project's requirements. 
