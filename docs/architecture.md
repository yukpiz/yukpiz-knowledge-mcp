# Architecture

## 構成図

```
S3 Bucket (datasource)
  │  Markdown, テキスト等を格納
  ▼
Bedrock Knowledge Base
  │  自動チャンキング + 埋め込みベクトル生成
  ▼
S3 Vectors (vector store)
  │  ベクトル格納・類似度検索
  ▼
bedrock-kb-retrieval-mcp-server (AWS公式)
  │  MCP Protocol (stdio)
  ▼
Claude Code
```

## コンポーネント

| コンポーネント | 役割 |
|---|---|
| S3 datasource bucket | ドキュメント格納。Markdownや記事を配置 |
| Bedrock Knowledge Base | データ取り込み・チャンク分割・埋め込み生成を自動実行 |
| S3 Vectors | ベクトルストア。コスト効率が高い |
| bedrock-kb-retrieval-mcp-server | AWS公式MCPサーバー。Claude CodeからKnowledge Baseを検索 |

## MCP Server設定

`~/.claude/settings.json` に以下を追加して利用する:

```json
{
  "mcpServers": {
    "knowledge-base": {
      "command": "uvx",
      "args": ["awslabs.bedrock-kb-retrieval-mcp-server@latest"],
      "env": {
        "AWS_PROFILE": "default",
        "AWS_REGION": "ap-northeast-1",
        "KNOWLEDGE_BASE_ID": "<Knowledge Base ID>"
      }
    }
  }
}
```

## 料金目安（個人用途）

| 項目 | 単価 |
|---|---|
| S3 Vectors PUT | $0.20/GB |
| S3 Vectors ストレージ | $0.06/GB/月 |
| S3 Vectors クエリ | 従量課金（データ量ベース） |
| Bedrock 埋め込みモデル | Titan Embed v2: $0.00002/1K tokens |

個人の知見・記事程度のデータ量であれば月数十セント程度の見込み。
