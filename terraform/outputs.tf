output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "region" {
  value = "us-east-1"
}

output "vpc_id" {
  value = aws_vpc.bedrock.id
}

output "assets_bucket_name" {
  value = aws_s3_bucket.assets.id
}

output "dev_access_key" {
  value = aws_iam_access_key.dev.id
}

output "dev_secret_key" {
  value     = aws_iam_access_key.dev.secret
  sensitive = true
}