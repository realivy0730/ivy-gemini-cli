---
name: api-interface-design
description: "設計穩定、文件良好、難以誤用的 API 與介面。Use when designing APIs, module boundaries, REST/GraphQL endpoints, or frontend-backend contracts."
---

# API & Interface Design

## 架構描述
設計穩定、自文件化、難以誤用的 API 與模組介面。

## 觸發方式
- 「設計 API」「定義介面」「REST endpoint」
- 設計模組邊界、前後端合約時

## 設計原則

### 1. 好的介面讓對的事容易、錯的事困難
- 必要參數不可省略
- 可選參數有合理預設值
- 錯誤訊息明確指出修正方向

### 2. REST API 慣例
- 資源用名詞複數（`/users`、`/orders`）
- HTTP 方法語意正確（GET 讀取、POST 建立、PUT 更新、DELETE 刪除）
- 版本化（`/api/v1/`）
- 分頁（`?page=1&per_page=20`）

### 3. 錯誤處理
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "具體錯誤描述",
    "details": ["欄位 A 必填", "欄位 B 格式錯誤"]
  }
}
```

### 4. 文件化
- 每個 endpoint 附 request/response 範例
- 列出所有可能的 error code
- 標註 breaking change

### 5. 向後相容
- 新增欄位不破壞舊客戶端
- 棄用欄位先標記 deprecated，下個大版本才移除
- 用 API 版本號管理 breaking change

## 驗收標準
- [ ] 每個 endpoint 有 request/response 範例
- [ ] 錯誤回應格式統一
- [ ] 向後相容性已確認
- [ ] 文件已更新
