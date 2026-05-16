# 變更記錄模組

內建模組（原獨立 Skill 已合併）

## 版本號規則

語義化版本: `[Major.Minor.Patch]`

- `[3.0.0]`: 重大架構變更
- `[2.1.0]`: 次要功能更新
- `[2.1.5]`: 修正與小更新

## Changelog 結構

```markdown
---
tags: [changelog, history]
version: "1.0.0"
created: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
type: meta
owner: Ivy
---

# 知識庫變更記錄

**維護者**: Ivy  
**最後更新**: YYYY-MM-DD

---

## [版本號] - 日期 - 變更標題

### 🔧 類別標題

#### 子項目
- **變更內容**: 詳細說明
- **影響範圍**: 受影響的檔案或系統
- **執行者**: 負責人

#### 檔案清單
- `path/to/file1.md` (新增/修改/刪除)
- `path/to/file2.md`
```

## 類別標籤

- 🔧 **修改** (Modification): 配置變更、腳本更新、文件修正
- ✨ **新增** (Addition): 新功能、新文件、新配置
- 🗑️ **刪除** (Deletion): 移除過時內容、清理重複檔案
- 📦 **歸檔** (Archive): 移動至 99_Archives/
- 🔐 **安全** (Security): 安全性更新、權限變更
- 📊 **重構** (Refactor): 目錄結構調整、檔案重組

## 記錄時機

1. 新增/修改/刪除檔案
2. 目錄結構調整
3. 配置變更
4. 腳本部署
5. 文件重構

## 輸出位置

- 主 changelog: `00_Meta/changelog.md`
- 專案 changelog: `20_Projects/{project}/CHANGELOG.md`
- 歸檔 changelog: `99_Archives/{date}/README.md`
