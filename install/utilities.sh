#!/bin/bash

set -e

# Variables (Update these as needed)
AWS_REGION="us-east-1"
JENKINS_USER="jenkins"

# Update and install prerequisites
echo "Updating system and installing prerequisites..."
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    unzip  # Install unzip package

# Install Docker
echo "Installing Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Create the Docker group if it does not exist
if ! getent group docker > /dev/null; then
  echo "Creating docker group..."
  sudo groupadd docker
fi

# Add Jenkins user to the Docker group
echo "Adding Jenkins user to the Docker group..."
sudo usermod -aG docker $JENKINS_USER
sudo systemctl restart jenkins

# Install AWS CLI
echo "Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install kubectl
echo "Installing kubectl..."
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Verify installations
echo "Verifying installations..."
docker --version
aws --version
kubectl version --client

# Configure AWS CLI for Jenkins (Optional: If you want to pre-configure AWS CLI)
# echo "Configuring AWS CLI for Jenkins..."
# sudo -u $JENKINS_USER aws configure set aws_access_key_id YOUR_AWS_ACCESS_KEY_ID
# sudo -u $JENKINS_USER aws configure set aws_secret_access_key YOUR_AWS_SECRET_ACCESS_KEY
# sudo -u $JENKINS_USER aws configure set default.region $AWS_REGION

echo "Installation and configuration complete!"
