data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "cloud-summit-vpc"
  cidr = "192.168.0.0/27"

  azs             = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  public_subnets  = ["192.168.0.0/28", "192.168.0.16/28"]

  tags = {
    "Created for" = "Cloud Summit"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "cloud-summit-public-db-subnet-group"
  subnet_ids = module.vpc.public_subnets

  tags = {
    "Created for" = "Cloud Summit"
  }
}

module "aurora" {
  source = "../modules/aurora-postgres-serverless"
  vpc_id = module.vpc.vpc_id
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  master_username = var.master_username
  db_name = var.db_name
}

locals {
  bedrock_username = "bedrock_user"
  bedrock_password = jsondecode(data.aws_secretsmanager_secret_version.bedrock_secret.secret_string)["password"]
  db_master_password = jsondecode(data.aws_secretsmanager_secret_version.master_secret.secret_string)["password"]
  sql_file = "prepare_db.sql"
}

data "aws_secretsmanager_random_password" "bedrock_secret" {
  password_length = 15
  exclude_numbers = true
  exclude_punctuation = true
}

resource "aws_secretsmanager_secret" "bedrock_secret" {
  name = "cloud-summit-bedrock-user-secret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "bedrock_secret" {
  secret_id = aws_secretsmanager_secret.bedrock_secret.id
  secret_string = <<EOF
  {
    "username": "${local.bedrock_username}",
    "password": "${data.aws_secretsmanager_random_password.bedrock_secret.random_password}"
  }
  EOF
  lifecycle {
    ignore_changes = [ secret_string ]
  }
}

data "aws_secretsmanager_secret_version" "bedrock_secret" {
  depends_on = [ aws_secretsmanager_secret_version.bedrock_secret ]
  secret_id = aws_secretsmanager_secret.bedrock_secret.id
}

data "aws_secretsmanager_secret_version" "master_secret" {
  depends_on = [ module.aurora ]
  secret_id = module.aurora.db_secret_arn
}

resource "null_resource" "prepare_db" {
  depends_on = [ module.aurora, aws_secretsmanager_secret_version.bedrock_secret ]

  triggers = {
    file = filesha1(local.sql_file)
  }

  provisioner "local-exec" {
    command = <<-EOF
    sed "s/{BEDROCK_USER_SECRET}/$BEDROCK_USER_SECRET/g" $SQL_FILE | psql -h $DB_HOST -p 5432 -U $DB_USER -d $DB_NAME
    EOF
    environment = {
      DB_NAME               = var.db_name
      DB_HOST               = module.aurora.db_endpoint
      DB_USER               = var.master_username
      SQL_FILE              = local.sql_file
      BEDROCK_USER_SECRET   = local.bedrock_password
      PGPASSWORD            = local.db_master_password
    }
    interpreter = ["bash", "-c"]
  }
}

output "db_endpoint" {
  description = "Writer Instance Endpoint. (Not needed unless for debugging purpose)" 
  value = module.aurora.db_endpoint
}

output "vector_db_fields" {
    description = "Information required to connect a Bedrock knowledgebase with vector database hosted in Auora Serverless"
    value = {
        "Amazon Aurora DB Cluster ARN": module.aurora.db_cluster_arn,
        "Database Name": var.db_name,
        "Table Name": "bedrock_integration.bedrock_kb",
        "Credential Secret ARN": aws_secretsmanager_secret.bedrock_secret.arn,
        "Vector Field Name": "embedding",
        "Text Field Name": "chunks",
        "Metadata Field Name": "metadata",
        "Primary Key": "id"
    }
}