---
name: ssl-cert-standard
description: Manage SSL certificates across GCP, AWS, Azure, and Let's Encrypt with standardized naming and environment separation. Use when creating, renewing, or deleting SSL certificates.
---

# SSL 憑證跨雲管理標準

## Step 0：確認參數（強制）

向使用者確認以下資訊，**不可假設域名**：

| 參數 | 說明 | 範例 |
|------|------|------|
| `{prefix}` | 服務/產品代號 | ads, cdmp, api |
| `{base_domain}` | 專案基礎域名 | example.com |
| `{cloud}` | 雲端平台 | GCP / AWS / Azure |
| `{environments}` | 需要的環境 | dev, sit, uat, prod |
| `{dns_provider}` | DNS 託管位置 | Route53 / Cloud DNS |

## Step 1：產生憑證清單

```
{prefix}-root-cert  → {prefix}.{base_domain}           （僅 prod 根域名）
{prefix}-main-cert  → *.{prefix}.{base_domain}          （prod 萬用字元）
{prefix}-dev-cert   → *.dev.{prefix}.{base_domain}      （dev）
{prefix}-sit-cert   → *.sit.{prefix}.{base_domain}      （sit）
{prefix}-uat-cert   → *.uat.{prefix}.{base_domain}      （uat）
```

**規則**：dev/sit/uat 僅需萬用字元憑證，不需要根域名憑證。

## Step 2-5：建立 → DNS 驗證 → 綁定 → 驗證

依雲端平台執行對應指令，詳見 `references/cloud-commands.md`。

## 驗收標準
- [ ] 使用者已確認 `{prefix}` 和 `{base_domain}`
- [ ] 憑證名稱清單已確認
- [ ] 所有憑證已建立
- [ ] DNS 驗證記錄已配置
- [ ] 憑證狀態為 ACTIVE / ISSUED
- [ ] HTTPS 連線驗證通過
- [ ] 專案文件已更新

## 注意事項
- GCP 萬用字元憑證必須搭配 DNS Authorization
- AWS ACM 可將根域名 + 萬用字元合併為一張憑證（SAN）
- Azure Managed Certificate 不支援萬用字元，每個自訂網域獨立建立
- Azure Private Endpoint 場景需暫時切換 DNS（詳見 `references/cloud-commands.md`）

## 參考資料
- 雲端操作指令: `references/cloud-commands.md`
- Let's Encrypt 方案: `references/letsencrypt.md`
- 配置數據: `references/config.yaml`
