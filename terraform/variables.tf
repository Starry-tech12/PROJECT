variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_name" {
  type    = string
  default = "project-bedrock-vpc"
}

variable "cluster_name" {
  type    = string
  default = "project-bedrock-cluster"
}

variable "student_id" {
  type        = string
  description = "Your unique student ID/Name for bucket suffixing"
}