terraform {
  backend "s3" {
    bucket  = "innovatemart-tfstate-alt-soe-025-4138"
    key     = "capstone/project-bedrock/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}