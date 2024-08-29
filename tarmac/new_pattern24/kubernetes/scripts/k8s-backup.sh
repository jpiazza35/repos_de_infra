#!/bin/bash

# Define the directory where backups will be stored
BACKUP_DIR="./k8s-backup"
mkdir -p "$BACKUP_DIR"

# Loop over all namespaces
for ns in $(kubectl get ns --no-headers | awk '{print $1}'); do 
    # Create a directory for the namespace
    NS_DIR="$BACKUP_DIR/$ns"
    mkdir -p "$NS_DIR"
    
    # Loop over all namespaced resource types in the current namespace
    for type in $(kubectl api-resources --verbs=list --namespaced=true -o name | grep -v "events"); do 
        # Get the resource and save it to a YAML file
        kubectl get $type -n $ns -o yaml > "$NS_DIR/$type.yaml"
    done
done

# Backup non-namespaced resources
NON_NAMESPACED_DIR="$BACKUP_DIR/non-namespaced"
mkdir -p "$NON_NAMESPACED_DIR"

for type in $(kubectl api-resources --verbs=list --namespaced=false -o name); do
    kubectl get $type -o yaml > "$NON_NAMESPACED_DIR/$type.yaml"
done

echo "Backup completed and stored in $BACKUP_DIR"
