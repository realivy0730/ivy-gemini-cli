---
name: infra-validation
description: "稽核雲端基礎設施配置正確性，比對知識庫記載的預期狀態與實際部署狀態的差異。Use when auditing infrastructure drift or verifying post-deployment correctness."
---

# 基礎設施配置驗證

## 架構描述
自動化驗證雲端基礎設施配置，比對知識庫中的預期配置與實際部署狀態，產生差異報告與修正建議。支援 AWS、GCP、Azure 多雲環境。

## 觸發方式
- "驗證 [環境名稱] 基礎設施配置"
- "檢查 [服務] 配置是否正確"
- "比對 [環境] 預期與實際狀態"

## 執行流程

### Phase 1: 查詢預期配置
1. 從 knowledge base 搜尋目標環境的預期配置
2. 解析配置文件中的關鍵參數
3. 建立預期狀態清單

### Phase 2: 取得實際狀態
1. 使用 `use_aws` / `execute_bash` 取得實際部署狀態
2. 解析回傳的 JSON/YAML 資料
3. 建立實際狀態清單

### Phase 3: 差異分析
1. 逐項比對預期 vs 實際
2. 分類差異等級:
   - 🔴 Critical: 安全性/功能性問題
   - 🟡 Warning: 非最佳實踐
   - 🟢 Info: 微小差異
3. 產生差異報告

### Phase 4: 修正建議
1. 針對每項差異提供修正指令
2. 評估修正風險
3. 建立修正腳本 (可選)

## 配置數據 (kiro-cli config)
```yaml
meta:
  owner: Ivy
  type: skill
  skill_id: infra-validation
  version: 1.1
  scope: global

workflow:
  steps:
    - name: 查詢預期配置
      tool: knowledge
      action: search
      params:
        query: "${environment_name} 配置"

    - name: 取得實際狀態
      tool: use_aws | execute_bash
      params:
        service: auto-detect
        region: ap-east-2

    - name: 差異分析
      tool: sequentialthinking
      params:
        thought_pattern: compare-config

    - name: 生成報告
      tool: write_file
      output: validation-report.md

validation_items:
  aws:
    - Route53 DNS 記錄
    - ALB/ELB Listener 規則
    - S3 Bucket Policy / CORS
    - CloudFront Distribution
    - Security Group 規則
    - IAM Policy
  gcp:
    - Load Balancer 配置
    - Cloud Armor 規則
    - DNS 記錄
    - Backend Service: load_balancing_scheme (EXTERNAL_MANAGED)
    - Backend Service: timeout_sec / connection_draining_timeout_sec
    - URL Map: host rules 數量與 hosts 列表完整性
    - URL Map: backend 對應正確性
    - NEG: endpoint 數量 > 0
    - NEG: zone 分布
  terraform_iac:
    - .tf 檔案 vs 雲端實際配置一致性
    - 變數定義完整性（無 dead variables）
    - Backend Service 參數對齊
  common:
    - SSL/TLS 憑證狀態
    - 防火牆規則
    - 監控告警設定

output_format:
  report: markdown
  location: ~/Downloads/
```

## 報告範本
```markdown
# 基礎設施驗證報告
**環境**: [環境名稱]
**日期**: [執行日期]

## 驗證結果摘要
| 項目 | 預期 | 實際 | 狀態 |
|------|------|------|------|
| DNS  | ...  | ...  | ✅/❌ |

## Terraform IaC 一致性
| 資源 | .tf 定義 | 雲端實際 | 一致 |
|------|---------|---------|------|
| Backend timeout_sec | 30 | 30 | ✅ |

## 差異詳情
### 🔴 Critical
### 🟡 Warning
### 🟢 Info

## 修正建議
```

## GCP WAF Security 驗證清單
詳見 references/gcp-waf-security-checklist.md（Security by Design / Zero Trust / Shift-Left / Preemptive / AI Security 五大面向）

## 驗收標準
- [ ] 預期配置已從知識庫取得
- [ ] 實際狀態已從雲端取得
- [ ] 差異報告已產生
- [ ] 修正建議已提供 (若有差異)

## 注意事項
- 驗證前確認 AWS/GCP credentials 有效
- 知識庫資料可能過期，需交叉驗證
- Critical 差異需立即通知，不可僅記錄
- 修正腳本執行前需人工確認
