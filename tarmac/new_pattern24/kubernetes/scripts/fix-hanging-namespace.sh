#!/bin/sh

# Fix hanging namespace in Kubernetes.
#
# Usage:
#   ./fix-hanging-namespace.sh <namespace_name>
#   Example: ./fix-hanging-namespace.sh my-namespace
#
# Description:
#   This script clears the finalizers of a given namespace to help with issues where 
#   the namespace is stuck in a 'Terminating' state.

ns=$1

if [ -z "$ns" ]; then
  echo "Usage: ./fix-hanging-namespace.sh <namespace_name>"
  exit 1
fi

kubectl get ns $ns -ojson | jq '.spec.finalizers = []' | kubectl replace --raw "/api/v1/namespaces/$ns/finalize" -f -

kubectl get ns $ns -ojson | jq '.metadata.finalizers = []' | kubectl replace --raw "/api/v1/namespaces/$ns/finalize" -f -
