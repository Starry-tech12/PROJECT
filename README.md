Project Bedrock — Retail Store Cloud Infrastructure
Production-ready deployment of the InnovateMart multi-tier microservices retail application on AWS. This project leverages Infrastructure as Code (IaC) for provisioning, container orchestration for application lifecycles, and a fully automated continuous integration and deployment (CI/CD) engine.

🚀 Key Engineering Accomplishments
Infrastructure as Code: 100% automated infrastructure provisioning using declarative Terraform layouts.

Orchestration & Compute: Multi-AZ deployment utilizing an AWS EKS (Elastic Kubernetes Service) cluster managing decoupled microservices inside a dedicated retail-app namespace.

IAM Roles for Service Accounts (IRSA): Enterprise-grade security mapping fine-grained AWS IAM roles natively to Kubernetes Service Accounts via OpenID Connect (OIDC).

Decoupled Persistence: Application data isolated off the compute nodes into Amazon DynamoDB and relational database layers.

Event-Driven Asset Processing: Automated media/asset pipeline using Amazon S3 storage buckets wired directly to AWS Lambda processors.

🏗️ Architecture Overview
The infrastructure isolates public-facing routing from core application business logic and backend database layers across multiple Availability Zones for high availability.

Networking Layer: Custom VPC with public subnets hosting internet-facing Application Load Balancers, and private subnets protecting EKS worker nodes and stateful resources.

Application Layer (carts): The Spring Boot backend service leverages a secure IAM web-identity trust relationship to read/write state directly to a cloud-managed Amazon DynamoDB table without hardcoded access credentials.

⚙️ Local Management & Operation Guide
1. Prerequisites
Ensure your local environment includes the following tools:

Windows 11 with WSL 2 / Git Bash (MINGW64)

AWS CLI v2 (authenticated against target account)

Terraform (v1.5+)

kubectl (configured to match EKS context)

2. Interacting with the Infrastructure
To safely refresh and extract architectural metadata for the compliance testing suite, run the following commands within the terraform/ directory:

Bash
# Refresh local state against live cloud architecture
terraform refresh

# Generate the automated script metrics artifact
terraform output -json > ../grading.json
3. Debugging Microservices Live
If you need to audit environment parameters or tail live logs for application container components (such as the retail-store-carts data-engine):

Bash
# Check running pod status within the application namespace
kubectl get pods -n retail-app

# Inspect the active environment block applied to the container runtime
kubectl get deployment retail-store-carts -n retail-app -o yaml

# Stream real-time initialization and Tomcat engine logs
kubectl logs -l app.kubernetes.io/name=carts -n retail-app --tail=50 -f
🛡️ Production Security & Isolation Model
Static Credential Mitigation: Zero long-lived programmatic AWS IAM Access Keys are injected into application deployments. Pods consume fine-grained tokens via sts:AssumeRoleWithWebIdentity.

Least Privilege Access: Security groups restrict ingress vectors so that compute nodes only receive traffic mapped directly from the verified Application Load Balancer boundaries.