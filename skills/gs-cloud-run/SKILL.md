---
name: gs-cloud-run
description: "管理 Cloud Run 服務、作業與工作池。用於部署回應 HTTP 請求的應用程式、執行事件驅動任務或處理背景程序。 Use when deploying or managing Google Cloud Cloud Run services."
---

# Cloud Run 基礎知識 (Cloud Run Basics)

Cloud Run 是一個全代管的應用程式平台，用於在 Google 高度可擴充的基礎設施之上執行您的程式碼、函式或容器。它抽象化了基礎設施管理，提供三種主要的資源類型：

1.  **服務 (Services)：** 回應發送到唯一且穩定端點的 HTTP 請求，使用根據多項關鍵指標自動擴充的無狀態實例，也回應事件與函式。
2.  **作業 (Jobs)：** 執行可並行化的任務，這些任務可以手動執行或按排程執行，並執行至完成。
3.  **工作池 (Worker pools)：** 處理始終開啟的背景工作負載，例如基於提取 (pull-based) 的工作負載（如 Kafka 消費者、Pub/Sub 提取隊列或 RabbitMQ 消費者）。

## 先決條件 (Prerequisites)

1.  啟用 Cloud Run Admin API 和 Cloud Build API：

    ```bash
    gcloud services enable run.googleapis.com cloudbuild.googleapis.com
    ```

1.  如果您受到組織政策限制，[限制](https://docs.cloud.google.com/organization-policy/restrict-domains)專案中未經身分驗證的叫用，您將需要按照[測試私有服務](https://docs.cloud.google.com/run/docs/triggering/https-request#testing-private)所述存取部署的服務。

### 必要角色 (Required roles)

您需要以下角色來部署 Cloud Run 資源：

*   Cloud Run 管理員 (`roles/run.admin`) 於專案
*   Cloud Run 原始碼開發人員 (`roles/run.sourceDeveloper`) 於專案
*   服務帳戶使用者 (`roles/iam.serviceAccountUser`) 於服務身分
*   日誌檢視者 (`roles/logging.viewer`) 於專案

Cloud Build 預設會使用 Compute Engine 預設服務帳戶作為 Cloud Build 服務帳戶來構建您的原始碼與 Cloud Run 資源，除非您覆蓋此行為。

為了讓 Cloud Build 構建您的原始碼，請授予 Cloud Build 服務帳戶在專案中的 Cloud Run 構建者 (`roles/run.builder`) 角色：

```bash
gcloud projects add-iam-policy-binding PROJECT_ID \
    --member=serviceAccount:SERVICE_ACCOUNT_EMAIL_ADDRESS \
    --role=roles/run.builder
```

將 `PROJECT_ID` 替換為您的 Google Cloud 專案 ID，將 `SERVICE_ACCOUNT_EMAIL_ADDRESS` 替換為 Cloud Build 服務帳戶的電子郵件地址。

## 部署 Cloud Run 服務 (Deploy a Cloud Run service)

您可以使用容器映像檔部署服務，或使用單個 Google Cloud CLI 指令直接從原始碼部署。

> **關鍵規則：** 任何部署的程式碼都必須監聽 0.0.0.0 (而非 127.0.0.1) 並使用注入的 $PORT 環境變數 (預設為 8080)，否則啟動時會崩潰。

### 將容器映像檔部署到 Cloud Run

Cloud Run 在部署期間導入您的容器映像檔。只要服務修訂版本仍在使用，Cloud Run 就會保留該容器映像檔的副本。當啟動新的 Cloud Run 實例時，不會從容器儲存庫中提取容器映像檔。

### 支援的容器映像檔

您可以直接使用儲存在 [Artifact Registry](https://docs.cloud.google.com/artifact-registry/docs/overview) 或 [Docker Hub](https://hub.docker.com/) 的容器映像檔。Google 建議使用 Artifact Registry，因為 Docker Hub 映像檔會[快取](https://docs.cloud.google.com/artifact-registry/docs/pull-cached-dockerhub-images)長達一小時。

您可以藉由設置 [Artifact Registry 遠端儲存庫](https://docs.cloud.google.com/artifact-registry/docs/repositories/remote-repo)，使用來自其他公共或私有登錄庫（如 JFrog Artifactory、Nexus 或 GitHub Container Registry）的容器映像檔。

您應僅考慮使用 [Docker Hub](https://hub.docker.com/) 部署受歡迎的容器映像檔，如 [Docker 官方映像檔](https://docs.docker.com/docker-hub/official_images/) 或 [Docker 資助的 OSS 映像檔](https://docs.docker.com/docker-hub/dsos-program/)。為了獲得更高的可用性，Google 建議使用 [Artifact Registry 遠端儲存庫](https://docs.cloud.google.com/artifact-registry/docs/repositories/remote-repo) 部署這些 Docker Hub 映像檔。

若要部署容器映像檔，請執行以下指令：

```bash
    gcloud run deploy SERVICE_NAME \
        --image IMAGE_URL \
        --region us-central1 \
        --allow-unauthenticated
```

替換以下內容：

*   SERVICE_NAME：您要部署到的服務名稱。服務名稱長度必須在 49 個字元以內，且在每個區域與專案中必須是唯一的。如果服務尚不存在，此指令會在部署期間建立服務。您可以完全省略此參數，但如果省略，系統會提示您輸入服務名稱。
*   IMAGE_URL：容器映像檔的引用，例如 `us-docker.pkg.dev/cloudrun/container/hello:latest`。如果您使用 Artifact Registry，儲存庫 REPO_NAME 必須已經建立。URL 格式為 `LOCATION-docker.pkg.dev/PROJECT_ID/REPO_NAME/PATH:TAG`。注意，如果不提供 `--image` 旗標，部署指令將嘗試從原始碼部署。

### 從原始碼部署 (Deploy from source code)

從原始碼部署服務有兩種不同的方式：

*   帶有構建的原始碼部署（預設）：此選項使用 Google Cloud 的 buildpacks 和 Cloud Build 自動從您的原始碼構建容器映像檔，而無需在您的機器上安裝 Docker 或設置 buildpacks 或 Cloud Build。預設情況下，Cloud Run 使用 Cloud Build 提供的預設機器類型。

    *   若要啟用自動基礎映像檔更新並從原始碼部署，請執行以下指令：

         ```bash
         gcloud run deploy SERVICE_NAME --source . \
         --base-image BASE_IMAGE \
         --automatic-updates
         ```

        Cloud Run 僅支持使用 [Google Cloud 的 buildpacks 基礎映像檔](https://docs.cloud.google.com/docs/buildpacks/base-images) 的自動基礎映像檔。

        *   若要使用 Dockerfile 從原始碼部署，請執行以下指令：

         ```bash
          gcloud run deploy SERVICE_NAME --source .
         ```
            當您提供 Dockerfile 時，Cloud Build 會在雲端中執行它並部署服務。

*   無構建的原始碼部署（預覽版）：此選項直接將成果部署到 Cloud Run，繞過 Cloud Build 步驟。這可以實現快速部署。若要進行無構建的原始碼部署，請執行以下指令：

    ```bash
    gcloud beta run deploy SERVICE_NAME \
     --source APPLICATION_PATH \
     --no-build \
     --base-image=BASE_IMAGE \
     --command=COMMAND \
     --args=ARG
    ```

    替換以下內容：

    *   SERVICE_NAME：您的 Cloud Run 服務名稱。
    *   APPLICATION_PATH：應用程式在本地檔案系統中的位置。
    *   BASE_IMAGE：您要用於應用程式的[運行時基礎映像檔](https://docs.cloud.google.com/run/docs/configuring/services/runtime-base-images#how_to_obtain_base_images)。例如 `us-central1-docker.pkg.dev/serverless-runtimes/google-24-full/runtimes/nodejs24`。您也可以使用僅限操作系統的基礎映像檔（如 `osonly24`）部署預編譯的二進制檔案，而無需配置額外的語言特定運行時組件。
    *   COMMAND：容器啟動時執行的指令。
    *   ARG：您發送到容器指令的參數。如果使用多個參數，請分別指定每一行。

    有關無構建原始碼部署的範例，請參閱[無構建原始碼部署範例](https://docs.cloud.google.com/run/docs/deploying-source-code#examples-without-build)。

## 建立與執行 Cloud Run 作業 (Create and execute a Cloud Run job)

若要建立新作業，請執行以下指令：

```bash
gcloud run jobs create JOB_NAME --image IMAGE_URL OPTIONS
```

或者使用部署指令：

```bash
gcloud run jobs deploy JOB_NAME --image IMAGE_URL OPTIONS
```

替換以下內容：

*   JOB_NAME：您要建立的作業名稱。如果省略此參數，執行指令時會提示您輸入作業名稱。
*   IMAGE_URL：容器映像檔的引用，例如 `us-docker.pkg.dev/cloudrun/container/job:latest`。

*   （選用）將 OPTIONS 替換為以下任何旗標：

    *   `--tasks`：接受大於或等於 1 的整數。預設為 1；最大值為 10,000。每個任務都提供環境變數 `CLOUD_RUN_TASK_INDEX`（值介於 0 到任務數減 1 之間）以及 `CLOUD_RUN_TASK_COUNT`（任務總數）。
    *   `--max-retries`：失敗任務重試的次數。一旦任何任務失敗超過此限制，整個作業將標記為失敗。例如，如果設置為 1，失敗任務將重試一次，總共兩次嘗試。預設為 3。接受 0 到 10 的整數。
    *   `--task-timeout`：接受持續時間如 "2s"。預設為 10 分鐘；最大值為 168 小時（7 天）。對於使用 GPU 的任務，最大可用逾時時間為 1 小時。
    *   `--parallelism`：可以並行執行的最大任務數。預設情況下，任務將儘可能快地並行啟動。
    *   --execute-now：如果設置，建立作業後立即啟動作業執行。相當於先後調用 `gcloud run jobs create` 和 `gcloud run jobs execute`。

    除了上述選項外，您還可以指定更多配置，如環境變數或記憶體限制。

有關建立作業時可用選項的完整列表，請參閱 [`gcloud run jobs create`](https://docs.cloud.google.com/sdk/gcloud/reference/run/jobs/create) 命令列文件。

等待作業建立完成。成功完成後，您將看到成功訊息。

若要執行現有作業，請執行以下指令：

```bash
gcloud run jobs execute JOB_NAME
```

如果您希望指令等待執行完成，請執行以下指令：

```bash
gcloud run jobs execute JOB_NAME --wait --region=REGION
```

替換以下內容：

*   JOB_NAME：作業名稱。
*   REGION：資源所在的區域。例如 `europe-west1`。或者設置 `run/region` 屬性。

## 部署工作池 (Deploy a worker pool)

您可以使用容器映像檔部署 Cloud Run 工作池，或直接從原始碼部署。

### 部署容器映像檔

您可以指定帶有標籤的容器映像檔（例如 `us-docker.pkg.dev/my-project/container/my-image:latest`）或帶有精確摘要的容器映像檔（例如 `us-docker.pkg.dev/my-project/container/my-image@sha256:41f34ab970ee...`）。

### 支援的容器映像檔

您可以直接使用儲存在 [Artifact Registry](https://docs.cloud.google.com/artifact-registry/docs/overview) 或 [Docker Hub](https://hub.docker.com/) 的容器映像檔。Google 建議使用 Artifact Registry，因為 Docker Hub 映像檔會[快取](https://docs.cloud.google.com/artifact-registry/docs/pull-cached-dockerhub-images)長達一小時。

您可以藉由設置 [Artifact Registry 遠端儲存庫](https://docs.cloud.google.com/artifact-registry/docs/repositories/remote-repo)，使用來自其他公共或私有登錄庫（如 JFrog Artifactory、Nexus 或 GitHub Container Registry）的容器映像檔。

您應僅考慮使用 [Docker Hub](https://hub.docker.com/) 部署受歡迎的容器映像檔，如 [Docker 官方映像檔](https://docs.docker.com/docker-hub/official_images/) 或 [Docker 資助的 OSS 映像檔](https://docs.docker.com/docker-hub/dsos-program/)。為了獲得更高的可用性，Google 建議使用 [Artifact Registry 遠端儲存庫](https://docs.cloud.google.com/artifact-registry/docs/repositories/remote-repo) 部署這些 Docker Hub 映像檔。

若要部署容器映像檔，請執行以下指令：

```bash
gcloud run worker-pools deploy WORKER_POOL_NAME --image IMAGE_URL
```

替換以下內容：

*   WORKER_POOL_NAME：您要部署到的工作池名稱。如果工作池尚不存在，此指令會在部署期間建立工作池。您可以完全省略此參數，但如果省略，系統會提示您輸入工作池名稱。
*   IMAGE_URL：包含工作池的容器映像檔引用，例如 `us-docker.pkg.dev/cloudrun/container/worker-pool:latest`。注意，如果不提供 `--image` 旗標，部署指令將嘗試從原始碼部署。

等待部署完成。成功完成後，Cloud Run 將顯示成功訊息以及有關部署工作池修訂版本的資訊。

### 從原始碼部署工作池 (Deploy a worker pool from source)

您可以使用單個 gcloud CLI 指令 `gcloud run worker-pools deploy` 帶有 `--source` 旗標，直接從原始碼部署新的工作池或工作池修訂版本到 Cloud Run。

如果您不提供 `--image` 或 `--source` 旗標，部署指令預設會從原始碼部署。

在後端，此指令使用 [Google Cloud 的 buildpacks](https://docs.cloud.google.com/docs/buildpacks/overview) 與 Cloud Build 自動從您的原始碼構建容器映像檔，而無需在您的機器上安裝 Docker 或設置 buildpacks 或 Cloud Build。預設情況下，Cloud Run 使用 Cloud Build 提供的預設機器類型。

若要從原始碼部署工作池，請執行以下指令：

```bash
gcloud run worker-pools deploy WORKER_POOL_NAME --source .
```

將 `WORKER_POOL_NAME` 替換為您想要的工作池名稱。

### 部署失敗時該怎麼辦：

1.  **IAM/權限錯誤：** 閱讀 [iam-security.md](references/iam-security.md)。
2.  **啟動時崩潰 / 健康檢查失敗：** 立即使用 `gcloud logging read "resource.labels.service_name=SERVICE_NAME" --limit=20` 獲取日誌，以找出確切的運行時錯誤。
3.  **原生依賴錯誤 (Node/Python)：** 如果使用 `--no-build`，請切換至 `--source .` (Buildpacks) 以便為 Linux 正確編譯原生擴充功能。

## 參考目錄 (Reference Directory)

-   [核心概念 (Core Concepts)](references/core-concepts.md)：服務 vs. 作業 vs. 工作池、資源模型以及服務的自動擴充行為。
-   [CLI 用法 (CLI Usage)](references/cli-usage.md)：用於部署與管理的關鍵 `gcloud run` 指令。
-   [用戶端程式庫 (Client Libraries)](references/client-library-usage.md)：使用 Google Cloud 用戶端程式庫與 Cloud Run 互動。
-   [MCP 用法 (MCP Usage)](references/mcp-usage.md)：使用 Cloud Run 遠端 MCP 伺服器。
-   [基礎設施即程式碼 (Infrastructure as Code)](references/iac-usage.md)：服務、作業、工作池與 IAM 綁定的 Terraform 範例。
-   [IAM 與安全性 (IAM & Security)](references/iam-security.md)：角色、服務身分以及入口/出口控制。

*如果您需要這些參考資料中找不到的產品資訊，請使用 Developer Knowledge MCP 伺服器的 `search_documents` 工具。*
