---
name: terraform-helper
description: "透過 terraform-mcp-server 查詢 Terraform Provider 版本、Module 資訊與最佳實踐。用於查閱 Terraform 文件。 Use when managing infrastructure with Terraform."
---

# Terraform Helper

## 架構描述
使用 terraform-mcp-server 查詢 Terraform Provider 版本、模組資訊、最佳實踐。

## 觸發方式
- "查詢 [Provider] 最新版本"
- "Terraform [模組] 文件"
- "[Provider] 的使用範例"

## 執行流程
1. 查詢 Provider 版本 (get_latest_provider_version)
2. 查詢模組版本 (get_latest_module_version)
3. 搜尋模組 (search_modules)
4. 取得詳細文件 (get_module_details, get_provider_details)

## 配置數據 (kiro-cli config)
```yaml
meta:
  owner: Ivy
  type: skill
  skill_id: terraform-helper
  version: 1.0
  scope: global

trigger:
  keywords: ["Terraform", "Provider 版本", "模組查詢"]

mcp_server:
  name: terraform-mcp-server
  command: /Users/linyuanchun/go/bin/terraform-mcp-server stdio

workflow:
  operations:
    - name: 查詢 Provider 版本
      tool: get_latest_provider_version
      params:
        namespace: "hashicorp"
        name: "aws"
        
    - name: 查詢模組版本
      tool: get_latest_module_version
      params:
        module_publisher: "terraform-aws-modules"
        module_name: "vpc"
        module_provider: "aws"
        
    - name: 搜尋模組
      tool: search_modules
      params:
        module_query: "搜尋關鍵字"
        
    - name: 取得 Provider 文件
      tool: get_provider_details
      params:
        provider_doc_id: "文件 ID"

features:
  - 查詢最新版本
  - 搜尋模組
  - 取得詳細文件
  - 支援多種 Provider
```

## 使用範例
```
使用者: "查詢 AWS Provider 最新版本"
Kiro: get_latest_provider_version("hashicorp", "aws")
結果: 6.35.1
```

## 驗收標準
- 成功查詢版本
- 文件內容完整
- 範例可用

## 注意事項
- 需要網路連線
- 僅支援公開的 Terraform Registry
- 某些模組可能需要驗證
