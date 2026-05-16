---
name: sequential-thinking-helper
description: "使用 Sequential Thinking MCP 進行深度問題分析與多階段推理，產出結構化的思考鏈。Use when analyzing complex problems, evaluating trade-offs, or reasoning through multi-step decisions."
---

# Sequential Thinking Helper

## 架構描述
使用 sequential-thinking MCP 進行複雜問題的階段性思考，適用於需要逐步推理、多步驟分析的任務。

## 觸發方式
- "使用循序思考分析 [問題]"
- "逐步思考 [問題]"
- "階段性分析 [問題]"

## 執行流程
1. 定義問題與預估思考步驟數
2. 逐步執行思考，每步驟記錄推理過程
3. 可動態調整總步驟數
4. 支援分支思考與修正

## 配置數據 (kiro-cli config)
```yaml
meta:
  owner: Ivy
  type: skill
  skill_id: sequential-thinking-helper
  version: 1.0
  scope: global

trigger:
  keywords: ["循序思考", "逐步思考", "階段性分析", "思考過程"]

mcp_server:
  name: sequential-thinking
  command: mcp-server-sequential-thinking

workflow:
  steps:
    - name: 初始化思考
      tool: sequentialthinking
      params:
        thought: "定義問題與分析方向"
        thoughtNumber: 1
        totalThoughts: "預估值"
        nextThoughtNeeded: true
        
    - name: 逐步推理
      tool: sequentialthinking
      params:
        thought: "當前思考內容"
        thoughtNumber: "遞增"
        totalThoughts: "可動態調整"
        nextThoughtNeeded: "是否需要下一步"
        
    - name: 結論
      tool: sequentialthinking
      params:
        nextThoughtNeeded: false

features:
  - 動態調整思考步驟數
  - 支援分支思考 (branchFromThought, branchId)
  - 支援修正前述思考 (isRevision, revisesThought)
  - 自動記錄思考歷程
```

## 使用範例
```
使用者: "逐步思考如何優化資料庫查詢效能"
Kiro: 使用 sequential-thinking 進行 5-7 步驟的分析
```

## 驗收標準
- 思考過程清晰可追溯
- 每步驟有明確推理邏輯
- 最終產出可行方案

## 注意事項
- 適用於複雜問題，簡單問題無需使用
- 思考步驟建議 3-10 步
- 可隨時調整方向與步驟數
