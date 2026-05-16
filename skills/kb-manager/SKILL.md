---
name: kb-manager
description: 整理與標準化知識庫檔案，執行去重檢測、Markdown 格式統一、目錄結構重組。Use when reorganizing docs, deduplicating content, or standardizing file formats.
version: "1.0.0"
created: "2026-02-26"
updated: "2026-02-26"
type: skill
owner: Ivy
---

# Knowledge Base Manager

統一的知識庫管理工具，內建 4 個子模組完成完整的知識庫維護工作流。

## 核心功能

### 1. 完整工作流 (organize)
```
檔案分類 → 重複檢測 → 標準化 → 變更記錄
```
使用時機：定期維護、大規模整理、新專案初始化

### 2. 獨立命令
- **classify**：依內容自動分類至 meta/core/projects/archives
- **dedupe**：MD5 + 語意比對，找出完全重複與高度相似文件
- **standardize**：統一 frontmatter、標題層級、程式碼區塊標記
- **changelog**：由 `kb-sync` skill 負責（避免重複）

## 決策樹
```
需要整理知識庫？
├── 全面整理 → organize（完整工作流）
├── 只需分類 → classify
├── 只需去重 → dedupe
├── 只需格式化 → standardize
└── 只需記錄變更 → changelog
```

## 驗收標準
- [ ] 無重複檔案（MD5 + 語意）
- [ ] 所有 .md 含標準 frontmatter
- [ ] 標題層級正確（H1 唯一）
- [ ] changelog 已更新

詳細使用範例、輸出規範、配置參數、故障排除參見 `references/examples-and-config.md`。

## 最佳實踐
- 大規模整理前先備份
- 先 dedupe 再 standardize（避免格式化重複檔案）
- 定期執行（建議每月一次）
