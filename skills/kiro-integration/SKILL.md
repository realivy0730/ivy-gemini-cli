---
name: kiro-integration
description: "Kiro CLI 與 Gemini CLI 整合管理。用於配置同步、路徑感知與自動化上下文注入。 Use when integrating Kiro CLI with other tools."
---

# Kiro-Gemini 整合技能 (Kiro Integration)

## 架構描述
此技能定義了 `gemini cli` 如何作為 `kiro cli` 的智慧引擎運作，確保全域配置繼承與專案感知的自動化。

## 核心工具 (Scripts)
- `kiro-gemini`：整合啟動包裝器，自動注入 `~/.kiro/steering/` 規範。
- `context-scanner.sh`：專案掃描器，提取 `docs/` 與 `CHANGELOG.md` 上下文。

## 雙工具協作工作流 (Standard Workflow)

### 1. 任務初始化
- 當啟動任務時，執行 `context-scanner.sh` 確保當前認知與 `docs/projects/` 一致。
- 使用 `sequential-thinking` 拆解任務，並與 `CHANGELOG.md` 的 [Unreleased] 段落對齊。

### 2. 規劃與審查
- 使用 **左腦 (Analysis)** 配合 `kiro-gemini` 讀取全域 SRE 規範。
- 所有計畫產出必須符合 `planning-agent-guide.md`。

### 3. 執行與同步
- 使用 **右腦 (Execution)** 進行寫入。
- 任務完成後，強制執行 `kb-sync-workflow.md`，同步更新全域與局部知識庫。

## 驗收檢查清單 (Setup Checklist)
- [ ] 執行 `kiro-gemini --version` 驗證配置路徑。
- [ ] 執行 `context-scanner.sh` 驗證專案背景讀取。
- [ ] 確認 `docs/core/operational-standards.md` 已被正確注入 System Instruction。

## 注意事項
- 嚴禁在未執行 `context-scanner.sh` 的情況下開始複雜專案任務。
- 所有異動必須反映在專案的 `CHANGELOG.md` 中。
