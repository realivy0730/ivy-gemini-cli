---
name: task-executor
description: 階段性任務執行框架，將複雜任務拆解為可驗證的小步驟，每步驟執行後立即驗證並記錄。Use when breaking down complex tasks into verifiable steps.
version: "1.0.0"
created: "2026-03-03"
updated: "2026-03-03"
type: skill
owner: Ivy
---

# Task Executor - 任務執行框架

## 核心理念
**禁止一次性給出未經驗證的冗長步驟**

所有任務必須：
1. 拆解為 3-7 個可驗證的小階段
2. 每階段執行後立即驗證
3. 驗證通過才進入下一階段
4. 記錄每階段的執行結果

## 執行流程
```
任務接收 → 拆解階段 (Plan) → [對抗性規劃審核] → 執行階段 1 → 驗證 → 記錄
                                             ↓
                                        執行階段 N → [對抗性代碼審核] → 驗證 → 記錄
                                             ↓
                                        生成完整報告 (含 Review Gate 分數)
```

## 關鍵檢查點
- **規劃階段**：啟動 `planning-agent-guide` 中的對抗性分析。
- **代碼階段**：複雜腳本產出後，強制調用 `code-adversary` 進行挑刺審查。
- **部署階段**：執行 `deploy-check` 並確認 `Review Gate` 分數 >= 90。

## 任務拆解原則

### 單一階段標準
- 時間：5-15 分鐘內可完成
- 輸出：有明確可驗證的輸出
- 獨立性：可獨立執行與回滾
- 可驗證：有明確的驗收標準

## TODO List 管理
- 建立：`todo_list create` 含 task_list_description + tasks
- 完成：每階段完成後立即 `todo_list complete`，含 context_update + modified_files

## 驗證標準
- 功能驗證：執行成功、輸出符合預期
- 狀態驗證：資源正確、配置生效
- 文件驗證：changelog 已更新、知識庫已同步

## 錯誤處理
- 階段失敗 → 暫停 → RCA → 修復 → 重試
- 回滾機制：每階段記錄回滾指令

## 與其他 Skills 整合
- kb-sync：每階段完成後觸發文件同步
- kb-manager：同步前檢查 frontmatter 完整性

EARS 需求確認、使用範例、配置參數、故障排除參見 `references/ears-examples-config.md`。
