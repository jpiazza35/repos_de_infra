# AWS API Gateway

This is the directory where all AWS API Gateway resources are defined. This module creates the following resources:

- API Gateway API(s)
- API GW stage, deployment, method(s), integration(s)
- S3 bucket for storing the `truststore.pem` files.
- Route53 DNS record for the API GW custom domain names
- AWS NLB resources (NLB, target group)
- AWS ALB

## Structure ##

The `.tf` files in this module are named per what they manage e.g. `api-gw.tf` manages the API gateway resource. 

## How it works ##
How this code works is that in order for the resources written in this directory to be applied and created, we need to run the Terraform commands in the appropriate AWS account directory. For example if we want to create the API Gateway `example-account` infra, we need to go into `my_folder/example_account` directory and initialize, plan and apply the changes with TF commands. The `main.tf` file there contains all modules needed for that AWS account and connects to directories created in the `modules` dir, just like this `terraform_modules/api-gw` one.

What this module creates and sets up is the full infrastructure:
API-GW -> NLB -> ALB

The request comes to the API-GW, goes through the load balancers (currently there is no way to connect a private ALB directly to an API GW, so we also need a NLB) and reaches the ECS backend. We are doing some transformations of the request in the API GW `integrations.tf` file, where we write the Organization-ID header needed for the mTLS verification in the application.
The mTLS is set up in the `domain-names.tf` file.

## Endpoints/paths ##
The level of endpoints we create in the API gateways are up to level 2. Meaning we have the root endpoint (/) as the first level and then all that go after it (e.g. /actuator, /mpi etc.) are second level endpoints. After those we use the "catch-all" {proxy+} endpoint which allows us to passthrough all requests coming to the gateways after the 2nd level endpoints. This means that we have something like a wildcard e.g. /mpi/*, /actuator/*.

How the endpoints are actually created is that we have variables in the `main.tf` files for them. Those variables differ per application and if a new 2nd level endpoint is needed, we just need to add it to the `api_gw_2nd_level_endpoints` variable in the `main.tf` files.

## HTTP Methods usage ###
The different HTTP methods (GET, POST, PUT) used in the API gateways across all applications are handled with separate terraform resource blocks. We did it like this since it gives us the biggest flexibility around whether an app needs a certain method or not, since different apps have different methods. How we then handle if we create a certain method or not is via boolean variables, located and value for them in the `main.tf` files for all apps and envs. The variables are named like `uses_get_method`, `uses_post_method` etc. If set to true, that specific method is created and added to that API GW. One note here is that these bool variables only work and are applied to the 2nd level endpoints, the root one has a separate one named `api_gw_root_endpoint_methods` which also resides in the same place. The internal (private) endpoints also have their own variable for this purpose named `internal_endpoints_methods`.

## API GW Logging ##
When talking about API GW logging (this was disabled since it should not be present per PCI requirement), if needed, it can be enabled by setting the `create_api_gw_iam` boolean variable in the `main.tf` files in all product directories to **true**. When this is done, terraform will then create the IAM role to be used by API GW and also enable this on an account level. This means that this variable should only be set to true when needed in the main.tf.

## Tool Versions ##
Terraform version used in this repository is 0.14.11

Note: this Terraform version is specific to the project where the module was created and used.
You should pick the Terraform version that meets your project's requirements. 
