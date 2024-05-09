locals {
  tags = {
    created-by = "eks-workshop-v2"
    env        = var.cluster_name
  }
}

output "eks_cluster_arn" {
  value = module.eks.cluster_arn
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "eks_ebs_csi_driver_role_arn" {
  value = aws_iam_role.ebs_csi_driver_role.arn
}