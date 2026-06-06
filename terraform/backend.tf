terraform {
  backend "s3" {
    bucket = "bedrock-assets-alt-soe-025-4138"
    key    = "project-bedrock/terraform.tfstate"
    region = "us-east-1"
  }
}