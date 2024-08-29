# GitHub Actions Runner on AWS ECS

This repository contains the necessary configurations to deploy a GitHub Actions Runner on AWS ECS using Terraform. The runner is containerized using Docker and is based on Ubuntu 22.04.

## Repository Structure

- `Dockerfile`: Defines the Docker image for the GitHub Actions Runner.
- `infra/`: Contains Terraform configurations for deploying the runner on AWS ECS.
  - `main.tf`: Primary Terraform configuration file.
  - `terraform.tfvars`: Contains variable definitions used in Terraform configurations.
  - `variables.tf`: Declares variables expected by the `main.tf`.

## Building the Image Locally

1. Ensure Docker is installed on your machine.
2. Clone this repository and navigate to the directory.
3. Run the following command to build the Docker image:
   ```bash
   docker build -t github-runner-image .
  ```
