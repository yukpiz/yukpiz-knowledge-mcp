# ドキュメント格納用S3バケット（Knowledge Baseのデータソース）
resource "aws_s3_bucket" "datasource" {
  bucket = "${var.project_name}-datasource"
}

resource "aws_s3_bucket_versioning" "datasource" {
  bucket = aws_s3_bucket.datasource.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "datasource" {
  bucket = aws_s3_bucket.datasource.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "datasource" {
  bucket = aws_s3_bucket.datasource.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ベクトルストア用S3 Vectorsバケット
resource "aws_s3_vector_bucket" "this" {
  bucket = "${var.project_name}-vectors"
}

resource "aws_s3_vector_bucket_index" "this" {
  vector_bucket = aws_s3_vector_bucket.this.bucket
  index_name    = "knowledge-index"

  embedding_configuration {
    dimensions = var.embedding_dimensions
    data_type  = "float32"
  }

  distance_metric = "cosine"
}
