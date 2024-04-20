This project is created for Vancouver Cloud Summit AI Demo - AWS Bedrock Knowledgebase, and it's mainly used to create a vector database in Aurora Serverless V2 for the Demo environment setup. 

Steps to create a Vector Database in Aurora Serverless V2:
- `terraform init`
- `./manifest/terraform.tfvars` fill in your AWS profile name to `aws_profile` field.
- Once Terrform is successfully initialized, run `terraform plan` and `terraform apply --auto-approve` to provision the AWS resources.
    The AWS resources mainly include: a VPC consists of two public subnets, a Aurora Serverless cluster with PostgreSQL engine 15.4 (required to install vector database extension), two secrets in Secrets Managers (one for master user and Bedrock access respectively). `prepare_db.sql` contains SQL statements to install the vector extension, create db user for Bedrock accessing, and a vector table `bedrock_integration.bedrock_kb`. The table's fields are defined based on [AWS insturctions](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraPostgreSQL.VectorDB.html), which are `id`, `embedding`, `chunks` and `metadata`. These fields are required for Bedrock to properly store embeddings to the table. 
- The provision takes around 10 mins to complete, and you should have outputs like below.
    ![Terraform Outputs](./screenshots/terraform_outputs.jpg)

Other Useful Links:
- [Set up a vector index for your knowledge base in a supported vector store](https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base-setup.html)