locals {
  tags = {
    created-by = "eks-workshop-v2"
    env        = var.cluster_name
  }
}

output "eks_cluster_arn" {
  value = module.eks.cluster_arn
}