# helm-charts
This repository contains all the helm charts and files for managing our kubernetes services and deployments.

## Folder Structure ##
The folders in this repository represent the specific applications/microservices/ingresses that we manage in kubernetes. These directories then contain all the helm charts and `values.yaml` files with the specific deployment details for each application/microservice.

## CI/CD pipeline ##
This repository has github actions configured and is part of the full flow on how we autodeploy the specific applications/microservices code into the kubernetes cluster(s). The CI/CD for our dev environments (`D_EKS`) works in the following way:

- The dev team merges a PR towards `main` branch in a specific application/microservice Github repo (e.g. `app-mpt-project-service`).
- That merge then runs unit tests and builds a new docker image using a shortened (10 characthers) commit SHA as a tag (along with a `dev` tag for the environment).
- When the pipeline finishes it pushes the new docker image into `SS_TOOLS ECR`.
- That pipeline then triggers the pipeline in this `helm-charts` repo.
- Apart from the trigger, the app specific pipeline passes 4 arguments which are the new docker tag (SHA), the project name (`app-mpt-project-service`), the environment to be updated (on PR opened/reopened this will be `dev`) and the product (`mpt` etc.)
- These 4 arguments are then used as env variables in `helm-charts` gh actions and used by the `update-values.py` script which updates the corresponding `values.yaml` file with the new docker tag.
- At the end, the `helm-charts` pipeline adds, commits and pushes this change directly into `main` branch.
- Dev ArgoCD then picks up the new change(s) and deploys accordingly.