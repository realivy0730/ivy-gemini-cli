## 使用範例

### 完整工作流
```
請使用 kb-manager 整理 ~/Documents/knowledge-base/ 目錄
```

### 獨立操作
```
# 僅分類檔案
請使用 kb-manager classify 處理當前目錄

# 僅檢測重複
請使用 kb-manager dedupe 檢查 10_Core_Knowledge/

# 僅標準化格式
請使用 kb-manager standardize 套用至所有 .md 檔案

# 僅生成 changelog
請使用 kb-manager changelog 記錄今天的變更
```

## 決策樹

```
收到知識庫維護請求
    ↓
是否為首次整理? 
    ├─ 是 → 執行完整工作流 (organize)
    └─ 否 → 判斷需求
        ├─ 新增檔案 → classify + standardize + changelog
        ├─ 發現重複 → dedupe + changelog
        ├─ 格式問題 → standardize + changelog
        └─ 僅記錄 → changelog
```

## 輸出規範

### 執行報告格式
```markdown
# Knowledge Base Manager 執行報告

**執行時間**: 2026-02-26 14:40
**目標目錄**: ~/Documents/knowledge-base/
**執行模式**: 完整工作流

## 檔案分類結果
- 移至 00_Meta/: 3 個檔案
- 移至 10_Core_Knowledge/: 15 個檔案
- 移至 20_Projects/: 8 個檔案
- 移至 99_Archives/: 5 個檔案

## 重複檢測結果
- 發現 4 組重複檔案
- 合併 3 組,保留 Master Copy
- 刪除 7 個重複檔案

## 標準化結果
- 補齊 Frontmatter: 12 個檔案
- 修正標題結構: 5 個檔案
- 統一程式碼區塊: 8 個檔案

## Changelog 更新
- 新增版本: [2.1.5] - 2026-02-26
- 記錄於: 00_Meta/changelog.md
```

## 配置參數

```yaml
# ~/.kiro/skills/kb-manager/config.yaml
meta:
  owner: Ivy
  type: knowledge-base-manager

config:
  # 目錄結構
  directories:
    meta: "00_Meta"
    core: "10_Core_Knowledge"
    projects: "20_Projects"
    archives: "99_Archives"
  
  # 重複檢測閾值
  similarity_threshold: 0.8
  
  # Frontmatter 必填欄位
  required_frontmatter:
    - tags
    - created
    - updated
    - type
    - owner
  
  # Changelog 設定
  changelog_path: "00_Meta/changelog.md"
  version_format: "semantic"  # semantic | date
```

## 模組引用

詳細規範請參考:
- [檔案整理模組](modules/organize.md)
- [重複檢測模組](modules/dedupe.md)
- [標準化模組](modules/standardize.md)
- [變更記錄模組](modules/changelog.md)

## 最佳實踐

1. **定期執行**: 每週執行一次完整工作流
2. **即時記錄**: 每次變更後立即更新 changelog
3. **版本控制**: 配合 Git 使用,commit message 對應 changelog
4. **備份優先**: 執行前先備份重要檔案
5. **漸進式整理**: 大型知識庫分批處理,避免一次性變更過多

## 故障排除

### 檔案分類錯誤
**症狀**: 檔案被分類到錯誤目錄
**解決**: 手動移動後更新 changelog,調整分類規則

### 重複檢測誤判
**症狀**: 非重複檔案被標記為重複
**解決**: 降低 similarity_threshold,手動審查結果

### Frontmatter 遺失
**症狀**: 標準化後部分欄位未補齊
**解決**: 檢查 required_frontmatter 設定,手動補齊

## 版本歷史

### [1.0.0] - 2026-02-26
- ✨ 初始版本
- 整合 4 個獨立 skills
- 提供完整工作流與獨立命令
