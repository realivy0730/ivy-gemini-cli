---
name: playwright-automation
description: "Automate browser interactions via Playwright MCP (@playwright/mcp@latest) for navigation, snapshots, form filling, and testing. Use when testing web pages, automating browser tasks, or performing exploratory automation."
---

# Playwright 瀏覽器自動化

## 架構描述
透過 Playwright MCP（`npx @playwright/mcp@latest`）進行瀏覽器自動化，支援導航、無障礙快照、表單填寫、元素互動與 Web App 測試。

## MCP 啟動配置（官方規範）
```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest", "--user-data-dir", ".kiro/playwright-profile"]
    }
  }
}
```

### Playwright MCP vs Playwright CLI
| | MCP | CLI |
|---|---|---|
| 適用場景 | Agentic loops、探索式自動化 | Coding agents、大型 codebase |
| 運作方式 | LLM 呼叫 MCP tools | Agent 執行 shell 指令 |
| 預設模式 | Headed（可見瀏覽器） | Headless |
| 安裝方式 | `npx @playwright/mcp@latest` | `npm install -g @playwright/cli` |

本 Skill 使用 **MCP 模式**（kiro-cli 透過 MCP 工具呼叫）。

## 觸發方式
- 「測試這個網頁」「截圖這個 URL」
- 「自動填寫表單」「點擊按鈕」
- 「驗證 UI 行為」

## Decision Tree：選擇方法

```
使用者任務
├─ 靜態 HTML？
│  ├─ 是 → 直接讀取 HTML 辨識 selectors
│  │  ├─ 成功 → 用 Playwright 操作 selectors
│  │  └─ 失敗 → 當作動態網頁處理（見下方）
│  └─ 否（動態網頁）→ Server 是否已啟動？
│     ├─ 否 → 先啟動 server，再操作
│     └─ 是 → 偵察再行動：
│        1. browser_snapshot 取得頁面結構
│        2. 辨識目標元素的 ref
│        3. 執行操作（click/type/select）
│        4. 驗證結果（snapshot 或 screenshot）
```

## 核心工具

| 工具 | 用途 | 常用參數 |
|------|------|---------|
| `browser_navigate` | 導航到 URL | `url` |
| `browser_snapshot` | 取得頁面無障礙快照（優先用這個） | — |
| `browser_take_screenshot` | 截圖（視覺驗證用） | `type`, `fullPage`, `filename` |
| `browser_click` | 點擊元素 | `ref`, `element` |
| `browser_type` | 輸入文字 | `ref`, `text`, `submit` |
| `browser_fill_form` | 批次填寫表單 | `fields[]` |
| `browser_select_option` | 下拉選單 | `ref`, `values` |
| `browser_wait_for` | 等待文字/元素出現 | `text`, `textGone`, `time` |
| `browser_evaluate` | 執行 JavaScript | `function` |
| `browser_console_messages` | 取得 console 日誌 | `level` |
| `browser_network_requests` | 取得網路請求 | `includeStatic` |

## 標準操作流程

### 1. 偵察（必做）
```
browser_navigate → url
browser_snapshot → 取得頁面結構與 ref
```
**永遠先 snapshot 再操作**，不要猜測 selector。

### 2. 互動
```
browser_click → ref（從 snapshot 取得）
browser_type → ref, text
browser_fill_form → fields（批次填寫多個欄位）
```

### 3. 驗證
```
browser_snapshot → 確認狀態變更
browser_take_screenshot → 視覺證據
browser_console_messages → 檢查錯誤
```

## Server 管理模式

### 本地開發 Server
```shell
# 背景啟動 server
nohup npm start > /tmp/server.log 2>&1 &
SERVER_PID=$!

# 等待 server 就緒
sleep 3
curl -s http://localhost:3000 > /dev/null && echo "Server ready"

# 測試完畢後清理
kill $SERVER_PID
```

### 多 Server 場景
```shell
# 前端 + 後端同時啟動
nohup npm run dev --prefix frontend > /tmp/frontend.log 2>&1 &
nohup npm run dev --prefix backend > /tmp/backend.log 2>&1 &
```

## 常見模式

### 登入流程
```
1. navigate → 登入頁
2. snapshot → 找到帳號/密碼欄位 ref
3. fill_form → 填入帳密
4. click → 登入按鈕
5. wait_for → 等待登入成功文字
6. snapshot → 驗證已登入
```

### 表單測試
```
1. navigate → 表單頁
2. snapshot → 辨識所有欄位
3. fill_form → 填入測試資料
4. click → 送出
5. snapshot → 驗證成功/錯誤訊息
6. screenshot → 保存證據
```

### API 回應驗證
```
1. navigate → 觸發 API 的頁面
2. network_requests → 檢查 API 呼叫
3. console_messages → 檢查錯誤
4. evaluate → 執行 JS 取得資料
```

## 注意事項
- **snapshot 優先於 screenshot**：snapshot 回傳結構化資料（含 ref），screenshot 只是圖片
- **等待載入**：動態內容需用 `wait_for` 確認元素出現
- **錯誤處理**：操作失敗時先檢查 `console_messages` 和 `network_requests`
- **清理**：測試完畢關閉 browser（`browser_close`）和 server
