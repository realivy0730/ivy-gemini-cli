---
name: code-review
description: "自動化程式碼審查，檢查 Clean Code 原則、安全性、效能與最佳實踐。用於審查程式碼或產出品質報告。 Use when performing security or performance code reviews."
---

# Code Review

## 架構描述
自動化程式碼審查，檢查 Clean Code 原則、安全性、效能、最佳實踐，產生改善建議。

## 觸發方式
- "審查程式碼 [檔案/目錄]"
- "code review [path]"

## 嚴格執行規範
- 涉及程式碼範例時，**強制使用 context7** 查詢最佳實踐
- 自動建立 TODO 清單，每步驟強制驗收
- 遇異常立即暫停，執行 RCA
- 僅讀取程式碼，不修改檔案

## 執行流程
1. **讀取程式碼** — 確認檔案存在、內容非空
2. **查詢最佳實踐**（context7 強制）— 語言/框架最佳實踐
3. **逐項檢查**（sequential-thinking）— 問題分級 Critical/Major/Minor
4. **生成報告** — 總體評分、問題清單、改善建議含範例

### 檢查項目
- **Critical（阻斷）**：硬編碼密鑰、SQL Injection、XSS
- **Major（重要）**：缺少錯誤處理、N+1 查詢、資源未釋放
- **Minor（建議）**：命名不清晰、註解不足、魔術數字

## Code Simplification（合併審查）

Review 時同時檢查是否可簡化，在不改變行為的前提下重構：

- **「清楚」優於「聰明」** — 讀得懂比寫得巧重要
- 死碼、重複邏輯、過深巢狀 → 標記為簡化候選
- 簡化後必須通過原有測試（行為不變）

## 驗收標準
- [ ] context7 成功查詢最佳實踐
- [ ] 所有檢查項目已執行、問題已分級
- [ ] 報告含具體改善建議與範例程式碼

詳細 workflow 配置參見 `references/workflow-config.md`。

## 注意事項
- **強制使用 context7** 確認最新最佳實踐
- 區分「必須修正」與「建議改善」
- 異常時立即暫停並執行 RCA
