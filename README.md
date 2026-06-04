# DevOps Tech Challenge 1

## Overview
This project deploys a Node.js frontend and backend application to AWS ECS Fargate using a fully automated CI/CD pipeline with Jenkins. Infrastructure is provisioned using Terraform.

## Architecture

### CI/CD Pipeline
GitHub → Webhook → Jenkins (Docker on EC2) → Docker Build → Amazon ECR → ECS Service Update
### Runtime Application
User → ALB → ECS Cluster
├── Frontend ECS Fargate (React)
└── Backend ECS Fargate (Express) ← /api
### Infrastructure Provisioning (Terraform)
Terraform → VPC → Public Subnets → Security Groups → ALB → ECS Cluster → ECS Services → Amazon ECR → IAM Roles
## Stack
- Frontend: React (Node.js)
- Backend: Express (Node.js)
- Containerization: Docker
- Container Registry: Amazon ECR
- Orchestration: AWS ECS Fargate
- Load Balancer: AWS Application Load Balancer
- CI/CD: Jenkins (Docker on EC2)
- IaC: Terraform
- Region: eu-west-3 (Paris)

## Application URLs
- Frontend: http://devops-tc1-alb-679051767.eu-west-3.elb.amazonaws.com
- Backend API: http://devops-tc1-alb-679051767.eu-west-3.elb.amazonaws.com/api

## Jenkins Server
- URL: http://35.180.22.22:8080
- Username: admin

## Infrastructure Components

### Manually Provisioned (Jenkins Server)
- EC2 instance (t3.micro) running Amazon Linux 2023
- Jenkins running inside a Docker container
- Security Group allowing SSH (22), Jenkins (8080) and agent (50000) traffic
- IAM user jenkins-ci-user with ECR and ECS permissions

### Terraform Provisioned (Application Infrastructure)
- VPC with 2 public subnets across 2 availability zones
- Internet Gateway and Route Tables
- Security Groups for ALB and ECS
- Application Load Balancer with path-based routing
- ECS Cluster (Fargate)
- ECS Task Definitions for frontend and backend
- ECS Services for frontend and backend
- ECR Repositories for frontend and backend images
- IAM Role for ECS task execution
- CloudWatch Log Groups
- Auto Scaling policies (min 1, max 4, 50% CPU trigger)

## ECS Configuration
- Launch type: Fargate
- CPU per task: 0.5 vCPU (512 CPU units)
- Memory per task: 1 GB
- Minimum tasks: 1
- Desired tasks: 1
- Maximum tasks: 4
- Auto Scaling trigger: 50% CPU utilization

## Deployment Steps

### Prerequisites
- AWS CLI configured
- Terraform installed
- Docker Desktop installed
- Node.js installed

### Local Setup
```bash
git clone https://github.com/Vboxmoh/tech-challenge-1.git
cd tech-challenge-1
```

### Backend
```bash
cd backend
npm ci
npm start
```

### Frontend
```bash
cd frontend
npm install
npm start
```

### Docker Setup
```bash
docker-compose up --build
```

### Terraform Infrastructure Deployment
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### Jenkins Pipeline
The Jenkins pipeline automatically:
1. Checks out code from GitHub
2. Logs into Amazon ECR
3. Builds Docker images for frontend and backend
4. Pushes images to ECR
5. Updates ECS services with new images

### GitHub Webhook Automation
GitHub webhooks are configured to automatically trigger the Jenkins pipeline on every push to the main branch.
Webhook URL: http://35.180.22.22:8080/github-webhook/

## Amazon ECR Repositories
- Frontend: 277778298945.dkr.ecr.eu-west-3.amazonaws.com/devops-tc1-frontend
- Backend: 277778298945.dkr.ecr.eu-west-3.amazonaws.com/devops-tc1-backend

## Bonus: GitOps Alternative with GitHub Actions
A GitOps alternative using GitHub Actions is implemented in the gitops branch.

### Branch Strategy
**main branch** — Jenkins-based deployment pipeline
GitHub → Webhook → Jenkins → Docker Build → Amazon ECR → Amazon ECS
**gitops branch** — GitHub Actions deployment pipeline
GitHub Push → GitHub Actions → Docker Build → Amazon ECR → Amazon ECS
