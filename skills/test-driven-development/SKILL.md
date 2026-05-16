---
name: test-driven-development
description: "寫實作前先寫會失敗的測試，修 bug 前先用測試重現 bug。Use when implementing logic, fixing bugs, or changing behavior."
---

# Test-Driven Development (TDD)

## 架構描述
測試驅動開發方法論：Red → Green → Refactor 循環。

## 觸發方式
- 「寫測試」「TDD」「測試驅動」
- 實作任何邏輯、修任何 bug 時

## 執行流程

### Red-Green-Refactor 循環

1. **Red**：寫一個會失敗的測試（定義預期行為）
2. **Green**：寫最少的程式碼讓測試通過
3. **Refactor**：在測試保護下重構，保持綠燈

### Bug 修復 TDD

1. 先寫測試重現 bug（必須 Red）
2. 修復 bug（變 Green）
3. 確認沒有 regression

### 測試金字塔

| 層級 | 數量 | 速度 | 範圍 |
|------|:---:|:---:|------|
| 單元測試 | 多 | 快 | 單一函式/模組 |
| 整合測試 | 中 | 中 | 模組間互動 |
| E2E 測試 | 少 | 慢 | 完整使用者流程 |

### 測試品質原則
- 測試名稱描述行為（不是實作）
- 每個測試只驗證一件事
- 測試之間互相獨立
- 避免測試實作細節（測行為不測方法）

## 驗收標準
- [ ] 新功能有對應測試
- [ ] Bug 修復有重現測試
- [ ] 測試可獨立執行
- [ ] 無 flaky tests
