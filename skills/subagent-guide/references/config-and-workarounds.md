## 配置數據 (kiro-cli config)
```yaml
meta:
  owner: Ivy
  type: skill
  skill_id: subagent-guide
  version: 3.0
  scope: global

trigger:
  keywords: ["subagent", "custom agent", "並行", "子代理"]

agent_locations:
  global: "~/.kiro/agents/"
  workspace: "<workspace>/.kiro/agents/"

capability_boundary:
  level_1_file_shell:
    description: "檔案讀寫 + Shell 命令"
    subagent: true
    examples: ["執行腳本", "讀取產出", "寫入結果"]
  level_2_kb_context:
    description: "知識庫語義理解"
    subagent: false
    requires: "在該 workspace 開獨立 Kiro 對話"
  level_3_cross_kb:
    description: "跨 KB 決策推理"
    subagent: false
    requires: "主 agent 整合各 subagent 結果後推理"

existing_agents:
  workspace:
    - name: azure-cost-analyzer
      path: "宏庭/.kiro/agents/azure-cost-analyzer.md"
      tools: ["read", "write", "shell"]
      boundary: "Level 1 only — 執行腳本 + 讀取產出"
    - name: billing-reporter
      path: "宏庭/.kiro/agents/billing-reporter.md"
      tools: ["read", "write", "shell"]
      boundary: "Level 1 only — PDF 提取 + 報告生成"
```

## AmazonQ.json Subagent 配置

在 `~/.kiro/agents/AmazonQ.json` 中配置 subagent 行為：

```json
{
  "toolsSettings": {
    "subagent": {
      "availableAgents": ["*"],
      "trustedAgents": ["CloudOps", "KnowledgeKeeper"]
    }
  }
}
```

| 欄位 | 說明 |
|------|------|
| `availableAgents` | 可用 agent 列表，`["*"]` 表示全部可用 |
| `trustedAgents` | 免確認 agent 列表，調用時不需使用者同意 |

## Subagent 不可用工具清單

以下工具在 subagent 中**不可用**，需使用 Shell 替代方案：

| 不可用工具 | 替代方案 |
|-----------|---------|
| `use_aws` | `execute_bash` + `aws cli --output json` |
| `grep` | `execute_bash` + `grep` / `rg` |
| `glob` | `execute_bash` + `find` / `ls` |
| `web_search` | `execute_bash` + `curl` |
| `thinking` | `sequentialthinking`（MCP 工具，可用） |
| `todo_list` | 無替代，由主 agent 管理 |

## Shell 替代方案模板

將 `use_aws` 呼叫轉為 `execute_bash`：

```shell
# 原本（主 agent）：use_aws ec2 describe-transit-gateways
# 替代（subagent）：
aws ec2 describe-transit-gateways \
  --region ap-east-2 \
  --output json

# 跨帳號操作
aws ec2 describe-vpcs \
  --profile dotmore \
  --region ap-northeast-1 \
  --output json

# 寫入操作（需 --output json 確保可解析）
aws ec2 create-tags \
  --resources tgw-attach-xxx \
  --tags Key=Name,Value=MyAttachment \
  --region ap-east-2 \
  --output json
```

