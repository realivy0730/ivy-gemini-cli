---
name: troubleshoot
description: "使用科赫法則進行系統性故障排查：定義問題、蒐集數據、隔離變數、驗證假設、RCA 與對策。用於診斷錯誤或故障。 Use when investigating or fixing system errors."
---

# Troubleshoot (故障排查)

## 架構描述
套用科赫法則進行系統性故障排查，查詢歷史案例，產生 RCA 報告並記錄至 Memory。

## 觸發方式
- "排查 [錯誤訊息或現象]"
- "troubleshoot [問題]"
- "故障分析 [服務]"

## 執行流程
1. 定義問題（科赫法則第一步）
2. 蒐集數據（日誌、監控、配置）
3. 隔離變數（排除法）
4. 驗證假設（實驗驗證）
5. RCA（根本原因分析）
6. 對策與預防措施

## 配置數據 (kiro-cli config)
```yaml
meta:
  owner: Ivy
  type: skill
  skill_id: troubleshoot
  version: 1.0
  scope: global

trigger:
  keywords: ["排查", "故障", "troubleshoot", "錯誤分析"]

workflow:
  steps:
    - name: 定義問題
      tool: sequentialthinking
      params:
        thought: "明確問題範圍、影響、時間點"
        method: koch-method
        
    - name: 查詢歷史案例
      tool: knowledge
      action: search
      params:
        query: "${error_message}"
        
    - name: 查詢官方文件
      tool: aws-docs | context7
      params:
        search_phrase: "${service_name} troubleshooting"
        
    - name: 蒐集數據
      tool: execute_bash | use_aws
      actions:
        - 讀取日誌
        - 檢查配置
        - 查看監控指標
        
    - name: 隔離變數
      tool: sequentialthinking
      params:
        thought: "逐一排除可能原因"
        
    - name: 驗證假設
      tool: execute_bash
      params:
        command: "測試假設的命令"
        
    - name: 記錄 RCA
      tool: memory
      action: create_entities
      params:
        entity_type: troubleshooting-case
        observations:
          - 問題定義
          - 調查步驟
          - 根本原因
          - 解決方案
          
    - name: 生成報告
      tool: write_file
      output: rca-report.md
```

## 驗收標準
- [ ] 問題已明確定義
- [ ] 根本原因已找到
- [ ] 解決方案已驗證
- [ ] RCA 報告已生成
- [ ] 預防措施已記錄

## 使用範例
```
使用者: "排查 CloudFront 502 錯誤"
Kiro:
1. 定義問題: 502 錯誤，影響所有使用者
2. 查詢歷史: 找到類似案例
3. 蒐集數據: CloudFront 日誌、Origin 狀態
4. 隔離變數: 測試 Origin 連線
5. 驗證假設: Origin 超時
6. RCA: Origin 回應時間 > 30s
7. 對策: 調整 Origin timeout 設定
```

## 注意事項
- 遵循科赫法則，避免跳步驟
- 記錄所有嘗試，即使失敗
- RCA 必須找到根本原因，非表面現象
