# Data.world Agent Script Documentation

## Introduction

This documentation provides an overview of the Python script for running tasks with the Data.world agent. The script utilizes the AWS ECS (Elastic Container Service) to execute tasks in various environments based on event data.

## Prerequisites

Before using the script, ensure the following prerequisites are met:

- AWS CLI and Boto3 are installed and configured.
- Necessary permissions are set up for AWS ECS.
- Data.world API token is obtained and accessible.
- Proper AWS VPC, subnets, and security groups are configured.

## Script Overview

The script, written in Python, runs tasks with different configurations based on the provided event data. It exports environment variables, dynamically generates ECS task overrides, and executes the tasks on AWS ECS using the Fargate launch type.

## Usage

To use this script, you need to pass event data as input, typically in the form of a JSON object. The script reads environment variables and runs tasks based on the values provided in the event data.

### Function: `run_task_with_event_data`

This function runs tasks based on the event data. It exports environment variables, configures ECS task overrides, and executes the tasks on AWS ECS.

#### Parameters

- `event_data`: JSON object containing event-specific data.
- `container_name`: Name of the ECS container.
- `dataworld_api_token`: Data.world API token.
- `ecs_cluster`: AWS ECS cluster.
- `subnetIds`: List of AWS subnet IDs.
- `security_group`: AWS security group.
- `init_command`: Initialization command for the task.

### Function: `lambda_handler`

This function is the entry point for AWS Lambda. It extracts necessary values from the event, fetches AWS VPC and subnet information, and dynamically generates event data for task execution.

#### Parameters

- `event`: AWS Lambda event object containing event-specific data.
- `context`: AWS Lambda context object.

## Event Data

The script expects event data to be provided in the following format:

```json
{
  "container_name": {
    "dataworld": {
      "dataworld_ces": "container_name"
    }
  },
  "db_host": "your_db_host",
  "db_name": "your_db_name",
  "db_pass": "your_db_password",
  "db_user": "your_db_user",
  "ecs_cluster": {
    "dataworld": "ecs_cluster_name"
  },
  "init_command": "your_init_command",
  "security_group": {
    "dataworld": "your_security_group_id"
  },
  "upload_location": "your_upload_location"
}
```

Example Usage

You can invoke this script by passing the required event data to the lambda_handler function. Make sure to customize the event data based on your specific requirements.

Conclusion
This documentation provides an overview of the Python script for running tasks with the Data.world agent. It explains the script's purpose, prerequisites, functions, and usage instructions. Customize the event data to suit your use case and integrate it into your AWS Lambda environment.

For any further assistance or inquiries, please refer to the script's developer or maintainers.
