# Bedrock Knowledge Base
resource "aws_bedrockagent_knowledge_base" "this" {
  name     = var.project_name
  role_arn = aws_iam_role.bedrock_kb.arn

  knowledge_base_configuration {
    type = "VECTOR"

    vector_knowledge_base_configuration {
      embedding_model_arn = "arn:aws:bedrock:${var.aws_region}::foundation-model/${var.embedding_model_id}"

      embedding_model_configuration {
        bedrock_embedding_model_configuration {
          dimensions = var.embedding_dimensions
        }
      }
    }
  }

  storage_configuration {
    type = "S3_VECTOR"

    s3_vector_configuration {
      bucket_arn = "arn:aws:s3vectors:${var.aws_region}:*:vector-bucket/${aws_s3_vector_bucket.this.bucket}"
    }
  }
}

# データソース（S3バケットからの取り込み設定）
resource "aws_bedrockagent_data_source" "this" {
  name              = "${var.project_name}-datasource"
  knowledge_base_id = aws_bedrockagent_knowledge_base.this.id

  data_source_configuration {
    type = "S3"

    s3_configuration {
      bucket_arn = aws_s3_bucket.datasource.arn
    }
  }

  vector_ingestion_configuration {
    chunking_configuration {
      chunking_strategy = "FIXED_SIZE"

      fixed_size_chunking_configuration {
        max_tokens         = 512
        overlap_percentage = 20
      }
    }
  }
}
