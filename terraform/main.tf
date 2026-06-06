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

  eks_managed_node_groups = {
    main = {
      instance_types = ["t3.small"]
      min_size     = 2
      max_size     = 3
      desired_size = 2
    }
  }
  
  # Enable Control Plane Logging
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

# 3. Managed RDS (Example for MySQL)
resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  identifier           = "retail-db-mysql"
  engine               = "mysql"
  instance_class       = "db.t3.micro" # Cost saving
  db_name              = "retail"
  username             = "admin"
  password             = "SecurePass123!" # In Prod, use Secrets Manager
  skip_final_snapshot  = true
  db_subnet_group_name = module.vpc.database_subnet_group_name
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
# Keep this one (Since you didn't delete the S3 Bucket)
import {
  to = aws_s3_bucket.assets
  id = "bedrock-assets-alt-soe-025-4138"
}

# Keep this one (Since you didn't delete the IAM User)
import {
  to = aws_iam_user.dev_view
  id = "bedrock-dev-view"
}

# === MAKE SURE THE LAMBDA AND KMS IMPORT BLOCKS ARE COMPLETELY DELETED FROM THIS FILE ===