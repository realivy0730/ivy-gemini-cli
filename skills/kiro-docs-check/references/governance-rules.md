# Kiro CLI 文件治理規則

## 觸發條件
當使用者要求**建立、修改、審查、除錯**以下 kiro-cli 功能時，必須先查詢最新規範：

| 功能區域 | 觸發關鍵字 | Context7 topic |
|----------|-----------|----------------|
| Agents | agent, 代理, 建立 agent | agents creating configuration-reference examples |
| Steering | steering, 規則, 導引 | steering scope foundational custom agents.md |
| Skills | skill, SKILL.md, frontmatter | skills frontmatter directory activation references |
| Hooks | hook, agentSpawn, preToolUse | hooks agentSpawn userPromptSubmit preToolUse postToolUse stop |
| Knowledge | knowledge, 知識庫, 索引 | knowledge management indexing search settings |
| MCP | mcp, server, 工具整合 | mcp configuration servers registry security |
| Settings | settings, 設定 | settings configuration feature toggles |

## 強制流程

### 1. 查詢最新規範（必要）
- 使用 `context7-docs` Skill 查詢，Library ID: `/websites/kiro_dev_cli`
- 使用上表對應的 topic 查詢
- 確認回傳的 Source URL 來自 `kiro.dev/docs/cli/`

### 2. 交叉驗證（可選，當懷疑資訊過時）
- 用 `web_fetch` 抓取對應的官網頁面
- 比對 Context7 回傳內容與官網是否一致

### 3. 執行操作
- 依據查詢到的最新規範執行
- 若規範與現有配置衝突，優先遵循最新規範
- 記錄規範版本差異（如有）

## 補充資源
- `/websites/kiro_dev_cli_code-intelligence` — Code Intelligence 專區
- `/websites/kiro_dev` — Kiro 整體文件
- 官方 Changelog: https://kiro.dev/changelog/

## 例外
- 純查詢類問題（如「steering 是什麼」）可直接回答
- 已在同一對話中查詢過的功能區域，不需重複查詢
