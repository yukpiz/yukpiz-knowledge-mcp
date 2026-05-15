# yukpiz-knowledge-mcp

個人の知見・経験・記事をベクトルストアに蓄積し、Claude Code (MCP) 経由で検索・活用するためのインフラ構成。

## 構成

- **S3**: ドキュメント格納（データソース）
- **Amazon Bedrock Knowledge Base**: 自動チャンキング・ベクトル化
- **Amazon S3 Vectors**: ベクトルストア
- **bedrock-kb-retrieval-mcp-server**: MCP経由でClaude Codeから検索

## セットアップ

### 前提条件

- AWS CLI（defaultプロファイル設定済み）
- Terraform >= 1.0

### tfstate用S3バケットの作成（初回のみ）

```bash
aws s3 mb s3://yukpiz-knowledge-mcp-tfstate \
  --region ap-northeast-1
```

### インフラ構築

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### MCP Server設定

`~/.claude/settings.json` に追加:

```json
{
  "mcpServers": {
    "knowledge-base": {
      "command": "uvx",
      "args": ["awslabs.bedrock-kb-retrieval-mcp-server@latest"],
      "env": {
        "AWS_PROFILE": "default",
        "AWS_REGION": "ap-northeast-1",
        "KNOWLEDGE_BASE_ID": "<terraform output knowledge_base_id>"
      }
    }
  }
}
```

### ドキュメントの追加

```bash
aws s3 cp ./your-document.md \
  s3://yukpiz-knowledge-mcp-datasource/
```

アップロード後、Bedrock Knowledge Baseの同期を実行:

```bash
aws bedrock-agent start-ingestion-job \
  --knowledge-base-id <KB_ID> \
  --data-source-id <DS_ID>
```
