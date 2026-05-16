---
name: gs-onboarding
description: "指導開發者在 Google Cloud 上的初步操作，涵蓋帳戶建立、帳單設置、專案管理以及部署第一個資源。 Use when onboarding new users or projects to Google Cloud."
---

# Google Cloud 上線指南 (Onboarding to Google Cloud)

此技能為個人開發者提供了開始使用 [Google Cloud](https://cloud.google.com/) 的簡化路徑。它涵蓋了從初始帳戶設置到部署第一個雲端資源的所有內容。

## 概覽

對於個人開發者來說，加入 Google Cloud 涉及建立個人身分、設置付款方式以及建立用於管理資源的工作空間（**[專案 (Project)](https://docs.cloud.google.com/resource-manager/docs/cloud-platform-resource-hierarchy#projects)**）。Google Cloud 為多種產品提供免費層級和免費試用。[點此了解更多](https://docs.cloud.google.com/free/docs/free-cloud-features)。

## 澄清問題

在繼續之前，代理程式應澄清使用者的當前狀態：

1.  您是否已經擁有 [Google 帳戶](https://accounts.google.com/)（Gmail 或 [Google Workspace](https://workspace.google.com/)）？
2.  您是想為學習/實驗目的設置個人帳戶，還是您是擁有現有基礎設施的組織的一部分？
3.  您是大型企業中的 IT 管理員，正在為組織設置 Google Cloud 嗎？
4.  您有興趣構建的第一種資源或應用程式類型是什麼（例如網站、數據管道、虛擬機）？
5.  您偏好使用命令列 (CLI)、IDE（如 VSCode）還是網頁版的 [Google Cloud 控制台](https://console.cloud.google.com/)？

## 先決條件

-   一個 [Google 帳戶](https://accounts.google.com/)（例如 @gmail.com）。
-   有效的付款方式（信用卡或銀行帳戶）用於帳單驗證（即使是免費試用）。

## 步驟

### 1. 註冊並啟用免費抵免額

1.  前往 [Google Cloud 控制台](https://console.cloud.google.com/)。
2.  使用您的 Google 帳戶登入。這將啟用 [您的 $300 免費抵免額](https://docs.cloud.google.com/free/docs/free-cloud-features#free-trial)。

### 2. 建立您的第一個 Google Cloud 專案

Google Cloud 資源組織在 **[專案 (Projects)](https://docs.cloud.google.com/resource-manager/docs/cloud-platform-resource-hierarchy#projects)** 中。

1.  在控制台頂部的專案選取器下拉式選單中，點擊。
2.  點擊 **新建專案 (New Project)**。
3.  輸入 **專案名稱**（例如 `my-first-gcp-project`）。
4.  記下生成的 **專案 ID**；您將在 CLI 和 API 互動中使用它。
5.  點擊 **建立 (Create)**。

### 3. 設置帳單 (Billing)

確保您的專案連結到您的免費試用 [Cloud Billing](https://docs.cloud.google.com/billing/docs/how-to/manage-billing-account) 帳戶。

1.  前往控制台的 **帳單 (Billing)** 區段。
2.  確認您的新專案列在「連結到此帳單帳戶的專案」下。

### 4. 安裝並初始化 Google Cloud CLI

**[Google Cloud CLI](https://docs.cloud.google.com/sdk/docs/install-sdk)** (`gcloud` CLI) 是從本地機器與 Google Cloud 互動的主要工具。

1.  [下載並安裝 Google Cloud CLI](https://cloud.google.com/sdk/docs/install)。
2.  開啟終端機並執行：`gcloud init`
3.  按照提示登入並選擇您的專案。

### 5. 啟用必要的 API

大多數服務在使用前都需要啟用其特定的 [API](https://docs.cloud.google.com/apis/docs/overview)。例如，要使用 [Cloud Run](https://docs.cloud.google.com/run/docs/overview/what-is-cloud-run)，請執行：
`gcloud services enable run.googleapis.com`

### 6. 部署您的第一個資源

根據您的需求選擇一個簡單的切入點：
- **[Cloud Run](https://docs.cloud.google.com/run/docs)（推薦用於應用程式）：** 部署一個容器化的 "Hello World" 應用程式。
- **[Compute Engine](https://docs.cloud.google.com/compute/docs)：** 建立一個小型 Linux VM。
- **[Cloud Storage](https://docs.cloud.google.com/storage/docs)：** 建立一個 Bucket 來存儲檔案。

範例 (Cloud Run)： 

```bash 
    gcloud run deploy hello-world \
    --image=gcr.io/cloudrun/hello \ --platform=managed \ --region=us-central1 \
    --allow-unauthenticated
```

此指令將輸出一個公共 URL。恭喜 - 您剛剛部署了第一個 Google Cloud 資源！

## 驗證邏輯

使用此邏輯來判斷使用者是否已成功完成 Google Cloud 上線流程：

-   **專案已建立**：使用者是否有專案 ID？
-   **帳單已連結**：專案是否與帳單帳戶相關聯？
-   **CLI 已驗證**：`gcloud config list` 是否顯示正確的帳戶與專案？
-   **資源已驗證**：使用者是否可以存取已部署資源的 URL 或 IP？
