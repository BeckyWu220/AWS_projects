variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "db_subnet_group_name" {
  description = "DB Subnet Group Name"
  type = string
}

variable "db_name" {
  description = "Database Name"
  type = string
  default = "postgres"
}

variable "table_name" {
    description = "Table Name"
    type = string
    default = "bedrock_integration.bedrock_kb"
}

variable "master_username" {
    description = "Master Username"
    type = string
    default = "postgres"
} 
