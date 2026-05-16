# SSL 憑證治理規則

## 觸發條件
當使用者要求**建立、更新、檢查、刪除** SSL 憑證時，必須遵循以下標準。

觸發關鍵字：`SSL`, `cert`, `certificate`, `憑證`, `HTTPS`, `TLS`, `cert-map`, `ACM`, `Certificate Manager`

## 核心原則（源自 justar 專案實戰驗證）

### 1. 命名規範
```
{prefix}-root-cert  → {base_domain}              （僅根域名需要）
{prefix}-main-cert  → *.{base_domain}             （prod 萬用字元）
{prefix}-dev-cert   → *.dev.{base_domain}         （dev 環境）
{prefix}-sit-cert   → *.sit.{base_domain}         （sit 環境）
{prefix}-uat-cert   → *.uat.{base_domain}         （uat 環境）
```

- `{prefix}`：服務/產品代號（如 ads, cdmp, api）
- `{base_domain}`：專案基礎域名（如 example.com）
- 命名一律 kebab-case

### 2. 環境憑證規則
- dev/sit/uat 環境**僅需萬用字元憑證**，不需要根域名憑證
- 根域名憑證（`{prefix}-root-cert`）僅用於 `{prefix}.{base_domain}`
- `*.{env}.{prefix}.{base_domain}` 涵蓋該環境所有子域名

### 3. DNS Authorization 命名
```
{prefix}-{base_domain_slug}-auth        → 根域名驗證
dev-{prefix}-{base_domain_slug}-auth    → dev 環境驗證
sit-{prefix}-{base_domain_slug}-auth    → sit 環境驗證
uat-{prefix}-{base_domain_slug}-auth    → uat 環境驗證
```

## 強制流程

### 建立憑證前
1. 確認 `{prefix}` 和 `{base_domain}` — 不可假設域名
2. 確認需要哪些環境（dev/sit/uat/prod）
3. 依命名規範產生憑證名稱清單，讓使用者確認
4. 確認 DNS 託管位置（Route53 / Cloud DNS / 其他）

### 建立憑證時
- 執行細節依據全域 Skill：`~/.kiro/skills/ssl-cert-standard/SKILL.md`

### 建立憑證後
- 驗證憑證狀態（ACTIVE / ISSUED）
- 驗證 HTTPS 連線
- 更新專案文件

## 雲端對照

| 項目 | GCP | AWS |
|------|-----|-----|
| 服務 | Certificate Manager | ACM |
| 憑證類型 | Google Managed | DNS Validated |
| 綁定方式 | Certificate Map → HTTPS Proxy | ALB Listener / CloudFront |
| 萬用字元 | 需 DNS Authorization | 需 DNS Validation |
| 自動更新 | ✅ | ✅ |

## 參考資源
- 全域 Skill：`~/.kiro/skills/ssl-cert-standard/SKILL.md`
- justar 專案 Skill：`gcp-justar-loadbalancing` KB → `gcp-ssl-cert-manager`
- Azure Managed Certificate 續期：若 `ssl create` 返回舊憑證，需先 `az resource delete` 刪除舊憑證資源再重建
