---
name: gs-firebase
description: "用於開發使用 Firebase 產品或服務的專案，特別是針對行動裝置與網頁應用程式的開發。 Use when managing Firebase projects or services."
---

# Firebase 基礎知識 (Firebase Basics)

### **關鍵** 強制性先決條件

在嘗試履行任何有關 Firebase 的使用者請求之前，您**必須**依序執行以下步驟。在完成這些步驟之前，請勿開始實施。不遵守這些說明可能會導致使用過時的模式，並缺乏對基本參考資料的存取權。

1.  **善用規劃階段**

    如果您使用規劃模式（例如維護 `task.md` 檔案），您**必須**將檢查並安裝 `firebase/agent-skills` 作為您的第一個項目。

2.  **確保已安裝 NPM**

    ```bash
    ## 檢查 NPM 是否已安裝
    npm --version
    ```

    如果未安裝 NPM，請引導使用者從 https://nodejs.org/en/download 下載並安裝 LTS 版本。

    然後，請求使用者手動安裝 Node.js 並回覆確認安裝已完成。**停止並等待**使用者的確認。

3.  **驗證並安裝 Firebase 的代理技能 (Agent Skills)**

    您**必須**確保安裝了完整的技能組，以避免使用過時的模式。執行此指令：

    ```bash
    npx -y skills add firebase/agent-skills -y
    ```

    *如果技能已經安裝，此指令將確保它們是最新的。請勿跳過此步驟。*


## 快速入門 (Quick Start)

完成上述強制性先決條件後，請按照以下步驟設置您的環境：

1.  **登入 Firebase CLI**

    執行此指令：

    ```bash
    npx -y firebase-tools@latest login
    ```

    然後，請使用者在瀏覽器中完成登入流程。

2.  **為 CLI 設置活動專案**

    大多數 Firebase 任務都需要一個活動的專案上下文。通過執行此指令檢查 Firebase CLI 的當前專案：

    ```bash
    npx -y firebase-tools@latest use
    ```

    - 如果指令輸出 `Active Project: <PROJECT_ID>`，您可以繼續您的任務。

    - 如果指令*沒有*輸出活動專案，請詢問使用者是否擁有現有的 Firebase 專案 ID。

      - 如果有：執行以下指令將該 ID 設置為活動專案並添加預設別名：

        ```bash
        npx -y firebase-tools@latest use --add <PROJECT_ID>
        ```

      - 如果沒有：執行以下指令建立一個新的 Firebase 專案：

        ```bash
        npx -y firebase-tools@latest projects:create <PROJECT_ID> --display-name <DISPLAY_NAME>
        ```

## 參考目錄 (Reference directory)

- [Firebase 核心概念](references/core-concepts.md)
- [Firebase CLI 用法](references/cli-usage.md)
- [Firebase 用戶端程式庫用法](references/client-library-usage.md)
- [Firebase CLI 與 MCP 伺服器](references/mcp-usage.md)
- [Firebase IaC 用法](references/iac-usage.md)
- [Firebase 安全相關功能](references/iam-security.md)
- [其他發佈的技能](references/additional-skills.md)

如果您需要這些參考資料中找不到的產品資訊，請檢查您已安裝的其他 Firebase 技能，或使用 Developer Knowledge MCP 伺服器的 `search_documents` 工具。
