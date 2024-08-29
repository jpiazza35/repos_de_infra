[![Terraform Plan/Apply - US-EAST-1](https://github.com/clinician-nexus/aws-networking/actions/workflows/ss_network_config_east_1.yml/badge.svg)](https://github.com/clinician-nexus/aws-networking/actions/workflows/ss_network_config_east_1.yml)

[![Terraform Plan/Apply - US-EAST-2](https://github.com/clinician-nexus/aws-networking/actions/workflows/ss_network_config_east_2.yml/badge.svg)](https://github.com/clinician-nexus/aws-networking/actions/workflows/ss_network_config_east_2.yml)

# aws-networking
Networking components for AWS

This repository sets up the Transit Gateway which is the networking backbone of all AWS Accounts and resources and lives in `SS_NETWORK`. The GitHub action in this repository will create a terraform plan and requires a manual approval before the apply step.

The VPC integration supporting routing for the Kubernetes Clusters using the local routing cidr range `100.64.0.0/23` is also created in this repository.

It also handles the GitHub OIDC Configuration that supports the GitHub action within this repository.

### To Route using the Transit Gateway
If it is a **D_** account do the following, otherwise skip to the next step:

  - Associate to `tgw-dev` Transit Gateway Route Table

  - Propagate to the `tgw-shared-services` and `tgw-full` Transit Gateway Route Tables.

  - ***Note***: There should be no propagations on the `tgw-dev` table. If necessary, routes should be propagated to the `tgw-prod` table instead. 

If it is a **Q_/S_/P_** Account

  - Associate to `tgw-prod` Transit Gateway Route Table

  - Propagate to the `tgw-shared-services` and `tgw-full` Transit Gateway Route Tables.

Else, if it is a Shared Service (**SS_**) account

  - Associate to `tgw-shared-services` Transit Gateway Route Table

  - Propagate to all Transit Gateway Route Tables except `tgw-dev`
