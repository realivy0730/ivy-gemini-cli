---
name: gs-gke
description: "規劃、建立與配置生產就緒的 Google Kubernetes Engine (GKE) 集群，涵蓋 Autopilot、網路、安全性、擴充與成本優化。 Use when managing Google Kubernetes Engine clusters."
---

# Google Kubernetes Engine (GKE) 基礎知識

GKE 是 Google Cloud 上的代管 Kubernetes 平台，用於部署、擴充和操作容器化應用程式。此技能預設使用 **黃金路徑 (Golden Path) Autopilot 配置** —— 請參閱 [gke-golden-path.md](./references/gke-golden-path.md) 了解預設值、規則與護欄。

## 快速入門 (Quick Start)

```bash
gcloud services enable container.googleapis.com
gcloud container clusters create-auto my-cluster --region=us-central1
gcloud container clusters get-credentials my-cluster --region=us-central1
kubectl create deployment hello-server \
  --image=us-docker.pkg.dev/google-samples/containers/gke/hello-app:1.0
```

## 參考目錄 (Reference Directory)

根據觸發關鍵字載入相關參考。優先選擇最精確的匹配；如果不明確，請要求使用者澄清。

| 場景 | 觸發關鍵字 | 參考檔案 |
|----------|-----------------|-----------|
| 核心概念 | Autopilot vs Standard, 架構, 定價, 什麼是 GKE | [core-concepts.md](./references/core-concepts.md) |
| 黃金路徑與預設值 | golden path, Day-0 checklist, 生產預設值, 集群預設值 | [gke-golden-path.md](./references/gke-golden-path.md) |
| 集群建立 | 建立集群, 新集群, 佈署 GKE | [gke-cluster-creation.md](./references/gke-cluster-creation.md) |
| 網路 | 私有集群, VPC, 子網, Gateway API, DNS, ingress, egress | [gke-networking.md](./references/gke-networking.md) |
| 安全性與 IAM | Workload Identity, Secret Manager, RBAC, 二進制授權, 硬化 | [gke-security.md](./references/gke-security.md) |
| 擴充 | HPA, VPA, 自動擴充, NAP, 擴充 Pod, 擴充節點 | [gke-scaling.md](./references/gke-scaling.md) |
| 運算類別 | ComputeClass, 機器家族, Spot 備援, GPU 節點池 | [gke-compute-classes.md](./references/gke-compute-classes.md) |
| 成本 | 成本, 節省, Spot VMs, 權利調整, CUD, 優化支出 | [gke-cost.md](./references/gke-cost.md) |
| AI/ML 推理 | 推理, 模型服務, LLM, GPU, TPU, vLLM | [gke-inference.md](./references/gke-inference.md) |
| 升級 | 升級, 維護視窗, 發佈頻道, 補丁, 版本 | [gke-upgrades.md](./references/gke-upgrades.md) |
| 可觀測性 | 監控, 日誌, Prometheus, Grafana, 指標, 告警 | [gke-observability.md](./references/gke-observability.md) |
| 多租戶 | 多租戶, 命名空間隔離, 團隊存取, RBAC 規劃 | [gke-multitenancy.md](./references/gke-multitenancy.md) |
| 批次與 HPC | 批次, HPC, 作業隊列, 高效能, MPI | [gke-batch-hpc.md](./references/gke-batch-hpc.md) |
| 應用程式上線 | 容器化, 部署 App, Dockerfile, 遷移到 GKE | [gke-app-onboarding.md](./references/gke-app-onboarding.md) |
| 備份與災難復原 | 備份, 還原, 災難復原, CMEK | [gke-backup-dr.md](./references/gke-backup-dr.md) |
| 儲存 | 儲存, PVC, 持久磁碟, StorageClass, Filestore | [gke-storage.md](./references/gke-storage.md) |
| 可靠性 | PDB, 健康檢查, liveness, readiness, 優雅關機 | [gke-reliability.md](./references/gke-reliability.md) |
| 用戶端程式庫 | client library, client-go, kubernetes SDK | [client-library-usage.md](./references/client-library-usage.md) |
| 基礎設施即程式碼 | Terraform, IaC, HCL, 基礎設施即程式碼 | [iac-usage.md](./references/iac-usage.md) |
| MCP 伺服器 | MCP tools, MCP server, MCP setup | [mcp-usage.md](./references/mcp-usage.md) |
| CLI / 工具 | gcloud, kubectl, 指令, 如何操作 | [cli-reference.md](./references/cli-reference.md) |
| 生產稽核 | 生產就緒, 合規性, 黃金路徑檢查 | [gke-cluster-creation.md](./references/gke-cluster-creation.md) |

*如果您需要這些參考資料中找不到的產品資訊，請使用 Developer Knowledge MCP 伺服器的 `search_documents` 工具。*
