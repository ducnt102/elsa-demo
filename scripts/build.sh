#!/bin/bash

# Stop the script if any command fails
set -e

# Define variables
REGISTRY_URL="docker.io"
DOCKER_USERNAME="kaka2112"
DOCKER_PASSWORD="xyz"
SERVICE_1_NAME="hackathon-starter-web"
SERVICE_2_NAME="hackathon-starter-db"
TAG="latest"

# Function to log in to the Docker registry
docker_login() {
    echo "Logging in to Docker registry..."
    echo "$DOCKER_PASSWORD" | docker login "$REGISTRY_URL" -u "$DOCKER_USERNAME" --password-stdin
}

# Function to build Docker images
build_images() {
    echo "Building Docker images..."
    docker build -t "$REGISTRY_URL/$SERVICE_1_NAME:$TAG" ../web
    #docker build -t "$REGISTRY_URL/$SERVICE_2_NAME:$TAG" ./db
    echo "Docker images built successfully."
}

# Function to push Docker images to the registry
push_images() {
    echo "Pushing Docker images to registry..."
    docker push "$DOCKER_USERNAME/$SERVICE_1_NAME:$TAG"
    #docker push "$REGISTRY_URL/$SERVICE_2_NAME:$TAG"
    echo "Docker images pushed successfully."
}

# Main function
main() {
    docker_login
    build_images
    push_images

    echo "Build and push completed successfully."
}

# Execute the main function
main

