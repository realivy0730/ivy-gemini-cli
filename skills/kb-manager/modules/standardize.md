# 標準化模組

內建模組（原獨立 Skill 已合併）

## YAML Frontmatter 規範

所有 Markdown 文件必須包含:

```yaml
---
tags: [category1, category2]
created: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
type: documentation|configuration|guide|reference
owner: Ivy
---
```

### 必填欄位
- `tags`: 分類標籤陣列
- `created`: 建立日期 (ISO 8601)
- `updated`: 最後更新日期
- `type`: 文件類型
- `owner`: 維護者

### 選填欄位
- `version`: 版本號
- `status`: draft|review|published
- `related`: 相關文件連結

## 檔名規範

- 使用 kebab-case: `my-document.md`
- 禁止空格與特殊字元
- 日期格式: `YYYYMMDD`

## 標題結構

```markdown
# 主標題 (H1) - 每個文件只有一個

## 次標題 (H2)

### 三級標題 (H3)
```

## 正體中文慣例

- 技術術語保留英文: API, CLI, SSH
- 中英文間加空格: `使用 Markdown 格式`
- 數字與單位間加空格: `100 GB`
- 標點符號使用全形: `，。！？`

## 程式碼區塊

````markdown
```bash
# 註解使用正體中文
command --option value
```
````

語言標記: `bash`, `python`, `yaml`, `json`, `shell`

## 檢查項目

1. Frontmatter 完整性
2. 標題層級正確性
3. 程式碼區塊語言標記
4. 中英文間距
5. 連結有效性
