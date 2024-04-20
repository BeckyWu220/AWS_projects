CREATE EXTENSION IF NOT EXISTS vector;
SELECT extversion FROM pg_extension WHERE extname='vector';
CREATE SCHEMA bedrock_integration;
CREATE ROLE bedrock_user WITH PASSWORD '{BEDROCK_USER_SECRET}' LOGIN;
GRANT ALL ON SCHEMA bedrock_integration to bedrock_user;
SET ROLE bedrock_user;
CREATE TABLE bedrock_integration.bedrock_kb (id uuid PRIMARY KEY, embedding vector(1536), chunks text, metadata json);
CREATE INDEX on bedrock_integration.bedrock_kb USING hnsw (embedding vector_cosine_ops);