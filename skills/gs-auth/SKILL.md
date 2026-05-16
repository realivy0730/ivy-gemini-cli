---
name: gs-auth
description: "提供關於向 Google Cloud 服務與 API 進行身分驗證與授權的專家指導，涵蓋人類使用者、服務身分與 ADC。 Use when configuring Google Cloud authentication or IAM."
---

# 向 Google Cloud 進行身分驗證 (Authenticating to Google Cloud)

[身分驗證 (Authentication)](https://docs.cloud.google.com/docs/authentication) 是證明**您是誰**的過程。在 Google Cloud 中，您代表一個**主體 (Principal)**（身分，如使用者或服務）。這是進行[授權 (Authorization)](https://docs.cloud.google.com/iam/docs/overview)（確定**您可以做什麼**）之前的第一步。

## 身分驗證 (Authentication)

### 代理程式的澄清問題

在提供特定解決方案之前，請向使用者澄清以下幾點：

1.  **誰或什麼正在進行驗證？**（人類開發者、本地指令碼或在生產環境中執行的應用程式？）
2.  **程式碼在哪裡執行？**（本地筆電、[Compute Engine](https://docs.cloud.google.com/compute/docs)、[GKE](https://docs.cloud.google.com/kubernetes-engine/docs)、[Cloud Run](https://docs.cloud.google.com/run/docs) 或另一個雲端如 AWS/Azure？）
3.  **目標是什麼？**（Google Cloud API 如 Storage/BigQuery，或是您構建的自定義應用程式？）
4.  **您是否使用高階用戶端程式庫？**（例如 Python、Go、Node.js 程式庫通常會自動處理 ADC。）

---

## 人類身分驗證 (Human Authentication)

使用者要存取 Google Cloud，需要一個 Google Cloud 能夠識別的身分。

### 使用者身分模型

Google Cloud 支援多種為您的內部員工（開發者、管理員、員工）配置身分的方式：

*   **[Google 管理的帳戶](https://docs.cloud.google.com/iam/docs/user-identities#google-accounts)**：您可以使用 Cloud Identity 或 Google Workspace 建立管理的單一使用者帳戶。
*   **[使用 Cloud Identity 或 Google Workspace 進行同盟](https://docs.cloud.google.com/iam/docs/user-identities#synced-federation)**：允許使用者使用其現有的身分與憑證登入 Google 服務。使用者向外部身分提供者 (IdP) 進行驗證。
*   **[工作人力身分同盟 (Workforce Identity Federation)](https://docs.cloud.google.com/iam/docs/user-identities#workforce)**：這讓您可以使用外部 IdP 直接透過 IAM 對員工進行驗證與授權。與標準同盟不同，您不需要將使用者身分從現有 IdP 同步到 Google Cloud。

### 開發者與管理員的存取方法

用於在開發與管理期間與 Google Cloud 資源及 API 互動。

*   **[Google Cloud Console](https://console.cloud.google.com/)**：主要的網頁介面。
*   **[gcloud CLI](https://docs.cloud.google.com/sdk/docs/install-sdk) (`gcloud auth login`)**：用於驗證 CLI 本身，以便執行管理指令。
*   **本地開發與 [應用程式預設憑證 (ADC)](https://docs.cloud.google.com/docs/authentication/application-default-credentials) (`gcloud auth application-default login`)**：這與 CLI 驗證不同。它會建立一個本地 JSON 檔案，Google Cloud **用戶端程式庫** (Python, Java 等) 在您於本地執行程式碼時會使用該檔案「代表您」行事。
*   **[服務帳戶模擬 (Service Account Impersonation)](https://docs.cloud.google.com/docs/authentication/use-service-account-impersonation)**：出於安全考慮，開發者應完全避免下載服務帳戶金鑰。相反，他們應以人類身分登入，並使用服務帳戶模擬來執行指令或生成短期憑證。這是本地開發與除錯的關鍵最佳實踐。

---

## 服務對服務身分驗證 (Service-to-Service Authentication)

當程式碼在生產環境中執行時，應使用**服務帳戶 (Service Account)** 而非人類使用者帳戶。

### 服務帳戶與服務代理

*   **[服務帳戶 (Service Account)](https://docs.cloud.google.com/iam/docs/service-account-overview)**：專供非人類使用者使用的特殊身分。
*   **[服務代理 (Service Agent)](https://docs.cloud.google.com/iam/docs/service-agents)**：由 Google 管理的服務帳戶，允許 Google 服務（如 Pub/Sub）代表您存取資源。

### 最佳實踐：附加服務帳戶

應將自定義服務帳戶**附加**到 Google Cloud 資源，而非使用**服務帳戶金鑰**（危險的 JSON 檔案）。資源環境隨後會透過本地元數據伺服器提供**令牌 (Token)**。

*   **[Compute Engine](https://docs.cloud.google.com/compute/docs/access/create-enable-service-accounts-for-instances)**：在 VM 建立期間分配服務帳戶。
*   **[Cloud Run](https://docs.cloud.google.com/run/docs/securing/service-identity)**：在服務配置中分配服務帳戶。

### 特殊情況與進階主題

#### Kubernetes Engine (GKE)

使用 **[GKE 工作負載身分同盟 (Workload Identity Federation for GKE)](https://docs.cloud.google.com/kubernetes-engine/docs/how-to/workload-identity)** 將 Kubernetes 身分映射到 IAM 主體標識符。

#### 外部工作負載 ([工作負載身分同盟](https://docs.cloud.google.com/iam/docs/workload-identity-federation))

對於在 Google Cloud **外部**（例如 AWS、Azure 或地端）執行的程式碼，請勿使用金鑰。相反，使用工作負載身分同盟來交換短期 Google Cloud 存取令牌。

#### [API 金鑰](https://docs.cloud.google.com/docs/authentication/api-keys)

API 金鑰是用於公開數據（例如 Google Maps）或簡化存取（如 Vertex AI 快速模式）的加密字串。

---

## 授權 (Authorization)

在身分驗證之後，Google Cloud 使用 **[身分與存取權管理 (IAM)](https://docs.cloud.google.com/iam/docs/overview)** 來確定經過驗證的主體可以做什麼。

*   **允許政策 (Allow Policy)**：在資源上將**主體**綁定到**角色**的記錄。
*   **[預定義角色](https://docs.cloud.google.com/iam/docs/understanding-roles)**：預建的角色，如 `roles/storage.objectViewer`。**務必優先嘗試使用這些角色。**
*   **[自定義角色](https://docs.cloud.google.com/iam/docs/creating-custom-roles)**：如果預定義角色太寬泛，使用者定義的特定權限集合。

---

## 範例

### 人類對服務 (本地 Python 開發)

1.  **驗證 (Authn)**：執行 `gcloud auth application-default login` 建立本地憑證 (ADC)。
2.  **授權 (Authz)**：授予您的電子郵件在 Bucket 上的 `roles/storage.objectViewer` 角色。
3.  **程式碼**：使用 Python `storage.Client()`。它會自動尋找本地 ADC。

---

## 驗證清單 (Validation Checklist)

-   [ ] 使用者是否在本地執行程式碼？建議使用 `gcloud auth application-default login` 或**服務帳戶模擬**。
-   [ ] 使用者是否嘗試在本地使用服務帳戶金鑰？強烈建議不要這樣做，並推薦使用模擬。
-   [ ] 使用者是否在生產環境中執行？推薦附加自定義、最小權限的服務帳戶，而非使用金鑰。
-   [ ] 使用者是否依賴 Compute Engine 預設服務帳戶？推薦建立自定義服務帳戶。
-   [ ] 使用者是否在另一個雲端執行？推薦使用工作負載身分同盟。

## 參考資料 (References)

-   [身分驗證概覽](https://docs.cloud.google.com/docs/authentication)
-   [應用程式預設憑證 (ADC)](https://docs.cloud.google.com/docs/authentication/provide-credentials-adc)
-   [服務帳戶最佳實踐](https://docs.cloud.google.com/iam/docs/best-practices-service-accounts)
