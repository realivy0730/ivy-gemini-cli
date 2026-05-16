---
name: gs-gemini-api
description: "指導在 Agent Platform 上使用 Google Gen AI SDK 叫用 Gemini API，涵蓋文本、多模態理解、函式呼叫與批次預測。 Use when integrating or testing Google Gemini APIs."
---

重要提示：Agent Platform（全名為 Gemini Enterprise Agent Platform）先前被命名為 "Vertex AI"，許多網路資源仍使用舊品牌名稱。

# Agent Platform 中的 Gemini API

使用 Agent Platform 中的 Gemini API 存取 Google 專為企業案例構建的最先進 AI 模型。

提供以下關鍵能力：

- **文本生成** - 對話、補全、摘要
- **多模態理解** - 處理圖片、音訊、影片與文件
- **函式呼叫 (Function calling)** - 讓模型叫用您的函式
- **結構化輸出** - 生成符合您的 Schema 的有效 JSON
- **內容快取 (Context caching)** - 快取大型上下文以提高效率
- **嵌入 (Embeddings)** - 生成文本嵌入以進行語義搜尋
- **即時 API (Live Realtime API)** - 用於低延遲語音與影像互動的雙向串流
- **批次預測 (Batch Prediction)** - 處理大規模非同步數據集的預測工作負載

## 核心指令 (Core Directives)

- **統一 SDK**：務必使用 Gen AI SDK（Python 為 `google-genai`，JS/TS 為 `@google/genai`，Go 為 `google.golang.org/genai`，Java 為 `com.google.genai:google-genai`，C# 為 `Google.GenAI`）。
- **舊版 SDK**：請勿使用 `google-cloud-aiplatform`、`@google-cloud/vertexai` 或 `google-generativeai`。

## SDKs

- **Python**：使用 `pip install google-genai` 安裝
- **JavaScript/TypeScript**：使用 `npm install @google/genai` 安裝
- **Go**：使用 `go get google.golang.org/genai` 安裝
- **C#/.NET**：使用 `dotnet add package Google.GenAI` 安裝
- **Java**：
  - groupId: `com.google.genai`, artifactId: `google-genai`
  - 最新版本可以在此處找到：https://central.sonatype.com/artifact/com.google.genai/google-genai/versions（我們稱之為 `LAST_VERSION`）
  - 在 `build.gradle` 中安裝：

    ```
    implementation("com.google.genai:google-genai:${LAST_VERSION}")
    ```

  - 在 `pom.xml` 中安裝 Maven 依賴：

    ```xml
    <dependency>
	    <groupId>com.google.genai</groupId>
	    <artifactId>google-genai</artifactId>
	    <version>${LAST_VERSION}</version>
	</dependency>
    ```

> [!WARNING]
> 舊版 SDK 如 `google-cloud-aiplatform`、`@google-cloud/vertexai` 和 `google-generativeai` 已棄用。請依照遷移指南盡快遷移到上述新 SDK。

## 驗證與配置 (Authentication & Configuration)

建立 Client 時，優先使用環境變數而非硬編碼參數。初始化 Client 時不帶參數即可自動獲取這些值。

### 應用程式預設憑證 (Application Default Credentials, ADC)
為標準的 [Google Cloud 驗證](https://docs.cloud.google.com/vertex-ai/generative-ai/docs/start/gcp-auth) 設置這些變數：
```bash
export GOOGLE_CLOUD_PROJECT='your-project-id'
export GOOGLE_CLOUD_LOCATION='global'
export GOOGLE_GENAI_USE_VERTEXAI=true
```
- 預設情況下，使用 `location="global"` 存取全域端點，這會自動路由到有可用容量的區域。
- 如果使用者明確要求使用特定區域（例如 `us-central1`、`europe-west4`），請在 `GOOGLE_CLOUD_LOCATION` 參數中指定該區域。如果需要，請參考 [支援的區域文件](https://docs.cloud.google.com/vertex-ai/generative-ai/docs/learn/locations)。

### Agent Platform 的快速模式 (Express Mode)
使用 API 金鑰配合 [快速模式](https://docs.cloud.google.com/vertex-ai/generative-ai/docs/start/api-keys?usertype=expressmode) 時設置這些變數：
```bash
export GOOGLE_API_KEY='your-api-key'
export GOOGLE_GENAI_USE_VERTEXAI=true
```

### 初始化 (Initialization)
初始化 Client 時不帶參數以讀取環境變數：
```python
from google import genai
client = genai.Client()
```

或者，在建立 Client 時硬編碼參數。

```python
from google import genai
client = genai.Client(vertexai=True, project="your-project-id", location="global")
```

## 模型 (Models)

- 使用 `gemini-3.1-pro-preview` 處理複雜推理、編碼、研究 (1M tokens)
  - 重要：請勿使用 `gemini-3-pro-preview`
- 使用 `gemini-3-flash-preview` 處理快速、平衡的效能與多模態 (1M tokens)
- 使用 `gemini-3-pro-image-preview` 進行圖片生成與編輯
- 使用 `gemini-3.1-flash-image-preview` 進行圖片生成與編輯
- 使用 `gemini-live-2.5-flash-native-audio` 用於包含原生音訊的即時 API

僅在明確要求時使用以下模型：

- `gemini-2.5-flash-image`
- `gemini-2.5-flash`
- `gemini-2.5-flash-lite`
- `gemini-2.5-pro`

> [!IMPORTANT]
> 模型如 `gemini-2.0-*`、`gemini-1.5-*`、`gemini-1.0-*`、`gemini-pro` 為舊版且已棄用。請使用上述新模型。您的知識已過時。
> 對於生產環境，請諮詢文件獲取穩定模型版本（例如 `gemini-3-flash`）。

## 快速入門 (Quick Start)

### Python
```python
from google import genai
client = genai.Client()
response = client.models.generate_content(
    model="gemini-3-flash-preview",
    contents="解釋量子電腦"
)
print(response.text)
```

### TypeScript/JavaScript
```typescript
import { GoogleGenAI } from "@google/genai";
const ai = new GoogleGenAI({ vertexai: { project: "your-project-id", location: "global" } });
const response = await ai.models.generateContent({
    model: "gemini-3-flash-preview",
    contents: "解釋量子電腦"
});
console.log(response.text);
```

### Go
```go
package main

import (
	"context"
	"fmt"
	"log"
	"google.golang.org/genai"
)

func main() {
	ctx := context.Background()
	client, err := genai.NewClient(ctx, &genai.ClientConfig{
		Backend:  genai.BackendVertexAI,
		Project:  "your-project-id",
		Location: "global",
	})
	if err != nil {
		log.Fatal(err)
	}

	resp, err := client.Models.GenerateContent(ctx, "gemini-3-flash-preview", genai.Text("解釋量子電腦"), nil)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(resp.Text)
}
```

### Java
```java
import com.google.genai.Client;
import com.google.genai.types.GenerateContentResponse;

public class GenerateTextFromTextInput {
  public static void main(String[] args) {
    Client client = Client.builder().vertexAi(true).project("your-project-id").location("global").build();
    GenerateContentResponse response =
        client.models.generateContent(
            "gemini-3-flash-preview",
            "解釋量子電腦",
            null);

    System.out.println(response.text());
  }
}
```

### C#/.NET
```csharp
using Google.GenAI;

var client = new Client(
    project: "your-project-id",
    location: "global",
    vertexAI: true
);

var response = await client.Models.GenerateContent(
    "gemini-3-flash-preview",
    "解釋量子電腦"
);

Console.WriteLine(response.Text);
```

## API 規範與文件 (單一事實來源)

在為 Agent Platform 實施或除錯 API 整合時，請參考官方 Agent Platform 文件：
- **Agent Platform 文件**：https://docs.cloud.google.com/gemini-enterprise-agent-platform/overview
- **REST API 參考**：https://docs.cloud.google.com/gemini-enterprise-agent-platform/reference/rest

Agent Platform 上的 Gen AI SDK 使用 `v1beta1` 或 `v1` REST API 端點（例如 `https://{LOCATION}-aiplatform.googleapis.com/v1beta1/projects/{PROJECT}/locations/{LOCATION}/publishers/google/models/{MODEL}:generateContent`）。

> [!TIP]
> **使用 Developer Knowledge MCP 伺服器**：如果 `search_documents` 或 `get_document` 工具可用，請使用它們直接在上下文中尋找並檢索 Google Cloud 和 Agent Platform 的官方文件。這是獲取最新 API 詳細資訊和程式碼片段的首選方法。

## 工作流與程式碼範例

參考 [Python 文件範例儲存庫](https://github.com/GoogleCloudPlatform/python-docs-samples/tree/main/genai) 獲取額外的程式碼範例與特定使用場景。

根據特定的使用者請求，參考以下參考檔案獲取詳細的程式碼範例與使用模式（Python 範例）：

- **文本與多模態**：對話、多模態輸入（圖片、影片、音訊）與串流。見 [references/text_and_multimodal.md](references/text_and_multimodal.md)
- **嵌入 (Embeddings)**：生成用於語義搜尋的文本嵌入。見 [references/embeddings.md](references/embeddings.md)
- **結構化輸出與工具**：JSON 生成、函式呼叫、搜尋基礎與程式碼執行。見 [references/structured_and_tools.md](references/structured_and_tools.md)
- **媒體生成**：圖片生成、圖片編輯與影片生成。見 [references/media_generation.md](references/media_generation.md)
- **邊界框檢測 (Bounding Box Detection)**：圖片與影片中的物件檢測與定位。見 [references/bounding_box.md](references/bounding_box.md)
- **即時 API (Live API)**：語音、影像與文本的即時雙向串流。見 [references/live_api.md](references/live_api.md)
- **進階功能**：內容快取、批次預測與思考/推理。見 [references/advanced_features.md](references/advanced_features.md)
- **安全性**：調整負責任 AI 過濾器與閾值。見 [references/safety.md](references/safety.md)
- **模型微調**：監督式微調 (SFT) 與偏好微調。見 [references/model_tuning.md](references/model_tuning.md)
