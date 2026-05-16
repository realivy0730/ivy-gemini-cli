---
name: kiro
description: "Kiro CLI 深度整合技能。用於自動掃描專案規範 (.kiro/steering)、盤點文件結構 (docs/) 並動態加載領域特定技能 (.kiro/skills)。在進入新專案或需要進行專案審計時啟動。 Use when performing project audits or initializing context."
---

# Kiro 整合引擎 (Zero-Touch)

## 核心機制
本技能透過 `agentSpawn` Hook 自動觸發，確保 Gemini CLI 在啟動時具備正確的專案上下文。

## 執行邏輯
1. **環境探測**：檢查當前目錄是否存在 `.kiro/` 或 `docs/`。
2. **自動掃描**：執行 `/Users/linyuanchun/.gemini/scripts/context-scanner.sh`。
3. **動態對齊**：
    - 將 `CHANGELOG.md` 中的 [Unreleased] 任務作為當前最高優先級。
    - 讀取 `./.kiro/steering/*.md` 中的局部規範覆蓋全域行為。

## 使用方式
- **自動觸發**：直接執行 `gemini` 啟動會話。
- **手動觸發**：在對話中輸入「執行 Kiro 專案掃描」。

## 驗收標準
- [ ] 啟動時已打印專案背景資訊。
- [ ] AI 已知曉當前專案的技術棧。
- [ ] `CHANGELOG` 中的待辦事項已納入上下文。
