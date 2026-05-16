---
name: gitlab-api
description: Manage GitLab groups, projects, members, issues, and merge requests via REST API. Use when operating GitLab resources or querying repository information.
---

# GitLab API 管理 Skill（全域）

## 架構描述

全域 Skill，支援在任何工作目錄下管理 GitLab Groups、Projects、Members、Issues、Merge Requests 等資源。

### Token 管理架構
- Token 統一存放於 `~/.zshrc`（`export GITLAB_PERSONAL_ACCESS_TOKEN`）
- AmazonQ.json 用 `$GITLAB_PERSONAL_ACCESS_TOKEN` 引用，不存實際值
- Token rotate 時只需更新 `~/.zshrc`，重啟 kiro-cli 即生效

### 連線方式

| 用途 | 方式 | 說明 |
|------|------|------|
| API 操作 | MCP 工具（主要） | @zereight/mcp-gitlab，~140 個工具 |
| API 備用 | curl + $TOKEN | MCP 不支援的極少數操作 |
| Git push/pull | SSH（git@gitlab.com） | 本機 id_rsa key 已註冊 |

## 觸發方式
- "建立 GitLab 專案 [name]"
- "查詢 GitLab [group/project] 成員"
- "建立 Merge Request"

## 執行流程
1. 優先使用 MCP 工具（@zereight/mcp-gitlab）
2. MCP 不支援時 fallback 到 curl REST API
3. Git 操作使用 SSH

## 驗收標準
- [ ] API 操作成功（HTTP 2xx）
- [ ] 資源狀態正確
- [ ] 變更已記錄

詳細配置、MCP 工具清單、curl 範例、版本歷史參見 `references/config-and-api.md`。

## 注意事項
- Token 禁止硬編碼，必須用環境變數引用
- API rate limit：600 requests/min（authenticated）
- 相關 Skills：gitlab-repo-ops（SSH 操作）、code-review（MR 審查）
