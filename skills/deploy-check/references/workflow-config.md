## 配置數據 (kiro-cli config)
```yaml
meta:
  owner: Ivy
  type: skill
  skill_id: deploy-check
  version: 2.0
  scope: global
  compliance:
    context7_mandatory: false  # 不涉及腳本生成
    todo_list_required: true
    rca_on_error: true
    production_protected: true  # 最高優先級

trigger:
  keywords: ["部署前檢查", "deploy check", "驗證部署"]

checklist:
  configuration:
    - 配置檔語法正確
    - 環境變數已設定
    - 版本號已更新
    - 依賴套件已鎖定
    
  backup:
    - 資料庫已備份（< 24h）
    - 配置檔已備份
    - 備份可還原
    
  rollback:
    - 回滾腳本已準備
    - 回滾步驟已測試
    - 回滾時間預估 < 30min
    
  security:
    - 無硬編碼密鑰
    - SSL/TLS 配置正確
    - 防火牆規則已更新
    - 權限設定正確
    
  monitoring:
    - 監控已設定
    - 告警已配置
    - 日誌記錄已啟用

workflow:
  pre_check:
    - name: 建立 TODO 清單
      tool: todo_list
      action: create
      mandatory: true
      
    - name: 確認目標環境
      tool: execute_bash
      command: "echo $ENVIRONMENT"
      verification:
        - 環境變數已設定
        - 環境名稱正確（dev/staging/production）
        
    - name: 生產環境確認
      condition: if environment == "production"
      action: require_confirmation
      message: "⚠️ 即將檢查生產環境部署，請確認"
      verification:
        - 使用者已明確確認
        
  steps:
    - name: 檢查配置
      tool: read_text_file | execute_bash
      actions:
        - 驗證 YAML/JSON 語法
        - 檢查環境變數
        - 確認版本號
      verification:
        - 配置檔語法正確
        - 環境變數已設定
        - 版本號已更新
      on_error:
        - 暫停操作
        - 記錄錯誤到 LEARNINGS.md
        - 執行 RCA
        
    - name: 驗證備份
      tool: execute_bash | use_aws
      actions:
        - 檢查最新備份時間
        - 驗證備份完整性
        - 測試還原流程（dry-run）
      verification:
        - 備份時間 < 24h
        - 備份檔案完整
        - 還原測試通過
      on_error:
        - 暫停操作
        - 標記為阻斷項目
        - 要求建立新備份
        
    - name: 檢查回滾方案
      tool: read_text_file
      params:
        path: "rollback.sh"
      verification:
        - 回滾腳本存在
        - 腳本語法正確
        - 包含回滾步驟
      on_error:
        - 暫停操作
        - 標記為阻斷項目
        - 要求建立回滾方案
        
    - name: 安全性掃描
      tool: execute_bash
      commands:
        - 掃描硬編碼密鑰
        - 檢查 SSL 憑證有效期
        - 驗證防火牆規則
      verification:
        - 無硬編碼密鑰
        - SSL 憑證有效期 > 30 天
        - 防火牆規則正確
      on_error:
        - 記錄為警告或阻斷項目
        - 提供修正建議
        
    - name: 監控檢查
      tool: execute_bash | use_aws
      actions:
        - 確認監控已設定
        - 驗證告警規則
        - 測試告警通知
      verification:
        - 監控正常運作
        - 告警規則正確
        - 通知渠道可用
        
    - name: 生成報告
      tool: write_file
      output: deploy-check-report.md
      sections:
        - 檢查結果摘要
        - 通過項目
        - 警告項目
        - 阻斷項目
        - 建議事項
      verification:
        - 報告已生成
        - 包含所有檢查項目
        - 阻斷項目已標記
        
  post_check:
    - 驗證所有檢查項目已執行
    - 確認阻斷項目為 0
    - 記錄檢查結果到 knowledge
    - 標記 TODO 完成
    
  production_protection:
    enabled: true
    require_confirmation: true
    backup_verification: mandatory
    rollback_plan: mandatory
    blocking_items:
      - 無備份
      - 無回滾方案
      - 硬編碼密鑰
      - SSL 憑證過期
```

