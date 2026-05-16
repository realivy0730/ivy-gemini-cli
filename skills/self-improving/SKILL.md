---
name: self-improving
description: "記錄執行錯誤與使用者糾正至 LEARNINGS.md，偵測重複模式，將高頻錯誤提升為永久規則。用於工具失敗或使用者糾正行為時。 Use when enhancing CLI skills or performance."
---

# Self-Improving（自我改進機制）

## 架構描述
實作 `global-rules.md` §6 定義的自我改進機制。當工具執行失敗或使用者糾正行為時，自動記錄錯誤、分析重複模式、並將高頻錯誤提升為永久規則，避免重複犯錯。

## 觸發方式
### 自動觸發
- 工具執行失敗（exit_code != 0）
- 使用者說「不對」、「錯了」、「應該是」
- 使用者明確糾正行為

### 手動觸發
- 「檢查學習記錄」
- 「分析錯誤模式」
- 「review learnings」

## 執行流程

### Phase 1：錯誤記錄
1. 偵測觸發條件（工具失敗 / 使用者糾正）
2. 確認當前工作目錄，建立或定位 `.learnings/LEARNINGS.md`
3. 追加記錄，格式如下：

```markdown
## [ERROR|CORRECTION] YYYY-MM-DD HH:MM
- **任務**：當前執行的任務描述
- **錯誤**：實際發生的錯誤行為
- **修正**：正確的做法
- **原因**：根本原因分析
- **狀態**：[OPEN]
```

### Phase 2：Pattern Detection
觸發條件：累積 10 筆記錄 或 手動觸發

1. 讀取 `.learnings/LEARNINGS.md` 全部記錄
2. 使用 `sequential-thinking` 分析重複模式
3. 分類統計：依錯誤類型、涉及工具、涉及服務分群
4. 同類錯誤 ≥ 3 次 → 標記為候選永久規則

### Phase 3：規則提升
1. 將候選規則呈報使用者確認
2. 確認後，依據規則性質：
   - 更新對應的 steering 檔案（conventions.md / global-rules.md）
   - 或建立新的 Skill
3. 將已提升的記錄標記為 `[PROMOTED]`
4. 未提升的標記為 `[RESOLVED]`

## 配置數據 (kiro-cli config)
```yaml
meta:
  owner: Ivy
  type: skill
  skill_id: self-improving
  version: "1.0.0"
  scope: global

trigger:
  auto:
    - exit_code_nonzero
    - user_correction_keywords: ["不對", "錯了", "應該是", "wrong", "incorrect"]
  manual:
    - "檢查學習記錄"
    - "分析錯誤模式"

config:
  learnings_path: ".learnings/LEARNINGS.md"
  pattern_detection_threshold: 10
  promotion_threshold: 3
  record_format: "## [{type}] {date} {time}"
```

## 驗收標準
- [ ] 觸發時自動建立 `.learnings/` 目錄與 `LEARNINGS.md`
- [ ] 記錄格式符合 global-rules.md §6 範本
- [ ] Pattern Detection 能正確分群統計
- [ ] 同類錯誤 ≥ 3 次時產出提升建議
- [ ] 已處理記錄狀態正確更新

## 注意事項
- `.learnings/` 目錄應加入 `.gitignore`（含個人錯誤記錄，不適合版控）
- Pattern Detection 為建議性質，規則提升需使用者確認
- 記錄內容避免包含敏感資訊（密碼、金鑰）
- 此 Skill 與 `troubleshoot` Skill 互補：troubleshoot 處理當下問題，self-improving 記錄長期模式
