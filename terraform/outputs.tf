output "knowledge_base_id" {
  description = "Bedrock Knowledge Base ID"
  value       = aws_bedrockagent_knowledge_base.this.id
}

output "datasource_bucket_name" {
  description = "S3 bucket name for documents"
  value       = aws_s3_bucket.datasource.id
}

output "vector_bucket_name" {
  description = "S3 vector bucket name"
  value       = aws_s3_vector_bucket.this.bucket
}
