---
name: gs-reliability
description: "根據 Google Cloud 完善架構框架 (WAF) 提供可靠性指導，涵蓋資源冗餘、水平擴充、可觀測性與優雅降級。 Use when improving reliability or SRE practices on Google Cloud."
---

# Google Cloud 完善架構框架 (WAF) —— 可靠性支柱

## 概覽

Google Cloud 完善架構框架的可靠性支柱提供了原則與建議，幫助您在 Google Cloud 中設計、部署和管理可靠、具備彈性且高可用的工作負載。可靠的系統在定義的條件下持續執行其預定功能，對故障具有彈性，並能從中優雅恢復。

## 核心原則

可靠性支柱的建議符合以下核心原則：

-  **根據使用者體驗目標定義可靠性**：可靠性的衡量應反映使用者的實際體驗，而非僅依賴基礎設施指標。
-  **設定現實的可靠性目標**：確定適當的服務水準目標 (SLOs)，平衡成本複雜性與業務需求。
-  **透過資源冗餘構建高可用系統**：透過跨區域 (Zone) 和區域 (Region) 複製關鍵組件來消除單點故障。
-  **利用水平擴充能力**：設計系統架構以水平擴充（增加更多實例），以無縫應對負載波動。
-  **透過可觀測性檢測潛在故障**：實施全面的監控、日誌記錄與告警系統，以便在造成影響前發現異常。
-  **設計優雅降級 (Graceful Degradation)**：當依賴項失效或系統承受極大壓力時，確保系統仍能維持關鍵功能。
-  **執行故障恢復測試**：透過持續模擬故障並驗證自動/手動恢復程序來增強信心。

## 相關 Google Cloud 產品

以下是與可靠性相關的 Google Cloud 產品與功能範例：

- **運算**：Managed Instance Groups (MIGs), GKE, Cloud Run
- **網路**：Cloud Load Balancing, Cloud CDN, Cloud DNS
- **存儲與資料庫**：Cloud Storage (多區域), Cloud SQL 高可用性, Spanner, Firestore
- **維運**：Cloud Monitoring, Cloud Logging, Managed Service for Prometheus
- **災難復原**：Backup and DR Service

## 工作負載評估問題

提出適當的問題以了解工作負載的可靠性相關需求：

- 您的組織如何定義與衡量與使用者體驗相關的可靠性？
- 您確保資源冗餘以實現高可用性的策略是什麼？
- 您如何利用水平擴充來維持效能與可靠性？
- 您如何利用可觀測性（指標、日誌、追蹤）來獲得洞察並檢測潛在故障？
- 您的組織多久進行一次全面的系統故障恢復測試（例如區域失效轉移）？

## 驗證清單 (Validation Checklist)

使用以下清單評估架構與可靠性建議的一致性：

- 以使用者為中心的 SLIs 和 SLOs 已明確定義並主動監控。
- 架構透過跨區域或跨區域冗餘避免了單點故障。
- 已啟用自動擴充 (Autoscaling) 以處理變動的需求，無需人工干預。
- 已配置應用程式與基礎設施健康檢查以觸發自動失效轉移。
- 設有定期備份排程，並例行測試還原程序。
- 系統架構採用了熔斷器 (Circuit Breakers)、帶有指數退避的重試以及速率限制等模式。
