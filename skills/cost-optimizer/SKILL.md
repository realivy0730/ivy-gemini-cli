---
name: cost-optimizer
description: "分析 AWS 服務成本並建議優化方案，比較 ALB、S3、CloudFront 等替代方案。用於評估降本或選擇 AWS 服務。 Use when optimizing cloud infrastructure costs."
---

# AWS 成本優化分析

## 架構描述
系統性分析 AWS 服務成本，比較替代方案，產出成本對照表與執行建議。基於 www.eagleeye.com.tw DNS 優化案例（ALB $18/月 → S3 $0.01/月）設計。

## 觸發方式
- "分析 [服務] 成本"
- "成本優化建議"
- "比較 [方案A] 和 [方案B] 的費用"
- "這個架構可以省錢嗎"

## 執行流程

### Phase 1: 現狀盤點
1. 識別目標服務與 Region
2. 查詢 AWS Cost Explorer 或手動計算當前成本
3. 列出所有相關資源 (ALB, EC2, S3, CloudFront, NAT Gateway 等)
4. 確認資源是否被多個服務共用

### Phase 2: 替代方案評估
1. 列出可行替代方案
2. 計算每個方案的月成本
3. 評估功能差異與限制
4. 產出成本對照表

### Phase 3: 方案建議
1. 依成本排序推薦
2. 標註功能取捨 (例: S3 Website 不支援 HTTPS)
3. 提供執行步驟與回滾方案
4. 估算年度節省金額

### Phase 4: 執行與驗證
1. 執行選定方案
2. 驗證功能正常
3. 記錄變更文件
4. 追蹤下月帳單確認節省

## 配置數據 (kiro-cli config)
```yaml
meta:
  owner: Ivy
  type: skill
  skill_id: cost-optimizer
  version: 1.0
  scope: global

cost_reference:
  # 常見服務月成本參考 (ap-east-2)
  alb:
    fixed: 16.20  # $0.0225/hr × 720hr
    lcu: 2-5      # 依流量
  s3_website:
    storage: 0     # 空 bucket
    requests: 0.01 # 每 1000 GET $0.0004
  cloudfront:
    minimum: 1.00  # 最低月費
    transfer: 0.085 # per GB (前 10TB)
  nat_gateway:
    fixed: 32.40   # $0.045/hr × 720hr
    transfer: 0.045 # per GB
  route53:
    hosted_zone: 0.50  # per zone/month
    queries: 0.40      # per million

output_template: |
  | 方案 | 組成 | 月成本 | 年成本 | 備註 |
  |------|------|--------|--------|------|
```

## 常見優化模式

### DNS Redirect (本案例)
```
ALB ($18/月) → S3 Website Redirect ($0.01/月)
節省: $216/年
條件: 僅需 HTTP 301 重導向
```

### 靜態網站
```
EC2 + ALB ($30-50/月) → S3 + CloudFront ($2-5/月)
節省: $300-540/年
條件: 純靜態內容
```

### NAT Gateway
```
NAT Gateway ($32/月) → NAT Instance ($5-10/月)
節省: $264-324/年
條件: 低流量場景
```

## GCP WAF Cost Optimization 驗證清單
詳見 references/gcp-waf-cost-checklist.md（成本歸屬 / Rightsizing / CUD / 閒置資源 / Serverless 優先）

## 驗收標準
- [ ] 當前成本已量化
- [ ] 至少 2 個替代方案已評估
- [ ] 成本對照表已產出
- [ ] 功能限制已標註
- [ ] 回滾方案已準備

## 注意事項
- 共用資源不能直接刪除（先確認無其他依賴）
- S3 Website Endpoint 不支援 HTTPS（需 CloudFront 補足）
- Reserved Instances 有合約期限，提前終止有違約金
- 成本計算需包含 Data Transfer 費用
