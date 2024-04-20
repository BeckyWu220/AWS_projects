module "db_sg" {
    source  = "terraform-aws-modules/security-group/aws"
    version = "5.1.1"
    
    name = "cloud-summit-vector-db-sg"
    description = "Security Group for Aurora DB Cluster"
    vpc_id = var.vpc_id

    # Ingress rules
    ingress_cidr_blocks = ["0.0.0.0/0"] # !!
    ingress_rules = ["postgresql-tcp"]

    # Egress rules
    egress_rules = ["all-all"]

}