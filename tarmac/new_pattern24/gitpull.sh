#!/bin/bash


eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa

# Directorio donde están los repositorios
root_dir="/home/jpiazza/repos/tarmac/new_pattern24"

# Lista de repositorios basada en la estructura del directorio que mostraste
repos=( "app-incumbent-service"
        "app-incumbent-staging-db"
        "app-mpt-e2e-test"
        "app-mpt-postgres-db"
        "apt-mpt-project-service"
        "app-mpt-ui"
        "app-ps-e2e-test"
        "app-shared-protobuffs"
        "data-platform-databricks-common"
        "data-platform-devops-iac"
        "data-platform-iac"
        "data-platform-infrastructure"
        "helm-charts"
        "infra-aws-org-and-accounts"
        "infra-cluster-resources"
        "infra-tools"
        "kubernetes"
        "shared-services-iac"
        "aft-account-request"
        "devops_tools")

# Recorrer cada repositorio y hacer git pull
for repo in "${repos[@]}"; do
  echo "Actualizando $repo..."
  cd "$root_dir/$repo"
  git pull
done

echo "Todos los repositorios han sido actualizados."