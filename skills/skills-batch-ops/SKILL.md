---
name: skills-batch-ops
description: "批次稽核、驗證與修正全域及專案 Skills 目錄的 SKILL.md frontmatter。用於檢查 Skills 合規性或批量修正 frontmatter。"
---

# Skills Batch Operations（Skills 批次管理）

## 架構描述
批次盤點、驗證、修復所有 SKILL.md 的 frontmatter 合規性。涵蓋全域 `~/.kiro/skills/` 與專案 `.kiro/skills/` 兩個範圍，確保所有 Skills 符合 `skills-standards.md` 規範。

## 觸發方式
- 「盤點所有 Skills」
- 「驗證 Skills frontmatter」
- 「批次修復 Skills」
- 「audit skills compliance」

## 執行流程

### Step 1：盤點掃描
```shell
# 全域 Skills
for f in ~/.kiro/skills/*/SKILL.md; do
  dir=$(basename "$(dirname "$f")")
  has_fm=$(head -1 "$f" | grep -c "^---")
  echo "$dir: frontmatter=$has_fm"
done

# 專案 Skills（從 BASE 路徑遞迴搜尋）
BASE="/Users/linyuanchun/Library/Mobile Documents/com~apple~CloudDocs/Work-iCloud/work/AmazonQ"
find "$BASE" -path "*/.kiro/skills/*/SKILL.md" -exec sh -c '
  dir=$(basename "$(dirname "$1")")
  has_fm=$(head -1 "$1" | grep -c "^---")
  echo "$dir: frontmatter=$has_fm [$1]"
' _ {} \;
```

### Step 2：合規驗證
逐檔檢查以下項目：
1. **frontmatter 存在**：第一行為 `---`
2. **name 一致性**：`name:` 值與目錄名稱相同
3. **description 格式**：以英文動詞開頭，包含 "Use when"
4. **name 長度**：≤ 64 字元
5. **description 長度**：≤ 1024 字元

### Step 3：產出合規報告
```markdown
# Skills 合規報告
**掃描時間**: YYYY-MM-DD HH:MM
**範圍**: 全域 N 個 + 專案 M 個 = 共 X 個

## 結果
- ✅ 合規: N 個
- ❌ 缺失 frontmatter: N 個
- ⚠️ name 不一致: N 個
- ⚠️ description 格式不符: N 個
```

### Step 4：批次修復（需確認）
對缺失 frontmatter 的檔案：
1. 從 `## 架構描述` 段落提取內容
2. 改寫為英文 action-oriented description
3. 在檔案開頭插入 frontmatter 區塊
4. 驗證插入結果

## 配置數據 (kiro-cli config)
```yaml
meta:
  owner: Ivy
  type: skill
  skill_id: skills-batch-ops
  version: "1.0.0"
  scope: global

config:
  scan_paths:
    global: "~/.kiro/skills/*/SKILL.md"
    project: "${BASE}/*/.kiro/skills/*/SKILL.md"
  validation_rules:
    frontmatter_required: true
    name_match_directory: true
    description_starts_with_verb: true
    description_contains_use_when: true
    name_max_length: 64
    description_max_length: 1024
  reference: "~/.kiro/steering/skills-standards.md"
```

## 反模式偵測（PluginEval 借鑑）

稽核時自動偵測以下 6 種反模式：

| 反模式 | 偵測條件 | 嚴重度 |
|--------|---------|:---:|
| EMPTY_DESCRIPTION | description 為空或 < 20 字元 | 🔴 |
| MISSING_TRIGGER | description 不含 "Use when" 或 "用於" | 🟡 |
| BLOATED_SKILL | SKILL.md > 200 行（應拆分 references/） | 🟡 |
| NAME_MISMATCH | frontmatter name ≠ 目錄名稱 | 🔴 |
| OVER_CONSTRAINED | 限制條件 > 任務描述（行數比） | 🟡 |
| ORPHAN_REFERENCE | 引用的 references/ 檔案不存在 | 🔴 |

## 品質評分

每個 skill 產出品質分數（0-100）：

| 維度 | 權重 | 評分標準 |
|------|:---:|---------|
| Frontmatter 合規 | 30% | name 一致 + description 含 Use when + ≤ 1024 字元 |
| 觸發精準度 | 20% | description 含具體服務名稱 + 動詞開頭 |
| Token 效率 | 20% | SKILL.md ≤ 150 行，大型內容在 references/ |
| 結構完整性 | 15% | 含架構描述 + 觸發方式 + 執行流程 + 驗收標準 |
| 反模式 | 15% | 0 個反模式 = 滿分，每個 🔴 扣 10 分，🟡 扣 5 分 |

**評級**：≥ 90 Platinum | ≥ 80 Gold | ≥ 70 Silver | < 70 需修正

## 觸發測試方法論（Anthropic 指南借鑑）

稽核時可選執行觸發精準度測試：

### 測試設計
每個 skill 設計 3 類測試問句：
1. **正向觸發**（3-5 句）：應該觸發此 skill 的自然語言
2. **改寫觸發**（2-3 句）：同義但不同措辭的觸發句
3. **干擾句**（2-3 句）：不應觸發此 skill 的相似問句

### 評分標準
- 正向觸發命中率 ≥ 80% = PASS
- 干擾句誤觸率 ≤ 10% = PASS
- 兩者都通過 = 觸發精準度合格

### 效能基線
成熟的 skill 應能：
- 對話來回次數從 15 次壓縮到 2 次
- Token 消耗減少 50%
- API 失敗率歸零

## 驗收標準
- [ ] 掃描涵蓋全域 + 所有專案 Skills
- [ ] 合規報告包含統計數據與逐檔結果
- [ ] 批次修復後重新驗證全數通過
- [ ] 修復前有備份機制

## 注意事項
- 批次修復前必須確認，不可自動執行
- description 改寫需人工審核品質（自動提取可能不精確）
- 參考 `~/.kiro/steering/skills-standards.md` 作為驗證標準
- 本次 P0 實戰數據：64 個修復，0 個失敗
