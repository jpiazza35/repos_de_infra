#!/bin/bash

ALB_NAME=$(echo $(kubectl get ingress istio-alb -n istio -o json -o jsonpath="{.status.loadBalancer.ingress[*].hostname}"))

ALB_ZONE=$(aws elbv2 describe-load-balancers | jq -r ".LoadBalancers[] | select(.DNSName == \"${ALB_NAME}\" ) | .CanonicalHostedZoneId")

jq -rn --arg alb_name "$ALB_NAME" --arg alb_zone "$ALB_ZONE" '{"alb_name":$alb_name,"alb_zone":$alb_zone}' 
