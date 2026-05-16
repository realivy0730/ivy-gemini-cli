---
name: kiro-docs-check
description: Query and verify Kiro CLI documentation from Context7. Use when creating or reviewing agents, steering, skills, hooks, MCP, or settings.
---

# Kiro CLI 文件查詢與驗證

## 架構描述
在操作 kiro-cli 功能（agents, steering, skills, hooks, knowledge, mcp, settings）前，
自動查詢 Context7 取得最新規範，必要時用 web_fetch 交叉驗證官網內容。

## 觸發方式
- "查詢 kiro-cli [功能] 最新規範"
- "檢查 [功能] 文件是否有更新"
- 由 steering 規則 `kiro-cli-docs-governance.md` 自動引導觸發

## 執行流程

### Step 1：識別功能區域
根據使用者需求，對應到以下區域與 topic：

| 功能區域 | Context7 topic 關鍵字 | 官網 URL |
|----------|----------------------|----------|
| Agents | agents creating configuration-reference examples | /docs/cli/custom-agents/ |
| Steering | steering scope foundational custom agents.md | /docs/cli/steering/ |
| Skills | skills frontmatter directory activation references | /docs/cli/skills/ |
| Hooks | hooks agentSpawn userPromptSubmit preToolUse postToolUse stop | /docs/cli/hooks/ |
| Knowledge | knowledge management indexing search settings | /docs/cli/experimental/knowledge-management/ |
| MCP | mcp configuration servers registry security | /docs/cli/mcp/ |
| Settings | settings configuration feature toggles | /docs/cli/reference/settings/ |

### Step 2：查詢 Context7
```
工具: getlibrarydocs
參數:
  context7CompatibleLibraryID: /websites/kiro_dev_cli
  topic: [對應的 topic 關鍵字]
  tokens: 5000（一般）/ 8000（需要完整規範）
```
- 確認回傳的 Source URL 來自 `kiro.dev/docs/cli/`
- 記錄關鍵規範要點

### Step 3：交叉驗證（可選）
當以下情況時執行：
- Context7 回傳內容看起來不完整
- 使用者明確要求確認最新版本
- 涉及重大配置變更

```
工具: web_fetch
參數:
  url: https://kiro.dev/docs/cli/[對應路徑]/
  mode: full
```
- 比對 Context7 與官網內容
- 檢查 `Page updated` 日期
- 若有差異，以官網為準

### Step 4：輸出規範摘要
- 列出該功能的最新規範要點
- 標註與現有配置的差異（如有）
- 提供建議的修改方向

## 配置數據 (kiro-cli config)
```yaml
meta:
  owner: Ivy
  type: skill
  skill_id: kiro-docs-check
  version: 1.0
  scope: global

context7:
  library_id: /websites/kiro_dev_cli
  trust_score: 10
  snippets: 872
  supplementary:
    - /websites/kiro_dev_cli_code-intelligence
    - /websites/kiro_dev

official_site:
  base_url: https://kiro.dev/docs/cli/
  changelog: https://kiro.dev/changelog/
```

## 驗收標準
- Context7 查詢成功回傳相關 snippets
- Source URL 來自 kiro.dev/docs/cli/
- 規範摘要包含可操作的具體指引
- 交叉驗證時，官網頁面可正常抓取

## 注意事項
- Context7 非即時同步，可能有數小時至數天延遲
- 同一對話中已查詢過的功能區域不需重複查詢
- 純概念性問題（如「steering 是什麼」）不需觸發此流程

強制查詢流程與觸發條件參見 `references/governance-rules.md`。
