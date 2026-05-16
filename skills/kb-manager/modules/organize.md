# 檔案整理模組

內建模組（原獨立 Skill 已合併）

## 功能
將檔案整理至抗幻覺目錄結構,確保 AI 能正確理解知識庫層級。

## 目錄結構

### 00_Meta/ (元資料)
- `INDEX.md`: 知識庫導航
- `changelog.md`: 變更記錄
- `glossary.md`: 術語表
- `README.md`: 專案說明

### 10_Core_Knowledge/ (核心知識)
經過驗證的絕對正確內容,AI 優先讀取區域。

### 20_Projects/ (進行中專案)
當前活躍專案的工作文件,完成後移至 Core Knowledge 或 Archives。

### 99_Archives/ (歷史歸檔)
已過時但需保留的資料,AI 讀取時應忽略。

## 分類決策

```
檔案評估
    ↓
是否為元資料? (INDEX, changelog, glossary)
    ├─ 是 → 00_Meta/
    └─ 否 → 是否為核心知識? (經驗證、可信賴)
        ├─ 是 → 10_Core_Knowledge/
        └─ 否 → 是否為進行中專案?
            ├─ 是 → 20_Projects/
            └─ 否 → 99_Archives/
```

## 執行流程

1. 掃描目標目錄
2. 分析檔案內容與 metadata
3. 決定目標目錄
4. 執行移動操作
5. 更新 INDEX.md
6. 記錄於 changelog.md
