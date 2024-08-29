#!/bin/bash

# Declare an associative array
declare -A appsMap

appsMap["app-mpt-project-service"]="7350"
appsMap["app-incumbent-api-service"]="8001"
appsMap["app-incumbent-grpc-service"]="8004"
appsMap["app-survey-api-service"]="7286"
appsMap["app-survey-grpc-service"]="7052"
appsMap["app-mpt-ui"]="80"
appsMap["app-user-grpc-service"]="7051"
appsMap["app-user-api-service"]="7211"
appsMap["app-organization-grpc-service"]="7004"

MARKET_PRICING_DB="app-mpt-postgres-db"
INCUMBENT_DB="app-incumbent-db"
INCUMBENT_STAGING_DB="app-incumbent-staging-db"

# Market_Pricing_DB
docker pull $GH_REGISTRY/$GH_OWNER/$MARKET_PRICING_DB:latest
minikube image load $GH_REGISTRY/$GH_OWNER/$MARKET_PRICING_DB:latest
helm install $MARKET_PRICING_DB -n $K8S_NAMESPACE ./minikube/charts -f minikube/charts/values.yaml \
--set fullnameOverride=$MARKET_PRICING_DB \
--set service.name=$MARKET_PRICING_DB \
--set service.port="5432" \
--set service.targetPort="5432" \
--set namespace.name=$K8S_NAMESPACE \
--set image.repository=$GH_REGISTRY/$GH_OWNER/$MARKET_PRICING_DB \
--set image.tag=latest

# Incumbent_DB
docker pull $GH_REGISTRY/$GH_OWNER/$INCUMBENT_DB:latest
minikube image load $GH_REGISTRY/$GH_OWNER/$INCUMBENT_DB:latest
helm install $INCUMBENT_DB -n $K8S_NAMESPACE ./minikube/charts -f minikube/charts/values.yaml \
--set fullnameOverride=$INCUMBENT_DB \
--set service.name=$INCUMBENT_DB \
--set service.port="5432" \
--set service.targetPort="5432" \
--set namespace.name=$K8S_NAMESPACE \
--set image.repository=$GH_REGISTRY/$GH_OWNER/$INCUMBENT_DB \
--set image.tag=latest

# Incumbent_Staging_DB
docker pull $GH_REGISTRY/$GH_OWNER/$INCUMBENT_STAGING_DB:latest
minikube image load $GH_REGISTRY/$GH_OWNER/$INCUMBENT_STAGING_DB:latest
helm install $INCUMBENT_STAGING_DB -n $K8S_NAMESPACE ./minikube/charts -f minikube/charts/values.yaml \
--set fullnameOverride=$INCUMBENT_STAGING_DB \
--set service.name=$INCUMBENT_STAGING_DB \
--set service.port="5432" \
--set service.targetPort="5432" \
--set namespace.name=$K8S_NAMESPACE \
--set image.repository=$GH_REGISTRY/$GH_OWNER/$INCUMBENT_STAGING_DB \
--set image.tag=latest

sleep 10

# Iterate through MPT services map and run k8s services
for key in "${!appsMap[@]}"
do
    if [[ $key == $PROJECT_NAME ]]; then
        docker pull $GH_REGISTRY/$GH_OWNER/$PROJECT_NAME-ecr-repo:$IMAGE_TAG
        minikube image load $GH_REGISTRY/$GH_OWNER/$PROJECT_NAME-ecr-repo:$IMAGE_TAG
        helm install $PROJECT_NAME -n $K8S_NAMESPACE ./minikube/charts -f minikube/charts/values.yaml \
        --set fullnameOverride=$PROJECT_NAME \
        --set service.name=$PROJECT_NAME \
        --set service.port=${appsMap[$key]} \
        --set service.targetPort=${appsMap[$key]} \
        --set namespace.name=$K8S_NAMESPACE \
        --set image.repository=$GH_REGISTRY/$GH_OWNER/$PROJECT_NAME-ecr-repo \
        --set image.tag=$IMAGE_TAG
    else
        docker pull $GH_REGISTRY/$GH_OWNER/$key-ecr-repo:latest
        minikube image load $GH_REGISTRY/$GH_OWNER/$key-ecr-repo:latest
        helm install $key -n $K8S_NAMESPACE ./minikube/charts -f minikube/charts/values.yaml \
        --set fullnameOverride=$key \
        --set service.name=$key \
        --set service.port=${appsMap[$key]} \
        --set service.targetPort=${appsMap[$key]} \
        --set namespace.name=$K8S_NAMESPACE \
        --set image.repository=$GH_REGISTRY/$GH_OWNER/$key-ecr-repo \
        --set image.tag=latest
    fi
done
