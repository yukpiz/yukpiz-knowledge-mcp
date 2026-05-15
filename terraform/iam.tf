# Bedrock Knowledge Base用IAMロール
resource "aws_iam_role" "bedrock_kb" {
  name = "${var.project_name}-bedrock-kb-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "bedrock.amazonaws.com"
        }
      }
    ]
  })
}

# S3データソースへの読み取り権限
resource "aws_iam_role_policy" "bedrock_kb_s3" {
  name = "${var.project_name}-bedrock-kb-s3"
  role = aws_iam_role.bedrock_kb.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.datasource.arn,
          "${aws_s3_bucket.datasource.arn}/*"
        ]
      }
    ]
  })
}

# S3 Vectorsへの書き込み・クエリ権限
resource "aws_iam_role_policy" "bedrock_kb_vectors" {
  name = "${var.project_name}-bedrock-kb-vectors"
  role = aws_iam_role.bedrock_kb.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3vectors:CreateIndex",
          "s3vectors:PutVectors",
          "s3vectors:QueryVectors",
          "s3vectors:GetVectors",
          "s3vectors:DeleteVectors",
          "s3vectors:ListVectors"
        ]
        Resource = [
          aws_s3vectors_vector_bucket.this.arn,
          "${aws_s3vectors_vector_bucket.this.arn}/index/*"
        ]
      }
    ]
  })
}

# Bedrock埋め込みモデルへのアクセス権限
resource "aws_iam_role_policy" "bedrock_kb_model" {
  name = "${var.project_name}-bedrock-kb-model"
  role = aws_iam_role.bedrock_kb.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel"
        ]
        Resource = [
          "arn:aws:bedrock:${var.aws_region}::foundation-model/${var.embedding_model_id}"
        ]
      }
    ]
  })
}
