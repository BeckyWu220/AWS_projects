resource "aws_rds_cluster" "db_cluster" {
  cluster_identifier = "cloud-summit-vector-db-cluster"
  engine             = "aurora-postgresql"
  engine_mode        = "provisioned"
  enable_http_endpoint = true
  engine_version     = "15.4"
  database_name      = var.db_name
  manage_master_user_password = true
  master_username    = var.master_username
  skip_final_snapshot = true

  serverlessv2_scaling_configuration {
    max_capacity = 2.0
    min_capacity = 0.5
  }

  vpc_security_group_ids = [ module.db_sg.security_group_id ]
  db_subnet_group_name = var.db_subnet_group_name
}

resource "aws_rds_cluster_instance" "db_instance" {
  cluster_identifier = aws_rds_cluster.db_cluster.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.db_cluster.engine
  engine_version     = aws_rds_cluster.db_cluster.engine_version
  publicly_accessible = true
}

output "db_cluster_arn" {
  description = "Aurora DB Cluster ARN"
  value = aws_rds_cluster.db_cluster.arn
}

output "db_endpoint" {
  description = "Writer Instance Endpoint" 
  value = aws_rds_cluster_instance.db_instance.endpoint
}

output "db_secret_arn" {
    description = "Block that specifies the master user secret"
    value = aws_rds_cluster.db_cluster.master_user_secret[0].secret_arn
}