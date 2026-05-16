---
name: context7-docs
description: "透過 context7-mcp 查詢程式庫、框架與 SDK 文件，取得 API 用法、程式碼範例與最佳實踐。用於查閱程式庫文件。 Use when generating Context7 scripts or infrastructure as code."
---

# Context7 Documentation Search

## 架構描述
使用 context7-mcp 查詢程式庫、框架、SDK 的官方文件，取得 API 用法、範例程式碼、最佳實踐。

## 觸發方式
- "查詢 [程式庫] 文件"
- "如何使用 [API]"
- "[框架] 的範例程式碼"

## 執行流程
1. 解析程式庫名稱 (resolvelibraryid)
2. 取得文件內容 (getlibrarydocs)
3. 提取相關資訊

## 配置數據 (kiro-cli config)
```yaml
meta:
  owner: Ivy
  type: skill
  skill_id: context7-docs
  version: 1.0
  scope: global

trigger:
  keywords: ["查詢文件", "API 用法", "範例程式碼", "如何使用"]

mcp_server:
  name: context7-mcp
  command: context7-mcp --transport stdio

workflow:
  steps:
    - name: 解析程式庫 ID
      tool: resolvelibraryid
      params:
        libraryName: "程式庫名稱"
        
    - name: 取得文件
      tool: getlibrarydocs
      params:
        context7CompatibleLibraryID: "/org/project"
        topic: "主題（選填）"
        tokens: 5000

features:
  - 支援數千個熱門程式庫
  - 提供程式碼範例
  - 包含 Trust Score 評分
  - 可指定版本
```

## 使用範例
```
使用者: "查詢 Playwright 如何截圖"
Kiro: 
1. resolvelibraryid("playwright")
2. getlibrarydocs("/microsoft/playwright", topic="screenshot")
```

## 驗收標準
- 成功找到程式庫
- 文件內容相關
- 包含可用範例

## 注意事項
- 優先選擇 Trust Score 高的程式庫
- 可指定版本（如 /org/project/v1.0.0）
- tokens 參數控制文件長度
