---
name: memory-manager
description: "使用 Memory MCP 管理跨對話知識圖譜，儲存實體、關係與觀察，並與知識庫交叉引用。用於記錄跨對話的重要資訊。 Use when managing persistent memory or project notes."
---

# Memory Manager（知識圖譜 × 知識庫協作）

## 架構描述
跨對話知識圖譜管理，與 knowledge base 互補協作。
Memory 存精確事實，KB 存長篇文件，透過 `kb_ref:` 雙向連結。

## 觸發方式
- 「記住 [資訊]」「查詢記憶」「知識圖譜」
- 涉及人名、帳號、關係、跨專案事實時

## 協作決策樹

```
需要記錄資訊
├── 精確事實（人/帳號/IP/關係）→ Memory
├── 長篇文件（架構/SOP/分析）→ KB
└── 兩者都需要 → Memory 存摘要 + kb_ref 指向 KB
```

## 實體建立規範

### 命名格式
- 人：中文全名（張鐙勻）
- 專案：kebab-case（gitlab-adoption-project）
- 議題：Redmine-{ID}
- 服務：{provider}-{service}

### 必要 observations
每個實體至少包含：
1. 核心事實（一句話描述）
2. `kb_ref: {KB名稱}（說明）`（若有對應 KB 文件）

### 範例
```
create_entities:
  name: "Redmine-13006"
  entityType: "Issue"
  observations:
    - "dotmoremedia.com DNS 修復，已結案"
    - "kb_ref: aws-reddoor-route53（Route53 託管區域詳細文件）"
```

## 操作流程

### 寫入
1. 判斷存 Memory 還是 KB（依協作決策樹）
2. 建立實體 + 關係
3. 若有對應 KB，加入 `kb_ref:` observation

### 查詢
1. search_nodes 搜尋圖譜
2. 若 observation 含 `kb_ref:`，自動查詢對應 KB 補充細節
3. 合併回覆

### 維護
- 定期清理過時實體（已結案議題、過期狀態）
- 更新 kb_ref 指向（KB 重組時）

## 驗收標準
- [ ] 實體命名符合規範
- [ ] 有對應 KB 的實體包含 kb_ref
- [ ] 查詢時能正確觸發交叉引用
