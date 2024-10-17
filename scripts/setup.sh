#!/bin/bash

# Stop the script if any command fails
set -e

# Define variables
DOCKER_COMPOSE_VERSION="1.29.2"
MINIKUBE_VERSION="v1.31.2"

# Function to install Docker
install_docker() {
    echo "Installing Docker..."
    sudo apt-get update -y
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update -y
    sudo apt-get install -y docker-ce

    # Enable and start Docker service
    sudo systemctl enable docker
    sudo systemctl start docker

    # Add current user to the Docker group
    sudo usermod -aG docker $USER
    echo "Docker installed successfully."
}

# Function to install Docker Compose
install_docker_compose() {
    echo "Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "Docker Compose installed successfully."
}

# Function to install Minikube
install_minikube() {
    echo "Installing Minikube..."
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/${MINIKUBE_VERSION}/minikube-linux-amd64
    sudo install minikube /usr/local/bin/
    rm minikube
    echo "Minikube installed successfully."
}

# Function to install Git
install_git() {
    echo "Installing Git..."
    sudo apt-get update -y
    sudo apt-get install -y git
    echo "Git installed successfully."
}

# Main function
main() {
    echo "Starting setup..."
    install_docker
    install_docker_compose
    install_minikube
    install_git

    echo "Setup completed successfully. Please restart your terminal to apply Docker group changes."
}

# Execute the main function
main

