terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.24"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
  }
  
   backend "s3" {
    bucket = "bedrock-assets-alt-soe-025-4138" 
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
  }

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project = "karatu-2025-capstone"
    }
  }
}