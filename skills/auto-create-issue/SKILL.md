---
name: auto-create-issue
description: "Automatically create GitHub/GitLab Issues with Redmine sync using standardized Traditional Chinese templates. Use when discovering bugs, tech debt, or architecture changes that require formal tracking."
version: "1.0.0"
---

# Auto Create Issue

自動判斷 GitLab/GitHub 並透過 CLI 工具建立 Issue，且自動同步 Redmine。

## 觸發條件
- AI 偵測到 Bug、技術債或架構問題
- 使用者明確要求建立 Issue
- 關鍵字：`issue create`

## 執行流程
1. 偵測 `.git/config` remote URL 判斷平台（GitHub/GitLab）
2. 使用正體中文模板建立 Issue（標題格式：`[分類] 問題簡述`）
3. 若 `REDMINE_API_KEY` 存在，同步建立 Redmine 議題並雙向連結

## 依賴工具
- `gh`（GitHub CLI）
- `glab`（GitLab CLI）
- `curl`（Redmine API）

## 參考規範
- `~/.kiro/steering/issue-driven-development.md`（IDD 母法）
- `~/.kiro/steering/foundational/issue-driven-governance.md`（Trinity v1.1）
