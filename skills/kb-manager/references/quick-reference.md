# Knowledge Base Manager - 快速參考

## 命令速查

### 完整工作流
```
請使用 kb-manager 整理 [目標目錄]
```

### 獨立命令
```
kb-manager classify      # 檔案分類
kb-manager dedupe        # 重複檢測
kb-manager standardize   # 標準化
kb-manager changelog     # 變更記錄
```

## 目錄結構

```
00_Meta/              # 元資料
├── INDEX.md
├── changelog.md
├── glossary.md
└── README.md

10_Core_Knowledge/    # 核心知識
├── infrastructure/
├── security/
└── monitoring/

20_Projects/          # 進行中專案
└── [project-name]/

99_Archives/          # 歷史歸檔
└── YYYY-MM/
```

## Frontmatter 模板

```yaml
---
tags: [category1, category2]
created: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
type: documentation
owner: Ivy
---
```

## 類別標籤

- 🔧 修改
- ✨ 新增
- 🗑️ 刪除
- 📦 歸檔
- 🔐 安全
- 📊 重構

## 相關 Skills

- `modules/organize.md`: 檔案整理
- `modules/dedupe.md`: 重複檢測
- `modules/standardize.md`: Markdown 標準
- `modules/changelog.md`: 變更記錄
