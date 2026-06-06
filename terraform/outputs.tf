output "cluster_endpoint" { value = module.eks.cluster_endpoint }
output "cluster_name"     { value = module.eks.cluster_name }
output "region"           { value = "us-east-1" }
output "vpc_id"           { value = module.vpc.vpc_id }
