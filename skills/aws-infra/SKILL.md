---
name: aws-infra
description: "部署與操作 AWS 基礎設施，包含 EC2、S3、RDS、VPC、IAM、CloudFront、Route53、ELB。Use when deploying resources, managing DNS records, or performing operational changes."
---

# AWS Infrastructure Management

## 架構描述
AWS 基礎設施管理最佳實踐，涵蓋 EC2、S3、RDS、VPC、IAM、CloudFront、Route53、ELB 等核心服務。

## 觸發方式
- "部署 AWS [服務]"
- "檢查 AWS [資源] 狀態"
- "AWS 安全性檢查"
- "變更 DNS 記錄"
- "管理 ELB Listener"
- "設定 S3 Website Redirect"

## 操作前評估問題（Assessment Questions 模式）

執行基礎設施變更前先釐清：

1. 這是生產環境還是測試環境？
2. 變更影響範圍？（單一資源 / 跨 AZ / 跨 Region）
3. 是否有備份？回滾方案？
4. 預估成本影響？

## 執行流程
1. 驗證 AWS CLI 已配置
2. 檢查當前 region 與 profile
3. 執行對應的 AWS 操作
4. 驗證結果
5. 記錄變更

詳細 workflow 配置參見 `references/workflow-config.yaml`。
CLI 指令參考參見 `references/cli-commands.md`。

## 最佳實踐

### 安全性
- 啟用 MFA、使用 IAM roles、定期輪換 credentials
- 啟用 CloudTrail 日誌、S3 bucket 預設私有

### 成本優化
- 使用 Reserved Instances、刪除未使用 EBS volumes
- 使用 S3 Lifecycle policies、啟用 CloudFront 壓縮

### 高可用性
- 多 AZ 部署、Auto Scaling、Health Checks、CloudWatch Alarms

## 驗收標準
- [ ] AWS CLI 已配置、Region 正確
- [ ] 操作執行成功、資源狀態正確
- [ ] 變更已記錄

## 注意事項
- 台北 region (ap-east-2) 需明確指定
- CloudFront 操作必須使用 us-east-1
- 生產環境操作需二次確認
- DNS 變更需保留回滾指令
- S3 Website Endpoint 僅支援 HTTP，需 HTTPS 時搭配 CloudFront
