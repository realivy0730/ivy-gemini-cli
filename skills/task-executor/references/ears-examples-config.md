## EARS 需求確認（融入自 spec-driven-development 方法論）

複雜任務在拆解前，先用 EARS 格式確認需求，避免方向偏差。

### EARS 格式模板

| 模式 | 語法 | 適用場景 |
|------|------|----------|
| Event-Response | WHEN [事件] THEN system SHALL [回應] | 最常用，觸發型行為 |
| Conditional | IF [前置條件] THEN system SHALL [回應] | 狀態判斷 |
| Complex | WHEN [事件] AND [條件] THEN system SHALL [回應] | 複合條件 |
| State-Based | WHEN [系統處於特定狀態] THEN system SHALL [行為] | 狀態機 |
| Performance | WHEN [操作] THEN system SHALL [在 X 秒內回應] | 效能需求 |
| Security | IF [認證條件] THEN system SHALL [安全回應] | 安全需求 |

### 需求確認流程

1. **擷取需求**：用 User Story 格式（As a [角色], I want [功能], so that [效益]）
2. **定義驗收標準**：每個需求用 EARS 格式寫 3-7 條驗收標準
3. **識別邊界案例**：空值、極端值、失敗、並發、未授權
4. **驗證完整性**：
   - [ ] 所有角色已識別
   - [ ] 正常/邊界/錯誤情境已涵蓋
   - [ ] 每條需求可測試、可量化
   - [ ] 無矛盾需求
   - [ ] EARS 格式一致

### 範例：ELB Access Logs 啟用

```markdown
**User Story:** As a SRE, I want to enable ELB access logs, so that I can analyze traffic patterns.

**Acceptance Criteria:**
1. WHEN admin enables access logs THEN system SHALL create S3 bucket with correct policy
2. WHEN ELB receives traffic THEN system SHALL write log files to S3 within 5 minutes
3. IF S3 bucket policy is incorrect THEN system SHALL display permission error
4. WHEN logs are stored THEN system SHALL be queryable via Athena
5. WHEN task completes THEN system SHALL update knowledge base documentation
```

### 何時使用 EARS
- ✅ 複雜任務（> 5 步驟）
- ✅ 涉及多個系統整合
- ✅ 需要明確驗收標準的正式任務
- ❌ 簡單查詢或單步操作
- ❌ 緊急修復（直接進入執行）

## TODO List 管理

### 建立 TODO
```yaml
command: create
tasks:
  - task_description: "階段 1 描述"
    details: "詳細說明、驗收標準"
  - task_description: "階段 2 描述"
    details: "詳細說明、驗收標準"
```

### 完成階段
```yaml
command: complete
completed_indices: [0]  # 0-indexed
context_update: "階段 1 完成，驗證結果：..."
modified_files: ["path/to/file.md"]
```

## 驗證標準

每個階段必須包含：

### 功能驗證
- 執行命令成功
- 輸出符合預期
- 無錯誤訊息

### 狀態驗證
- 資源狀態正確
- 配置生效
- 服務正常運作

### 文件驗證
- 相關文件已更新
- 記錄執行過程
- 標記完成狀態

## 執行記錄格式

```markdown
## 階段 N: [階段名稱]

**執行時間**: YYYY-MM-DD HH:MM

### 執行命令
\`\`\`bash
command here
\`\`\`

### 執行結果
- 狀態: ✅ 成功 / ❌ 失敗
- 輸出: [關鍵輸出]

### 驗證結果
- [x] 驗證項目 1
- [x] 驗證項目 2

### 影響檔案
- `path/to/file1.md` (新增)
- `path/to/file2.tf` (修改)
```

## 錯誤處理

### 階段失敗
1. 記錄錯誤訊息
2. 分析失敗原因
3. 提供修正方案
4. 重新執行或跳過

### 回滾機制
- 每階段執行前備份
- 失敗時提供回滾命令
- 記錄回滾步驟

## 與其他 Skills 整合

### kb-sync
階段完成後自動觸發知識庫同步

### kb-manager
任務完成後自動產生變更記錄

### validation-report-generator
所有階段完成後生成驗收報告

## 使用範例

### 範例 1: 基礎設施部署
```
請使用 task-executor 執行 ELB Access Logs 啟用任務
```

**執行流程**:
1. 拆解為 5 個階段
2. 建立 TODO list
3. 逐階段執行與驗證
4. 記錄每階段結果
5. 生成完整報告

### 範例 2: 配置變更
```
請使用 task-executor 更新 Terraform 配置
```

**執行流程**:
1. 備份現有配置
2. 修改配置檔
3. terraform validate
4. terraform plan
5. terraform apply
6. 驗證變更生效

## 最佳實踐

1. **先規劃後執行**: 先完整拆解，再開始執行
2. **即時驗證**: 不累積多個階段再驗證
3. **詳細記錄**: 記錄所有命令與輸出
4. **保留證據**: 截圖、日誌檔案、配置備份
5. **更新文件**: 每階段完成立即更新相關文件

## 配置參數

```yaml
# ~/.kiro/skills/task-executor/config.yaml
meta:
  owner: Ivy
  type: task-executor

config:
  # 階段設定
  max_stages: 7
  min_stages: 3
  stage_timeout: 900  # 15 分鐘
  
  # 驗證設定
  require_verification: true
  auto_rollback: false
  
  # 記錄設定
  log_commands: true
  log_output: true
  save_backups: true
  
  # 整合設定
  auto_sync_kb: true
  auto_generate_changelog: true
  auto_generate_report: true
```

## 故障排除

### 階段卡住
**症狀**: 階段執行超過預期時間  
**解決**: 檢查命令是否需要互動輸入，使用 `--auto-approve` 等參數

### 驗證失敗
**症狀**: 功能正常但驗證失敗  
**解決**: 檢查驗證標準是否過於嚴格，調整驗證邏輯

### TODO 狀態不同步
**症狀**: 實際完成但 TODO 未標記  
**解決**: 手動執行 `todo_list complete` 同步狀態

## 版本歷史

### [1.0.0] - 2026-03-03
- ✨ 初始版本
- 實作階段性執行框架
- 整合 TODO list 管理
- 提供驗證與記錄機制
