terraform {
  backend "s3" {
    bucket  = "bedrock-assets-alt-soe-025-4138"
    key     = "capstone/project-bedrock/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}