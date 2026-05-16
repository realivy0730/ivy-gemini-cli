---
name: gs-bigquery
description: "管理 BigQuery 的資料集、資料表與作業，並整合 BigQuery ML 與 Gemini 進行進階數據分析與 AI 驅動的洞察。 Use when querying or managing Google Cloud BigQuery."
---

# BigQuery 基礎知識 (BigQuery Basics)

BigQuery 是一個無伺服器、AI 就緒的數據平台，可以使用 SQL 和 Python 對大數據集進行高速分析。其分離式架構將運算與儲存分開，允許它們獨立擴充，同時提供內建的機器學習、地理空間分析和商業智慧功能。

## 設定與基本用法 (Setup and Basic Usage)

1.  **啟用 BigQuery API：**
    ```bash
    gcloud services enable bigquery.googleapis.com
    ```

2.  **建立資料集 (Dataset)：**
    ```bash
    bq mk --dataset --location=US my_dataset
    ```

3.  **建立資料表 (Table)：**

    建立一個名為 `schema.json` 的檔案，包含您的資料表結構 (Schema)：

    ```json
    [
      {
        "name": "name",
        "type": "STRING",
        "mode": "REQUIRED"
      },
      {
        "name": "post_abbr",
        "type": "STRING",
        "mode": "NULLABLE"
      }
    ]
    ```

    然後使用 `bq` 工具建立資料表：

    ```bash
    bq mk --table my_dataset.mytable schema.json
    ```

4.  **執行查詢 (Query)：**
    ```bash
    bq query --use_legacy_sql=false \
    'SELECT name FROM `bigquery-public-data.usa_names.usa_1910_2013` \
    WHERE state = "TX" LIMIT 10'
    ```

## 參考目錄 (Reference Directory)

- [核心概念 (Core Concepts)](references/core-concepts.md)：儲存類型、分析工作流以及 BigQuery Studio 功能。
- [CLI 用法 (CLI Usage)](references/cli-usage.md)：用於管理數據與作業的關鍵 `bq` 命令列工具操作。
- [用戶端程式庫 (Client Libraries)](references/client-library-usage.md)：使用適用於 Python、Java、Node.js 與 Go 的 Google Cloud 用戶端程式庫。
- [MCP 用法 (MCP Usage)](references/mcp-usage.md)：使用 BigQuery 遠端 MCP 伺服器與 Gemini CLI 擴充功能。
- [基礎設施即程式碼 (Infrastructure as Code)](references/iac-usage.md)：用於資料集、資料表與預留 (Reservations) 的 Terraform 範例。
- [IAM 與安全性 (IAM & Security)](references/iam-security.md)：角色、權限與數據治理最佳實踐。

*如果您需要這些參考資料中找不到的產品資訊，請使用 Developer Knowledge MCP 伺服器的 `search_documents` 工具。*
