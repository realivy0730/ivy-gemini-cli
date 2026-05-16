# 重複檢測模組

內建模組（原獨立 Skill 已合併）

## 檢測策略

### 1. 檔名相似度
- `document.md` vs `document-backup.md`
- `config.yaml` vs `config-old.yaml`
- 包含 `backup`, `old`, `copy`, `v2` 等關鍵字

### 2. 內容相似度
- 標題重複
- 段落重複 (>80% 相似)
- 程式碼區塊重複
- 表格資料重複

### 3. 時間戳記優先級
保留最新、最完整、最規範的版本。

## Master Copy 選擇標準

1. 最新修改日期
2. 內容最完整
3. 符合 Markdown 標準
4. 包含完整 YAML Frontmatter

## 處理策略

### 高度重複 (>90%)
**動作**: 直接刪除較舊版本
**記錄**: 簡單註記於 changelog

### 中度重複 (50-90%)
**動作**: 合併獨特內容後刪除
**記錄**: 詳細記錄合併內容

### 低度重複 (<50%)
**動作**: 保留兩者,建立交叉引用
**記錄**: 在 Frontmatter 中標記 related

## 輸出格式

```markdown
## 重複檔案群組 1
- Master: `10_Core_Knowledge/config.md` (2026-02-26)
- Duplicate: `config-backup.md` (2026-02-20)
- Similarity: 95%
- Action: 刪除 config-backup.md

## 重複檔案群組 2
- Master: `report-20260226.md` (2026-02-26)
- Duplicate: `report-20260226-v2.md` (2026-02-26)
- Similarity: 85%
- Action: 合併獨特段落後刪除 v2
```
