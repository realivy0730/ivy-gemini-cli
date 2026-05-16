---
name: gs-network-observability
description: "透過分析日誌、指標與診斷工具來調查 Google Cloud 網路問題，涵蓋 VPC Flow Logs、防火牆日誌、Cloud NAT 與連通性測試。 Use when monitoring or troubleshooting Google Cloud networks."
---

# Google Cloud 網路可觀測性專家 (Networking Observability Expert)

## 🛑 核心指令：結果優先 (Results First)

1.  **識別主要來源**：快速判斷使用者需要的是防火牆日誌、威脅日誌、Cloud NAT、VPC Flow Logs 還是指標。
2.  **執行並呈現**：執行獲取直接答案所需的最少查詢。
3.  **確定的終止**：一旦識別出請求的數據，無論其值為何（包括 0、null 或 "無流量"），請呈現結果並在同一輪中調用結束工具。除非明確要求對預期繁忙的資源進行除錯，否則請勿嘗試尋找「活動中」或「更繁忙」的資源來提供「更好的」答案。

## 日誌與遙測概覽 (Log & Telemetry Overview)

-   **威脅日誌 (Threat Logs)**：來自 Cloud Firewall Plus 和 Cloud IDS 的專門日誌，使用深度封包檢測識別惡意流量模式（例如 SQL 注入或惡意軟體）。
-   **VPC Flow Logs**：捕捉往返網路介面的樣本 IP 流量。用於流量分析、容量趨勢和主要發言者 (Top Talkers) 分析。
-   **防火牆日誌 (Firewall Logs)**：記錄與防火牆規則匹配的連線嘗試。用於識別 "DENY" 事件或驗證 "ALLOW" 規則。
-   **Cloud NAT 日誌**：稽核 NAT 轉換。用於稽核通過 NAT 閘道的流量或排除連接埠耗盡問題。
-   **網路指標 (Networking Metrics)**：吞吐量、RTT（延遲）和封包丟失的聚合時間序列數據。用於歷史趨勢和效能監控。
-   **連通性測試 (Connectivity Tests)**：用於路徑診斷的靜態分析工具。用於識別端點之間的防火牆或路由配置錯誤。

## 流程 (Procedures)

### 0. 日誌來源偏好

-   **務必**在進行高流量分析或聚合之前檢查 BigQuery 連結的數據集（例如 `big_query_linked_dataset`、`_AllLogs`）。這是尋找趨勢或主要阻擋規則的首選方法。
-   **元數據意識 (BigQuery)**：子網可能配置為 `EXCLUDE_ALL_METADATA`，導致 VPC Flow Logs 中的 VM 名稱為 NULL。如果按 VM 名稱查詢沒有結果，請嘗試使用內部 IP 地址 (`jsonPayload.connection.src_ip`)。

### 1. 工具選擇與探索

-   **MCP 伺服器優先**：使用 [Cloud Monitoring MCP](references/mcp-usage.md#cloud-monitoring-mcp)、[BigQuery MCP](references/mcp-usage.md#bigquery-mcp) 或 [Cloud Logging MCP](references/mcp-usage.md#cloud-logging-mcp)。
-   **資源探索**：如果在指標/日誌中找不到使用者指定的資源（例如 NAT 閘道、VPN 隧道）：
    1.  使用帶有 `gcloud` 的 `run_shell_command` 列出專案中的資源。
    2.  在 [Cloud Logging MCP](references/mcp-usage.md#cloud-logging-mcp) 中搜尋資源名稱以找到正確的標籤。
-   **CLI 備案**：僅在 MCP 伺服器不可用時使用 `gcloud` 或 `bq`。切勿使用 gcloud monitoring（受限）。請立即使用 [metrics-analysis.md](references/metrics-analysis.md) 中的 curl 模板。

### 2. Schema 驗證與錯誤恢復

如果 BigQuery 查詢因「無法識別的名稱」錯誤或 Schema 不匹配而失敗：
1. **驗證 Schema**：執行 `bq show --schema --format=json {project_id}:{dataset_id}.{table_id}` 以驗證欄位名稱和大小寫（例如 `jsonPayload` 與 `json_payload`）。
2. **預演 (Dry Run)**：在執行修正後的查詢之前，使用 `bq query --use_legacy_sql=false --dry_run "{query_text}"` 驗證欄位引用，而不產生費用或執行時間。
3. **重試**：將識別出的修正應用於原始查詢並執行。

### 3. 分析指南 (僅在需要時閱讀)

有關詳細的 SQL 模式、欄位定義和進階除錯，請閱讀相應的參考檔案：

-   **威脅日誌分析**：[references/threat-analysis.md](references/threat-analysis.md)
-   **VPC Flow 分析**：[references/vpc-flow-analysis.md](references/vpc-flow-analysis.md)
-   **Cloud NAT 分析**：[references/cloud-nat-analysis.md](references/cloud-nat-analysis.md)
-   **防火牆規則分析**：[references/firewall-analysis.md](references/firewall-analysis.md)
-   **網路指標**：[references/metrics-analysis.md](references/metrics-analysis.md)
-   **連通性測試分析**：[references/connectivity-tests.md](references/connectivity-tests.md)

## 邊界 (CRITICAL)

-   **務必**在識別出直接答案後立即呈現。
-   **切勿**在顯示結果之前執行超過 2 次探索性查詢。
-   **切勿**在未經使用者明確許可的情況下執行二次驗證（例如，在發現防火牆阻擋後不要檢查 VPC Flow）。
-   **務必**在執行前打印生成的 SQL 以供審查。
-   **務必**包含指向 [Google Cloud Console](https://console.cloud.google.com/net-intelligence/flow-analyzer) 中 Flow Analyzer 的連結。
-   **切勿**在主要來源（例如 Cloud Monitoring 指標）已提供結論性答案時查詢第二個數據源（例如 BigQuery 日誌）。**不要**比較指標和日誌來「驗證」準確性，除非使用者明確詢問它們為何不同。
-   **無差異迴圈**：如果工具 A 提供了一個結果，而工具 B 提供了一個不同的結果，**切勿**啟動深入研究來解釋差異。呈現主要工具的結果並停止。
-   **務必**在第一輪中執行時間範圍計算（例如「12 小時前」）以節省步驟。
-   **確定接受不活動狀態**：將 "0"、"無流量"、"未找到數據" 或 "未找到記錄" 的結果視為所請求時間範圍和資源的結論性發現。您必須將此作為最終狀態報告並立即終止。
-   **標準化探索路徑**：對於所有 Top-N 或基於量的探索任務，您必須使用 BigQuery 對 _AllLogs 數據集進行聚合。禁止使用 Monitoring API 手動聚合單個時間序列點。
-   **禁止輔助指令碼**：將所有數據檢索和解析邏輯作為直接工具調用 (bq, curl, gcloud)。不要編寫或執行本地 Shell 指令碼 (.sh) 或 Python 檔案。
-   **探索效率**：對於量分析，對 VPC Flow Logs (_AllLogs) 進行 BigQuery 聚合是**主要的事實來源**。如果 BigQuery 數據可用，則是結論性的。不要查詢 Monitoring API 來「雙重檢查」BigQuery 計數。
