---
name: docker-essentials
description: "Docker 容器管理，包含建置、執行、Compose 與清理操作。用於操作 Docker 容器或映像檔。 Use when managing Docker containers, images, or networks."
---

# Docker Essentials

## 架構描述
Docker 容器管理核心技能，涵蓋 build、run、compose、清理、網路管理等日常操作。

## 觸發方式
- "建立 Docker 映像 [名稱]"
- "執行容器 [映像]"
- "Docker Compose 啟動"
- "清理 Docker 資源"
- "Docker 網路管理"
- "orphan network 清理"

## 執行流程
1. 建立 Dockerfile（若需要）
2. Build 映像
3. 執行容器
4. 管理容器生命週期
5. 網路管理與清理
6. 清理未使用資源

## 配置數據 (kiro-cli config)
```yaml
meta:
  owner: Ivy
  type: skill
  skill_id: docker-essentials
  version: 1.1
  scope: global
  updated: "2026-03-19"
  changelog:
    - "v1.1: 新增網路管理區塊（network inspect/rm、orphan network 偵測、daemon.json 管理）"

trigger:
  keywords: ["docker", "容器", "映像", "compose", "docker network", "orphan network"]

best_practices:
  - 使用 .dockerignore 排除不必要檔案
  - 多階段建置減少映像大小
  - 不在映像中存放敏感資訊
  - 使用特定版本標籤，避免 latest
  - 定期清理未使用資源
  - 定期檢查 orphan network 避免 CIDR 衝突
```

## 常用命令

### 建立映像
```shell
docker build -t myapp:1.0 .
docker build -t myapp:1.0 -f Dockerfile.prod .
```

### 執行容器
```shell
docker run -d --name myapp -p 8080:80 myapp:1.0
docker run -it --rm myapp:1.0 /bin/bash
```

### Docker Compose
```shell
docker compose up -d
docker compose down
docker compose logs -f
```

### 管理容器
```shell
docker ps
docker ps -a
docker stop myapp
docker rm myapp
docker logs myapp
docker exec -it myapp /bin/bash
```

### 網路管理 ⭐ v1.1 新增
```shell
# 列出所有網路
docker network ls

# 檢查網路詳情（含 CIDR 與容器）
docker network inspect {network_name}
docker network inspect bridge --format '{{range .IPAM.Config}}{{.Subnet}}{{end}}'

# 列出所有網路的 CIDR 與容器
for net in $(docker network ls --format '{{.Name}}' | grep -v 'host\|none'); do
  subnet=$(docker network inspect $net --format '{{range .IPAM.Config}}{{.Subnet}}{{end}}' 2>/dev/null)
  containers=$(docker network inspect $net --format '{{range .Containers}}{{.Name}} {{end}}' 2>/dev/null)
  echo "$net: $subnet (containers: ${containers:-none})"
done

# 偵測 orphan network（無容器使用的 bridge）
docker network ls --format '{{.Name}}' | grep -v 'host\|none\|bridge' | while read net; do
  count=$(docker network inspect $net --format '{{len .Containers}}' 2>/dev/null)
  [ "$count" = "0" ] && echo "ORPHAN: $net"
done

# 刪除特定網路
docker network rm {network_name}

# 清理所有未使用的網路
docker network prune -f
```

### daemon.json 管理 ⭐ v1.1 新增
```shell
# 查看 daemon.json
cat /etc/docker/daemon.json

# 驗證 JSON 語法
python3 -c "import json; json.load(open('/etc/docker/daemon.json')); print('✅ JSON 合法')"

# 修改後重啟 Docker（⚠️ 會中斷所有容器）
sudo systemctl restart docker
```

### 清理資源
```shell
docker system prune -f
docker volume prune -f
docker image prune -a -f
docker network prune -f
```

## 驗收標準
- [ ] 映像成功建立
- [ ] 容器正常執行
- [ ] 埠號正確映射
- [ ] 日誌可正常查看
- [ ] 無 orphan network 殘留
- [ ] 資源清理完成

## 注意事項
- 確認 Docker daemon 已啟動
- 注意埠號衝突
- 生產環境使用特定版本標籤
- 定期清理未使用資源
- 敏感資訊使用環境變數或 secrets
- orphan network 可能導致 CIDR 衝突（詳見 `docker-network-conflict-resolution` Skill）
- `daemon.json` 變更需重啟 Docker，會短暫中斷所有容器
