#!/bin/bash

PROJECT_NAME="proj-1"

echo "Creating project structure for $PROJECT_NAME ..."

# Root project folder
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME || exit

# React folders (if cloning repo, these may already exist)
mkdir -p src public

# DevOps folders
mkdir -p k8s
mkdir -p scripts
mkdir -p pipeline
mkdir -p docs
mkdir -p terraform

# Terraform files
touch terraform/provider.tf
touch terraform/backend.tf
touch terraform/variables.tf
touch terraform/outputs.tf
touch terraform/vpc.tf
touch terraform/eks.tf
touch terraform/ecr.tf
touch terraform/codebuild.tf
touch terraform/codepipeline.tf
touch terraform/iam.tf

# Kubernetes files
touch k8s/deployment.yaml
touch k8s/service.yaml
touch k8s/ingress.yaml
touch k8s/namespace.yaml
touch k8s/hpa.yaml

# Script files
touch scripts/deploy.sh
touch scripts/ecr_push.sh

# Pipeline docs
touch pipeline/pipeline-architecture.md

# Documentation placeholders
touch docs/eks-cluster.png
touch docs/codebuild-logs.png
touch docs/loadbalancer.png

# Root level files
touch Dockerfile
touch .dockerignore
touch buildspec.yml
touch README.md

# Git initialization
git init .

echo ""
echo "Project structure created successfully!"
echo ""
echo "Final structure:"
echo ""
tree -a
