module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.8"

  cluster_name                   = var.cluster_name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = true

  cluster_addons = {
    vpc-cni = {
      before_compute = true
      most_recent    = true
      configuration_values = jsonencode({
        env = {
          ENABLE_POD_ENI                    = "false"
          ENABLE_PREFIX_DELEGATION          = "true"
          POD_SECURITY_GROUP_ENFORCING_MODE = "standard"
        }
        nodeAgent = {
          enablePolicyEventLogs = "true"
        }
        enableNetworkPolicy = "true"
      })
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  create_cluster_security_group = false
  create_node_security_group    = false

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    default = {
      instance_types       = ["t3.medium"]
      force_update_version = true
      release_version      = var.ami_release_version

      min_size     = 1
      max_size     = 2
      desired_size = 1

      update_config = {
        max_unavailable_percentage = 33
      }

      use_custom_launch_template = false
      remote_access = {
        ec2_ssh_key               = module.key_pair.key_pair_name
        # source_security_group_ids = [aws_security_group.worker_node_remote_access.id]
      }

      labels = {
        workshop-default = "yes"
      }
    }
  }

  tags = merge(local.tags, {
    "karpenter.sh/discovery" = var.cluster_name
  })
}

module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "~> 2.0"

  key_name_prefix    = var.cluster_name
  create_private_key = true

  tags = local.tags
}

resource "null_resource" "after_eks_creation" {
  depends_on = [module.eks, aws_iam_role.ebs_csi_driver_role]

  provisioner "local-exec" {
    command = <<EOF
      echo 'Update kube config';
      aws eks update-kubeconfig --name ${module.eks.cluster_name} --profile ${var.aws_profile} && \
      aws eks create-addon --cluster-name ${module.eks.cluster_name} --addon-name aws-ebs-csi-driver --service-account-role-arn ${aws_iam_role.ebs_csi_driver_role.arn}
    EOF
  }
}

data "aws_caller_identity" "current" {
  
}

locals {
  eks_cluster_oidc_issuer = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
}

resource "aws_iam_role" "ebs_csi_driver_role" {
  name = "AmazonEKS_EBS_CSI_DriverRole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.eks_cluster_oidc_issuer}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "${local.eks_cluster_oidc_issuer}:aud": "sts.amazonaws.com",
            "${local.eks_cluster_oidc_issuer}:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })

  tags = local.tags
}

resource "aws_iam_policy_attachment" "ebs_csi_driver_role_policy_attach" {
  name = "AmazonEKS_EBS_CSI_DriverRole_attach"
  roles = [aws_iam_role.ebs_csi_driver_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# resource "aws_security_group" "worker_node_remote_access" {
#   description = "Allow remote SSH access"
#   vpc_id = module.vpc.vpc_id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
# }