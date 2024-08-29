# Bigeye Agent Deployment on Kubernetes

This directory contains the Kubernetes manifests and deployment configurations for our Bigeye agents. The Bigeye agent is used to monitor data health, check for data anomalies, and ensure the quality of data in our SQL databases.

## Architecture

The deployment is structured to run the Bigeye agents within our Kubernetes cluster. This allows the agent to interact securely with our SQL servers and the Bigeye SaaS environment.

## Monitoring Configuration

For the Data Team to add SQL databases to the Bigeye UI for monitoring, we have provided a detailed guide. This guide will walk you through the process of configuring new data sources within the Bigeye UI using the Kubernetes deployment patterns established by the DevOps team.

- [Add New Data Sources to Bigeye UI](AddingDatasources.md)

Please follow the instructions in the linked document to ensure proper setup and monitoring of new databases.
