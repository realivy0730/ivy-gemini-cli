## 配置數據 (kiro-cli config)
```yaml
meta:
  owner: Ivy
  type: skill
  skill_id: code-review
  version: 2.0
  scope: global
  compliance:
    context7_mandatory: true
    todo_list_required: true
    rca_on_error: true
    production_protected: true

trigger:
  keywords: ["審查程式碼", "code review", "檢查程式碼"]

checklist:
  critical:  # 阻斷項目
    - 硬編碼密鑰
    - SQL Injection 漏洞
    - XSS 漏洞
    
  major:  # 重要問題
    - 缺少錯誤處理
    - N+1 查詢問題
    - 資源未釋放
    
  minor:  # 建議改善
    - 命名不清晰
    - 註解不足
    - 魔術數字

workflow:
  pre_check:
    - name: 建立 TODO 清單
      tool: todo_list
      action: create
      mandatory: true
      
    - name: 確認檔案存在
      tool: read_text_file
      verification:
        - 檔案可讀取
        - 內容非空
        
  steps:
    - name: 讀取程式碼
      tool: read_text_file | code
      params:
        path: "${target_path}"
      verification:
        - 檔案成功讀取
        - 內容非空
        - 檔案格式正確
      on_error:
        - 暫停操作
        - 記錄錯誤到 LEARNINGS.md
        - 執行 RCA
        
    - name: 查詢最佳實踐
      tool: context7
      params:
        libraryName: "${language_or_framework}"
        topic: "best practices"
      mandatory: true
      verification:
        - 成功取得文件
        - 文件相關性 > 80%
        - 包含程式碼範例
      on_error:
        - 暫停操作
        - 使用 sequential-thinking 分析原因
        - 嘗試替代查詢方式
        
    - name: 讀取專案規範
      tool: read_text_file
      params:
        paths:
          - AGENTS.md
          - .clinerules
          - .eslintrc
      optional: true
      verification:
        - 規範檔案已讀取（若存在）
        
    - name: 逐項檢查
      tool: sequentialthinking
      params:
        thought_pattern: code-review-checklist
      verification:
        - 所有檢查項目已執行
        - 問題已分級（Critical/Major/Minor）
        - 每個問題都有具體位置
        
    - name: 假陽性過濾
      tool: sequentialthinking
      params:
        thought: "交叉驗證問題是否為真正的 bug"
      verification:
        - 假陽性已過濾
        - 保留真實問題
        
    - name: 生成報告
      tool: write_file
      output: code-review-report.md
      sections:
        - 總體評分
        - 問題清單（Critical/Major/Minor）
        - 改善建議（含範例程式碼）
        - 合規性檢查結果
      verification:
        - 報告已生成
        - 包含所有必要區塊
        - 範例程式碼正確
        
    - name: 記錄常見問題
      tool: memory
      action: add_observations
      params:
        entityName: "code-review-patterns"
      verification:
        - 記錄成功
        
  post_check:
    - 驗證報告完整性
    - 標記 TODO 完成
    - 記錄執行歷史
```

