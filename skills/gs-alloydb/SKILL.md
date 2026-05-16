---
name: gs-alloydb
description: "管理 AlloyDB for PostgreSQL 的集群、實例與備份，並整合 AlloyDB MCP 工具進行自動化資料庫操作。 Use when managing or querying Google Cloud AlloyDB."
---

# AlloyDB 基礎知識 (AlloyDB Basics)

AlloyDB for PostgreSQL 是一項全代管、相容於 PostgreSQL 的資料庫服務，專為企業級效能與可用性而設計。它利用分離的運算與儲存架構來獨立擴展資源。它還提供 AlloyDB AI，這是一系列功能，包括 AI 驅動的搜尋（向量、混合搜尋與 AI 函式）、自然語言能力、對話式分析以及預測和模型端點管理等推理功能，幫助開發者更快構建 AI 應用程式。

## 快速入門 (Quick Start)

1.  **啟用 AlloyDB API：**

    ```bash
    gcloud services enable alloydb.googleapis.com
    ```

2.  **建立集群 (Cluster)：**

    ```bash
    gcloud alloydb clusters create my-cluster --region=us-central1 \
        --password=my-password --network=my-vpc
    ```

    *注意：對於生產環境，建議使用 IAM 資料庫驗證而非密碼。如果必須使用密碼，請使用安全的秘密管理（例如 Secret Manager），而非以明文傳遞密碼。*

3.  **建立主要實例 (Primary Instance)：**

    ```bash
    gcloud alloydb instances create my-primary --cluster=my-cluster \
        --region=us-central1 --instance-type=PRIMARY --cpu-count=2
    ```

## 參考目錄 (Reference Directory)

-   [核心概念 (Core Concepts)](references/core-concepts.md)：架構、分離儲存與效能特性。
-   [CLI 用法 (CLI Usage)](references/cli-usage.md)：用於集群與實例管理的關鍵 `gcloud alloydb` 指令。
-   [用戶端程式庫與連接器 (Client Libraries & Connectors)](references/client-library-usage.md)：使用 Python、Java、Node.js 與 Go 連接到 AlloyDB。
-   [MCP 用法 (MCP Usage)](references/mcp-usage.md)：使用 AlloyDB 遠端 MCP 伺服器與 Gemini CLI 擴充功能。
-   [基礎設施即程式碼 (Infrastructure as Code)](references/iac-usage.md)：Terraform 配置與部署範例。
-   [IAM 與安全性 (IAM & Security)](references/iam-security.md)：預定義角色、服務代理與資料庫驗證。

*如果您需要這些參考資料中找不到的產品資訊，請使用 Developer Knowledge MCP 伺服器的 `search_documents` 工具。*
