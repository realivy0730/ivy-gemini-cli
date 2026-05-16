# Let's Encrypt 方案（無 LB 架構）

## 適用場景
- GCE + Nginx 直連，無 Load Balancer
- 內部系統、辦公室 IP 白名單限制

## 簽發方式
```shell
sudo certbot certonly --webroot \
  -w /var/www/certbot \
  -d domain1.example.com \
  -d domain2.example.com \
  --non-interactive --agree-tos -m admin@example.com
```

## webroot 續約配置 — 踩坑記錄

**問題**：renewal config 中 `[[webroot_map]]` 區塊可能為空，導致 `certbot renew --dry-run` 失敗。

**修正**：確認 `/etc/letsencrypt/renewal/{cert_name}.conf` 中包含所有域名：

```ini
[[webroot_map]]
domain1.example.com = /var/www/certbot
domain2.example.com = /var/www/certbot
```

**驗證**：`sudo certbot renew --dry-run`

## Nginx 配置要點

```nginx
location /.well-known/acme-challenge/ {
    root /var/www/certbot;
}
```

## 防火牆要求
- port 80 必須對外開放（驗證需要）
- Nginx port 80 只做 301 跳轉
- 服務 port 443 仍受 IP 白名單保護

## 實戰案例
- 專案：rd-internal-crm (2026-04)
- 方案：GCE + Nginx + Let's Encrypt SAN（4 域名）
- 續約：webroot 模式，凌晨 03:00 CST 排程
