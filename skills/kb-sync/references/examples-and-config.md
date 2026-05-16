## 使用範例

### 範例 1: 任務完成後自動同步
```
# task-executor 執行完成
→ kb-sync 自動觸發
→ 更新 INDEX.md
→ 更新 changelog.md
→ 同步 Knowledge Base
```

### 範例 2: 手動同步
```
請使用 kb-sync 同步當前目錄的知識庫
```

**執行流程**:
1. 掃描目錄變更
2. 更新 INDEX.md
3. 生成 changelog 條目
4. 更新交叉引用
5. 同步至 kiro-cli knowledge

### 範例 3: 驗證一致性
```
請使用 kb-sync 驗證知識庫一致性
```

**檢查項目**:
- INDEX.md 是否包含所有檔案
- changelog.md 是否記錄所有變更
- Knowledge Base 是否同步

## 配置參數

```yaml
# ~/.kiro/skills/kb-sync/config.yaml
meta:
  owner: Ivy
  type: kb-sync

config:
  # 同步設定
  auto_sync: true
  sync_on_task_complete: true
  sync_interval: 0  # 0 = 立即同步
  
  # INDEX.md 設定
  index_path: "docs/00_Meta/INDEX.md"
  auto_increment_version: true
  sort_entries: true
  
  # Changelog 設定
  changelog_path: "docs/00_Meta/changelog.md"
  version_format: "semantic"
  auto_generate_entry: true
  
  # Knowledge Base 設定
  kb_context_id: "auto-detect"
  kb_auto_update: true
  
  # 檢查設定
  check_broken_links: true
  check_frontmatter: true
  check_duplicates: false
```

## 同步報告格式

```markdown
# KB Sync 執行報告

**執行時間**: 2026-03-03 17:00
**目標目錄**: /path/to/kb/

## 偵測變更
- 新增: 2 個檔案
- 修改: 1 個檔案
- 刪除: 0 個檔案

## INDEX.md 更新
- 版本: 1.2.0 → 1.3.0
- 新增條目: 2 個

## Changelog 更新
- 新增版本: [1.3.0] - 2026-03-03
- 記錄變更: 3 項

## Knowledge Base 同步
- Context ID: abc123
- 狀態: ✅ 成功
- 更新項目: 3 個

## 驗證結果
- [x] INDEX.md 完整
- [x] Changelog 完整
- [x] Frontmatter 完整
- [x] 交叉引用正確
- [x] Knowledge Base 同步
```

## 最佳實踐

1. **即時同步**: 任務完成立即同步，不累積
2. **完整記錄**: 記錄所有變更，包含原因
3. **版本控制**: 配合 Git commit 使用
4. **定期驗證**: 每週執行一次完整驗證
5. **備份優先**: 同步前備份 INDEX.md 和 changelog.md

## 故障排除

### INDEX.md 格式錯誤
**症狀**: 更新後格式混亂  
**解決**: 使用 kb-manager 重新格式化

### Changelog 版本衝突
**症狀**: 版本號重複或跳號  
**解決**: 手動修正版本號，重新執行同步

### Knowledge Base 同步失敗
**症狀**: 檔案未被索引  
**解決**: 
1. 確認檔案已放置於知識庫目錄
2. 確認檔案為 .md 格式
3. 等待 Kiro CLI 自動索引（通常在下次啟動時）
4. 或在聊天中使用 `/knowledge add` 手動觸發

## 版本歷史

### [1.0.0] - 2026-03-03
- ✨ 初始版本
- 實作自動同步機制
- 整合 INDEX.md 和 changelog.md 更新
- 支援 kiro-cli knowledge 同步

### [1.1.0] - 2026-03-11
- 🔧 修正 Knowledge Base 同步說明
- 📝 更新為正確的 `/knowledge` 斜線命令用法
- ✨ 說明自動索引機制
- 🗑️ 移除錯誤的 `kiro-cli knowledge` CLI 命令
