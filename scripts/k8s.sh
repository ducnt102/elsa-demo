#!/bin/bash

# Stop the script if any command fails
set -e
# for minkube
kubectl() {
    minikube kubectl -- "$@"
}

# Define variables
NAMESPACE="hackathon-starter"
KUBE_MANIFEST_DIR="../k8s"
INGRESS_FILE="ingress.yaml"

# Function to apply Kubernetes manifests
apply_manifests() {
    echo "Applying Kubernetes manifests..."
    kubectl apply -f "$KUBE_MANIFEST_DIR" -n "$NAMESPACE"
    echo "Kubernetes manifests applied successfully."
}

# Function to configure ingress based on environment
configure_ingress() {
    if [ ! -f "$KUBE_MANIFEST_DIR/$INGRESS_FILE" ]; then
        echo "Ingress configuration file $INGRESS_FILE not found!"
        exit 1
    fi
    kubectl apply -f "$KUBE_MANIFEST_DIR/$INGRESS_FILE" -n "$NAMESPACE"
    echo "Ingress rules configured successfully."
}

# Function to create Kubernetes namespace if it doesn't exist
create_namespace() {
    if ! kubectl get namespace "$NAMESPACE" > /dev/null 2>&1; then
        echo "Creating namespace $NAMESPACE..."
        kubectl create namespace "$NAMESPACE"
    else
        echo "Namespace $NAMESPACE already exists."
    fi
}

# Main function
main() {

    # Create namespace if needed
    create_namespace

    # Apply Kubernetes manifests
    apply_manifests

    # Configure ingress rules
    configure_ingress

    echo "Deployment completed successfully"
}

# Execute the main function
main

