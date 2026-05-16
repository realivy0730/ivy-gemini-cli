# SSL 憑證雲端操作指令

## GCP Certificate Manager

### DNS Authorization
```shell
gcloud certificate-manager dns-authorizations create \
  {prefix}-{base_domain_slug}-auth \
  --domain="{prefix}.{base_domain}"

gcloud certificate-manager dns-authorizations create \
  dev-{prefix}-{base_domain_slug}-auth \
  --domain="dev.{prefix}.{base_domain}"
```

### 建立憑證
```shell
# 根域名
gcloud certificate-manager certificates create {prefix}-root-cert \
  --domains="{prefix}.{base_domain}"

# 萬用字元
gcloud certificate-manager certificates create {prefix}-main-cert \
  --domains="*.{prefix}.{base_domain}" \
  --dns-authorizations={prefix}-{base_domain_slug}-auth
```

### 綁定 Certificate Map
```shell
gcloud certificate-manager maps entries create {prefix}-root-entry \
  --map={cert_map_name} \
  --certificates={prefix}-root-cert \
  --hostname="{prefix}.{base_domain}"

gcloud certificate-manager maps entries create {prefix}-wildcard-entry \
  --map={cert_map_name} \
  --certificates={prefix}-main-cert \
  --hostname="*.{prefix}.{base_domain}"
```

### 驗證
```shell
gcloud certificate-manager dns-authorizations describe \
  {prefix}-{base_domain_slug}-auth \
  --format="value(dnsResourceRecord.name,dnsResourceRecord.data)"

gcloud certificate-manager certificates describe {prefix}-root-cert \
  --format="get(managed.state)"
```

## AWS ACM

### 建立憑證
```shell
# 根域名 + 萬用字元合併
aws acm request-certificate \
  --domain-name "{prefix}.{base_domain}" \
  --subject-alternative-names "*.{prefix}.{base_domain}" \
  --validation-method DNS \
  --tags Key=Name,Value={prefix}-prod-cert Key=Environment,Value=prod

# 環境憑證
aws acm request-certificate \
  --domain-name "*.dev.{prefix}.{base_domain}" \
  --validation-method DNS \
  --tags Key=Name,Value={prefix}-dev-cert Key=Environment,Value=dev
```

### 綁定
```shell
# ALB
aws elbv2 add-listener-certificates \
  --listener-arn {listener_arn} \
  --certificates CertificateArn={cert_arn}

# CloudFront
aws cloudfront update-distribution \
  --id {distribution_id} \
  --viewer-certificate AcmCertificateArn={cert_arn},SslSupportMethod=sni-only
```

### 驗證
```shell
aws acm describe-certificate --certificate-arn {arn} \
  --query "Certificate.DomainValidationOptions[].ResourceRecord"

aws acm describe-certificate --certificate-arn {arn} \
  --query "Certificate.Status"
```

## Azure App Service Managed Certificate

### 前提條件檢查
```shell
# 確認 Plan 層級（需 Basic 以上）
az appservice plan show --id $(az webapp show -n {app_name} -g {rg} --query appServicePlanId -o tsv) \
  --query "{name:name, sku:sku.name, tier:sku.tier}" -o table

# 確認自訂網域已綁定
az webapp config hostname list -g {rg} --webapp-name {app_name} \
  --query "[].{name:name, sslState:sslState, thumbprint:thumbprint}" -o table
```

### 建立憑證與 SNI 綁定
```shell
az webapp config ssl create -n {app_name} -g {rg} --hostname {custom_domain}
az webapp config ssl bind -n {app_name} -g {rg} \
  --certificate-thumbprint {thumbprint} --ssl-type SNI
```

### Private Endpoint 場景

A record 指向私有 IP 時 DNS 驗證會失敗，需暫時切換：

```
調查 Private Endpoint → 記錄私有 IP → A record 暫時改為公有 IP
→ 建立 Managed Cert → SNI 綁定 → A record 改回私有 IP
```

```shell
# 確認 Private Endpoint
az network private-endpoint list \
  --query "[?contains(to_string(privateLinkServiceConnections), '{app_name}')].{name:name, ip:customDnsConfigs[0].ipAddresses[0]}" -o table

# 取得公有 IP
dig +short {app_name}.azurewebsites.net

# 暫時切換 DNS（TTL 降為 60 秒）
aws route53 change-resource-record-sets --hosted-zone-id {zone_id} \
  --change-batch '{"Changes":[{"Action":"UPSERT","ResourceRecordSet":{"Name":"{custom_domain}","Type":"A","TTL":60,"ResourceRecords":[{"Value":"{public_ip}"}]}}]}'

# 建立憑證 + SNI 綁定後，改回私有 IP
aws route53 change-resource-record-sets --hosted-zone-id {zone_id} \
  --change-batch '{"Changes":[{"Action":"UPSERT","ResourceRecordSet":{"Name":"{custom_domain}","Type":"A","TTL":86400,"ResourceRecords":[{"Value":"{private_ip}"}]}}]}'
```

**注意**：續期使用 HTTP Token 驗證（2025-11 更新），不需要再次切換 DNS。

## 通用驗證

```shell
curl -vI https://{prefix}.{base_domain} 2>&1 | grep -E "subject|issuer|expire"
dig @8.8.8.8 _acme-challenge.{prefix}.{base_domain} CNAME +short
```
