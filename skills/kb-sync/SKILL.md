---
name: kb-sync
description: 知識庫自動同步工具，任務執行後自動更新 INDEX.md、changelog.md 及相關文件。Use when completing tasks that modify files or knowledge base content.
version: "1.1.0"
created: "2026-03-03"
updated: "2026-03-11"
type: skill
owner: Ivy
---

# KB Sync - 知識庫自動同步

## 核心理念
**執行任何任務時，都必須包含「新增或更新當前知識庫文件架構與內容」的步驟**

## 同步流程
```
任務完成 → 檢查 .kiro/ 結構 → 偵測變更 → 更新 INDEX → 更新 Changelog
                                                    ↓
                                               更新交叉引用 → 同步 Knowledge Base
                                                    ↓
                                          Git 流程判定（有 Git → commit+push / 無 Git → 結束）
```

## 偵測變更
- 自動偵測：新增/修改/刪除/移動檔案
- 分類：Meta(docs/00_Meta) / Core(docs/10_Core_Knowledge) / Projects(docs/20_Projects) / Archives(docs/99_Archives)

## INDEX.md 更新
- 新增檔案條目、更新版本號（semantic versioning）、按目錄分組字母排序

## Changelog 更新
- 自動生成條目：✨新增 / 🔧修改 / 📊影響範圍
- 版本號：Major(架構重組) / Minor(新增檔案) / Patch(修正)

## 交叉引用更新
- Frontmatter related 欄位更新、斷裂連結檢查、相對路徑修正

## Knowledge Base 同步
- Kiro CLI 自動索引知識庫目錄下的 Markdown 檔案
- 手動觸發：聊天中使用 `/knowledge add`
- ❌ `kiro-cli knowledge` 不是 CLI 子命令
- ✅ `/knowledge` 是聊天內的斜線命令

## Git 推送（ivy-kiro-cli repo）
1. rsync `~/.kiro/` → `~/ivy-kiro-cli/`
2. Sanitize tokens（glpat-/ghp_/AKIA）、移除 Private Key
3. `git add -A && git commit -m "具體理由"` → `git push origin main`
- commit message 必須說明「為什麼改」，禁止 auto-sync 等無意義訊息

## 執行模式
- **自動模式**（預設）：任務完成後自動觸發
- **手動模式**：`請使用 kb-sync 同步知識庫`
- **驗證模式**：`請使用 kb-sync 驗證知識庫一致性`

## 同步檢查清單
- [x] INDEX.md 包含所有新檔案
- [x] changelog.md 記錄所有變更
- [x] 版本號正確遞增
- [x] Frontmatter 完整
- [x] Knowledge Base 已更新

## 與其他 Skills 整合
- task-executor：每階段完成後觸發部分同步
- kb-manager：同步前檢查 Frontmatter 完整性

詳細使用範例、配置參數、報告格式、故障排除參見 `references/examples-and-config.md`。
