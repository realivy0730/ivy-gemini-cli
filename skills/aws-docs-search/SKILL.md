---
name: aws-docs-search
description: "搜尋與閱讀 AWS 官方文件，包含服務指南、最佳實踐與故障排除。用於查詢 AWS 文件或服務規格。 Use when searching or reading AWS official documentation."
---

# AWS Documentation Search

## 架構描述
使用 aws-documentation-mcp-server 查詢 AWS 官方文件，包含搜尋、讀取、推薦相關文件。

## 觸發方式
- "查詢 AWS [服務] 文件"
- "AWS [主題] 最佳實踐"
- "讀取 AWS 文件 [URL]"

## 執行流程
1. 搜尋文件 (search_documentation)
2. 讀取文件內容 (read_documentation)
3. 取得推薦文件 (recommend)

## 配置數據 (kiro-cli config)
```yaml
meta:
  owner: Ivy
  type: skill
  skill_id: aws-docs-search
  version: 1.0
  scope: global

trigger:
  keywords: ["AWS 文件", "AWS 最佳實踐", "AWS 教學"]

mcp_server:
  name: aws-documentation-mcp-server
  command: awslabs.aws-documentation-mcp-server

workflow:
  operations:
    - name: 搜尋文件
      tool: search_documentation
      params:
        search_phrase: "搜尋關鍵字"
        limit: 10
        
    - name: 讀取文件
      tool: read_documentation
      params:
        url: "文件 URL"
        max_length: 5000
        start_index: 0
        
    - name: 推薦文件
      tool: recommend
      params:
        url: "參考文件 URL"

features:
  - 全文搜尋 AWS 文件
  - 讀取完整文件內容
  - 推薦相關文件
  - 支援分頁讀取
```

## 使用範例
```
使用者: "查詢 S3 安全最佳實踐"
Kiro: search_documentation("S3 bucket security best practices", limit=5)
```

## 驗收標準
- 搜尋結果相關
- 文件內容完整
- 推薦文件有用

## 注意事項
- 需要網路連線
- 長文件需分段讀取
- 推薦功能基於 AWS 官方演算法
