---
name: subagent-guide
description: "建立與調用 Kiro Subagent 的指南，含能力邊界定義與多 Agent 任務協調。用於設定 Subagent 協作、檢查 Agent 限制或編排複雜任務。 Use when creating or managing subagents."
---

# Subagent 協作指南（Kiro 官方架構）

## 架構描述
基於 Kiro 官方 Subagents 架構，定義 Custom Agent 的建立、調用規範與能力邊界。

## Kiro Subagents 核心概念
- Subagents **並行執行**，主 agent 等待所有 subagent 完成
- 每個 subagent 有**獨立 context window**，不污染主 agent
- Steering files 和 MCP servers 在 subagent 中正常運作
- **Specs 和 Hooks 不在 subagent 中運作**

## ⚠️ 能力邊界定義（最高優先級）

### Subagent 能力矩陣

| 能力 | 本 Workspace | 跨目錄 | 說明 |
|------|:----------:|:------:|------|
| read / write | ✅ | ✅ 絕對路徑 | 可讀寫任何允許目錄 |
| shell | ✅ | ✅ cd + 執行 | 可 cd 到任何目錄 |
| MCP 工具 | ✅ | ✅ | 與主 agent 相同 |
| Steering | ✅ 本 workspace | ❌ | 只載入啟動 workspace |
| Knowledge | ✅ 本 workspace | ❌ | 不載入其他 KB 語義索引 |
| Specs / Hooks | ❌ | ❌ | Subagent 中不運作 |

### 跨目錄操作三層級
- **Level 1**（✅ 可做）：檔案讀寫 + Shell 命令
- **Level 2**（❌ 不可做）：知識庫語義理解 → 需在該 workspace 開獨立對話
- **Level 3**（❌ 不可做）：跨 KB 決策推理 → 需主 agent 整合結果

## Custom Agent 建立
- **全域**：`~/.kiro/agents/{name}.json`
- **專案級**：`{workspace}/.kiro/agents/{name}.json`
- 必須包含「能力邊界」段落

## 調用方式
- **自動選擇**：Kiro 根據 description 匹配
- **明確調用**：`/agent-name 任務描述`
- **並行調用**：`使用 subagents 同時執行...`

## 多 Agent 任務協調（orchestrator）

**切換方式**：`ctrl+o` 或 `/agent swap orchestrator`

### 可用 Subagents

| Agent | 信任等級 | 用途 |
|-------|---------|------|
| CloudOps | trusted（免確認） | 雲端基礎設施操作（AWS/GCP/Azure） |
| KnowledgeKeeper | trusted（免確認） | 知識庫同步與文件維護 |
| mariadb-ops | available（需確認） | MariaDB 三節點操作（專案級） |

### 分派原則
- 獨立任務 → 並行分派（`depends_on` 無依賴）
- 有依賴的任務 → 串接（`depends_on` 指定前置）
- 雲端操作 → CloudOps | 文件同步 → KnowledgeKeeper
- 禁止全部串行，優先最大化並行度

### 常見場景
```
# 平行健康檢查
"使用 subagent 平行檢查三節點狀態"

# 跨雲稽核
"並行檢查 AWS ELB 和 GCP Load Balancer 配置"

# 任務 + 文件同步
"CloudOps 執行部署，KnowledgeKeeper 同步文件"
```

## 強制規範（全域規則 §6）

**來源**：LEARNINGS 提升（2026-04-17 + 2026-04-28 實戰經驗）

1. **AmazonQ 自身必須在 trustedAgents 中**：subagent 用 AmazonQ role 時需要免審批，否則 3 個並行 = 3 個等待審批 = 卡死
2. **shell 權限預授權**：subagent 的 agent JSON 必須設定 `allowedTools` 含 `shell`，避免並行執行時逐一審批造成阻塞
3. **trustedAgents 必設**：主 agent 的 `toolsSettings.subagent.trustedAgents` 必須包含所有會用到的 subagent 名稱
4. **agentPermissions 必設**：每個 trusted agent 必須定義 `allowedTools`，明確授權可用工具

### 任務執行方式決策樹（2026-04-28 新增）

```
任務類型判斷
├── 純資料收集（掃描/盤點/統計）
│   └── ✅ 直接用工具（shell/read/grep）— 最快最穩
├── 需要不同角色推理（架構/安全/review）
│   └── ✅ subagent（blocking）+ trustedAgents
├── 長時間任務（測試/分析/文件生成）
│   └── ✅ delegate（背景非同步）— 不阻塞主對話
└── 多專案並行修改
    └── ✅ delegate 或 subagent，視複雜度決定
```

### delegate 使用指引（2026-04-28 新增）

delegate 是非同步背景執行，適合不需要即時結果的任務：

```bash
# 啟用（已在 cli.json 設定）
chat.enableDelegate: true

# 使用方式（自然語言）
「建立背景任務分析 API 效能」
「在背景跑測試套件」
「背景生成 API 文件」

# 查詢狀態
「檢查背景任務狀態」
「顯示背景任務結果」
```

### 現行 AmazonQ.json trustedAgents 配置

```json
{
  "toolsSettings": {
    "subagent": {
      "availableAgents": ["*"],
      "trustedAgents": ["AmazonQ", "CloudOps", "KnowledgeKeeper", "orchestrator"],
      "agentPermissions": {
        "AmazonQ": {
          "allowedTools": ["read", "write", "shell", "code", "grep", "glob", "knowledge", "web_fetch", "web_search", "use_aws"]
        },
        "CloudOps": {
          "allowedTools": ["read", "write", "shell", "code", "use_aws", "knowledge"],
          "requireApproval": ["shell"]
        },
        "KnowledgeKeeper": {
          "allowedTools": ["read", "write", "shell", "knowledge"]
        }
      }
    }
  }
}
```

### 模型分配原則

| 任務類型 | 模型 | 適用 Agent |
|----------|------|----------|
| 架構/安全/review | Opus | 架構師、安全審計 |
| 開發/測試 | Sonnet | CloudOps、開發工作者 |
| 部署/文件 | Haiku | KnowledgeKeeper、部署 |

### Guardian 驗證流程（Dual-Track 借鑑）

DAG 完成後，主 Agent 執行：
1. 產出檢查：所有 subagent 產出是否符合預期
2. 衝突偵測：是否有多個 subagent 修改同一檔案
3. 品質閘門：關鍵操作需人工確認
4. 文件同步：CHANGELOG + README + INDEX

## 最佳實踐
- 明確 description 讓 Kiro 自動選擇正確 agent
- 最小 tools 權限、獨立任務、並行優先
- 每個 agent 標示能力層級（Level 1/2/3）

## ⚠️ subagent tool vs /agent swap（2026-04-17 實測）

### subagent tool 的 role 限制
`subagent` tool 的 `role` 參數只接受預定義 enum（AmazonQ, CloudOps, KnowledgeKeeper, orchestrator 等），**不支援自訂 agent 名稱**。

### 正確的自訂 agent subagent 觸發方式
```
/agent swap {orchestrator-agent-name}
> 用自然語言描述任務，Kiro 根據 toolsSettings.subagent 自動啟動子代理
```

### shell 審批阻塞
subagent 中使用 shell 工具時，每個 subagent 都會暫停等待使用者審批。多個並行 subagent 同時要求審批 = 實際序列化。

### 替代方案：shell background 並行
```shell
(command1) > /tmp/sa1.txt &
(command2) > /tmp/sa2.txt &
wait
cat /tmp/sa1.txt /tmp/sa2.txt
```

## 驗收標準
- [ ] Agent 配置檔已建立、格式正確
- [ ] Tools 權限最小化、Description 明確
- [ ] 能力邊界已標示

詳細配置範例、不可用工具清單、Shell 替代方案參見 `references/config-and-workarounds.md`。
