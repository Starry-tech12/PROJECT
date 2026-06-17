provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = { Project = "karatu-2025-capstone" }
  }
}

# 1. VPC Networking
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "project-bedrock-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  database_subnets             = ["10.0.201.0/24", "10.0.202.0/24"]
  create_database_subnet_group = true

  enable_nat_gateway = true
  single_nat_gateway = true # Cost saving
}

# 2. EKS Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "project-bedrock-cluster"
  cluster_version = "1.34"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = false
  
  access_entries = {
    dev_view = {
      kubernetes_groups   = []
      principal_arn       = "arn:aws:iam::127259106152:user/bedrock-dev-view"
      type                = "STANDARD"
      policy_associations = {
        admin = {
          policy_arn   = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = { type = "cluster" }
        }
      }
    }
  }

  eks_managed_node_groups = {
    main = {
      instance_types = ["t3.small"]
      min_size     = 0
      max_size     = 2
      desired_size = 0
    }
  }
  
  # Enable Control Plane Logging
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

# 3. Managed RDS (MySQL)
resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  identifier           = "retail-db-mysql"
  db_subnet_group_name = module.vpc.database_subnet_group_name
  engine               = "mysql"
  instance_class       = "db.t3.micro" 
  db_name              = "retail"
  username             = "admin"
  password             = "SecurePass123!" 
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]
}

resource "aws_security_group" "db_sg" {
  name   = "retail-db-sg"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }
}

# 4. Resource State Imports
import {
  to = aws_s3_bucket.assets
  id = "bedrock-assets-alt-soe-025-4138"
}

import {
  to = aws_iam_user.dev_view
  id = "bedrock-dev-view"
}

import {
  to = aws_iam_role.lambda_role
  id = "bedrock-lambda-execution-role"
}

import {
  to = module.eks.module.kms.aws_kms_alias.this["cluster"]
  id = "alias/eks/project-bedrock-cluster"
}
# 5. Managed RDS (PostgreSQL)
resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  identifier           = "retail-db-postgres"
  db_subnet_group_name = module.vpc.database_subnet_group_name
  engine               = "postgres"
  engine_version       = "15"
  instance_class       = "db.t3.micro"
  db_name              = "assets"
  username             = "postgres"
  password             = "SecurePassPostgres123!"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]
}

# 6. Managed DynamoDB Table
resource "aws_dynamodb_table" "retail_cart" {
  name           = "retail-cart-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

