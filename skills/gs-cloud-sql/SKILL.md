---
name: gs-cloud-sql
description: "管理 Google Cloud 上的 MySQL、PostgreSQL 與 SQL Server 關聯式資料庫實例，處理備份、高可用性與安全連線。 Use when managing Google Cloud Cloud SQL instances."
---

# Cloud SQL 基礎知識 (Cloud SQL Basics)

Cloud SQL 是一項適用於 MySQL、PostgreSQL 和 SQL Server 的全代管關聯式資料庫服務。它能自動執行耗時的任務，如補丁、更新、備份和副本，同時為您的應用程式提供高效能與高可用性。

## 先決條件 (Prerequisites)

確保您擁有建立和管理 Cloud SQL 實例所需的 IAM 權限。**Cloud SQL 管理員** (`roles/cloudsql.admin`) 角色提供對 Cloud SQL 資源的完整存取權限。

## 快速入門 (以 PostgreSQL 為例)

1.  **啟用 API：**
    ```bash
    gcloud services enable sqladmin.googleapis.com
    ```

2.  **建立實例 (Instance)：**
    ```bash
    gcloud sql instances create INSTANCE_NAME \
      --database-version=POSTGRES_18 \
      --cpu=2 \
      --memory=7680MiB \
      --region=REGION
    ```

3.  **為預設使用者設置密碼：**

    由於這是 Cloud SQL for PostgreSQL 實例，預設的管理員使用者為 `postgres`：
    ```bash
    gcloud sql users set-password postgres \
      --instance=INSTANCE_NAME --password=PASSWORD
    ```

4.  **建立資料庫：**
    ```bash
    gcloud sql databases create DATABASE_NAME \
      --instance=INSTANCE_NAME
    ```

5.  **獲取實例連線名稱：**

    您需要實例連線名稱（格式為 `PROJECT_ID:REGION:INSTANCE_NAME`）才能使用 Cloud SQL Auth Proxy 進行連線。使用以下指令獲取：
    ```bash
    gcloud sql instances describe INSTANCE_NAME \
      --format="value(connectionName)"
    ```

6.  **連線到實例：**

    必須執行 Cloud SQL Auth Proxy 才能連線到實例。在另一個終端機中，使用連線名稱啟動 Proxy：
    ```bash
    ./cloud-sql-proxy INSTANCE_CONNECTION_NAME
    ```

    在 Proxy 執行時，於另一個終端機中使用 `psql` 連線：
    ```bash
    psql "host=127.0.0.1 port=5432 user=postgres dbname=DATABASE_NAME password=PASSWORD sslmode=disable"
    ```

## 參考目錄 (Reference Directory)

-   [核心概念 (Core Concepts)](references/core-concepts.md)：實例架構、高可用性 (HA) 以及支援的資料庫引擎。
-   [CLI 用法 (CLI Usage)](references/cli-usage.md)：用於實例、資料庫與使用者管理的關鍵 `gcloud sql` 指令。
-   [用戶端程式庫與連接器 (Client Libraries & Connectors)](references/client-library-usage.md)：使用 Python、Java、Node.js 與 Go 連接到 Cloud SQL。
-   [MCP 用法 (MCP Usage)](references/mcp-usage.md)：使用 Cloud SQL 遠端 MCP 伺服器與 Gemini CLI 擴充功能。
-   [基礎設施即程式碼 (Infrastructure as Code)](references/iac-usage.md)：實例、資料庫與使用者的 Terraform 配置。
-   [IAM 與安全性 (IAM & Security)](references/iam-security.md)：預定義角色、SSL/TLS 憑證以及 Auth Proxy 配置。

*如果您需要這些參考資料中找不到的產品資訊，請使用 Developer Knowledge MCP 伺服器的 `search_documents` 工具。*
