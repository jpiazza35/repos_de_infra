#!/bin/bash

if [ ! -z "$SERVICE" ]; then
    aws ecs list-tasks --cluster <YOUR_CLUSTER_NAME> --service-name $SERVICE | jq -r ".taskArns[]" | awk '{print "aws ecs stop-task --cluster <YOUR_CLUSTER_NAME> --task \""$0"\""}' | sh
   else
     for r in <LIST_OF_SERVICES_IN_CLUSTER>; do
        printf "\n\nName of task: $r\n\n\n"
        aws ecs list-tasks --cluster <YOUR_CLUSTER_NAME> --service-name $r | jq -r ".taskArns[]" | awk '{print "aws ecs stop-task --cluster <YOUR_CLUSTER_NAME> --task \""$0"\""}' | sh
     done
fi