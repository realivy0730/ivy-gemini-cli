---
name: redmine-ops
description: Manage Redmine issue lifecycle and time entry. Supports creating, searching, updating issues, and logging hours. Use when interacting with Redmine for project management or tracking.
---

# Redmine 綜合維運 Skill

## 架構描述
整合 Redmine 議題管理與工時記錄的核心技能，支援跨專案上下文切換。

## 觸發方式
- "建立 Redmine 議題"
- "更新進度到 #1234"
- "記錄 2 小時工時到 #5678"
- "搜尋關於 xxx 的議題"

## 執行流程

### 1. 議題管理 (Issue Management)
- 查詢現有議題：使用 `redmine-issue-management` 的 references 邏輯。
- 更新狀態：變更議題階段（MIS/開發/測試）。

### 2. 工時記錄 (Time Entry)
- 記錄規則：依據 `redmine-conventions.md` 規範。
- **⚡ 強制連動**：工時記錄後，必須觸發 `redmine-weekly-sheet` 同步。

## 驗收標準
- [ ] 議題內容正確更新。
- [ ] 工時成功寫入 Redmine。
- [ ] (選用) 週報同步成功。

## 參考資料
- 具體 API 指令見 `~/.kiro/skills/redmine-issue-updater/references/`
