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

variable "vector_field_name" {
    description = "Vector Field Name"
    type = string
    default = "embedding"
}

variable "master_username" {
    description = "Master Username"
    type = string
    default = "postgres"
} 

variable "bedrock_username" {
    description = "Bedrock Username"
    type = string
    default = "embedding"
} 