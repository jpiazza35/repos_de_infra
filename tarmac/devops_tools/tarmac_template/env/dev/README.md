# Basics

This folder represents the entire configuration for the "dev" environment for the project. All changes to the infrastructure in terms of adding/removing/adjusting services and resources should ideally happen from here. Should a change be needed that is not supported by the current implementation of the terraform modules (../../modules) please ask for DevOps support. Changing anything under the ../../modules will affect ALL environments, so it should be treated with caution.

# Files

* providers.tf
This file only defines the aws provider and the terraform version and the configuration for the tfstate.
The tfstate file is stored on S3 and there's also a dynamodb table that performs resource locks so that no two concurent terraform applies can happen.
In this file you can see the terraform version that needs to be installed locally in order to make any changes.
Currently: 
- Terraform version 1.1.5
- AWS Cli local profile name: default

* main.tf
This is the manifest that defines any and all resources that are to be created. Running "terraform plan/apply" actually goes through this file in top to bottom order and works off of that. Order of resources matters, unless handled by dependencies. Changes in this file will only affect the "dev" environment.

* configuration.auto.tfvars
This is an object that contains all environment specific configuration. It is here that names/tags/details are specified for the environment. This configuration is processed and used by main.tf to pass down variables to the modules. Changes in this file will only affect the "dev" environment.

# Working with the configuration file (configuration.auto.tfvars)
Each part of the configuration file is logically separated and commented. Adding configuration properties here is not sufficient for that to be reflected in the deployed infrastructure. Any new property added (with the exception of ecs task definition environment variables) needs to be picked up in main.tf and propagated to the modules, where it also has to be defined and used (call for DevOps support in this case).

## Adding a new ECS service

All ECS services are created dynamically from the "services" object in the configuration file.
At the start of the object there is a commented out template for service property configuration. Copy that template at the end of the list and fill out ALL the properties. No changes are required in main.tf
What will happen on next terraform apply:
* A new services will be added as that object is processed dynamically
* Based on the type there will be difference in the resources created:
** Type: public! This service will have a listener (and a target group with the defined health check) in the public load balancer, meaning it will be reachable via the internet. It will also have a listener (and a target group) in the internal load balancer for the service mesh.
** Type: private! This service will NOT be reachable via the internet. It will only have a listener (and target group) in the internal load balancer for the service mesh.
** Type: worker! This service will not be added to any load balancer and will therefore not have listeners and/or target groups. This is a standalone service (e.g. service that long pulls a queue)

## Adding a new database

In the configuration file copy all properties under the "## RDS variables" section, prefixed "db_". Change the property keys/names to a descriptive value for your need (can't have duplicate properties). Set the property values.

In main.tf copy the entire module "rds" and add it to the desired place in the order of modules. DO NOT change property names here ( the left side of the = ). Change only the property names being read from the configuration file ( "var.config. " )

## Adding another type of resource

Follow the database adding process above for any other type of resource. Supported resources is basically the different modules defined in main.tf.

# Useful commands

terraform init
Just initializes the current terraform setup: providers, plugins, modules, etc.
Upon adding new modules terraform has to be reinitialized.
rm -rf .terraform/
terraform init

terraform plan 
(DOES NOT perform any changes to the deployed infrastructure), simply gathers all managed resources and prints out any differences between the code and deployed infra

terraform apply
Performs a terraform plan and then waits for confirmation in order to deploy the infrastructure changes.