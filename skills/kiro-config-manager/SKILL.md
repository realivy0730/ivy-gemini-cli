---
name: kiro-config-manager
description: "管理 Kiro CLI 配置，包含 Agent JSON、Steering 檔案、Knowledges 目錄與 Subagent 設定。用於修改 Agent 配置或重構 Context 架構。 Use when managing Kiro CLI configurations."
---

# Kiro Config Manager（Kiro CLI 配置管理）

## 架構描述
統一管理 `~/.kiro/` 下的配置架構，包含 `agents/AmazonQ.json`（resources / prompt / toolsSettings）、`steering/` 常駐載入檔案、`knowledges/` 按需搜尋檔案。確保配置變更有備份、可驗證、可回滾。

## 觸發方式
- 「修改 AmazonQ.json 配置」
- 「調整 steering 檔案」
- 「管理 knowledges 目錄」
- 「kiro config audit」

## 執行流程

### Step 1：備份
```shell
BACKUP=~/.kiro/backup.$(date +%Y%m%d)
mkdir -p "$BACKUP"
cp -r ~/.kiro/agents "$BACKUP/"
cp -r ~/.kiro/steering "$BACKUP/"
cp -r ~/.kiro/knowledges "$BACKUP/" 2>/dev/null
echo "✅ 備份至 $BACKUP"
```

### Step 2：讀取當前狀態
```shell
python3 -c "
import json
d = json.load(open('$HOME/.kiro/agents/AmazonQ.json'))
print(f'prompt: {len(d.get(\"prompt\",\"\"))} chars')
print(f'resources: {len(d.get(\"resources\",[]))} items')
for r in d.get('resources',[]):
    print(f'  - {r}')
sa = d.get('toolsSettings',{}).get('subagent',{})
if sa:
    print(f'subagent.availableAgents: {sa.get(\"availableAgents\")}')
    print(f'subagent.trustedAgents: {sa.get(\"trustedAgents\")}')
"
```

### Step 3：執行變更
依需求類型執行：

**Resources 管理**：
- 新增：加入 `file://` 或 `skill://` 路徑
- 移除：刪除不再需要的 resource 項目
- Glob 化：將多個同目錄檔案合併為 `**/*.md` 模式

**Steering 管理**：
- 新增檔案至 `~/.kiro/steering/`（常駐載入，注意 token 消耗）
- 從 steering 移至 knowledges（降低常駐 token，改為按需搜尋）

**Knowledges 管理**：
- 新增檔案至 `~/.kiro/knowledges/`
- 執行 `knowledge update` 重新索引

### Step 4：驗證
```shell
# JSON 完整性
python3 -c "import json; json.load(open('$HOME/.kiro/agents/AmazonQ.json')); print('✅ JSON valid')"

# Steering 檔案清單
echo "=== Steering ==="
ls -la ~/.kiro/steering/*.md

# Knowledges 檔案清單
echo "=== Knowledges ==="
ls -la ~/.kiro/knowledges/ 2>/dev/null
```

## 配置架構參考
```
~/.kiro/
├── agents/AmazonQ.json    ← prompt + resources + toolsSettings
├── steering/              ← 常駐載入（高頻使用、精簡內容）
├── knowledges/            ← 按需搜尋（低頻使用、大型參考）
├── contexts/              ← 相容層（逐步遷移至 steering/knowledges）
└── backup.YYYYMMDD/       ← 回滾備份
```

### 決策原則
| 條件 | 放置位置 |
|------|---------|
| 每次對話都需要 | steering/ |
| 偶爾查詢即可 | knowledges/ |
| 超過 3KB 的參考文件 | knowledges/ |
| 強制規則 | steering/ |

## 配置數據 (kiro-cli config)
```yaml
meta:
  owner: Ivy
  type: skill
  skill_id: kiro-config-manager
  version: "1.0.0"
  scope: global

config:
  paths:
    agent_config: "~/.kiro/agents/AmazonQ.json"
    steering_dir: "~/.kiro/steering/"
    knowledges_dir: "~/.kiro/knowledges/"
    backup_dir: "~/.kiro/backup.{date}/"
  rollback_command: "cp -r ~/.kiro/backup.{date}/* ~/.kiro/"
```

## 驗收標準
- [ ] 變更前已建立備份
- [ ] AmazonQ.json 為合法 JSON
- [ ] resources 路徑可解析（無 404）
- [ ] steering 檔案總大小 < 15KB（避免 token 過度消耗）
- [ ] 回滾指令已記錄

## Steering 文件自動生成（融入自 create-steering-documents 方法論）

新專案或現有專案缺少 steering 文件時，可自動生成專案專屬的開發指引。

### 觸發方式
- 「建立專案 steering 文件」
- 「初始化 .kiro/steering」
- 「生成專案開發規範」

### 生成流程

**Step 1：專案分析**
分析專案類型，決定需要哪些 steering 文件：

| 專案類型 | 核心文件 | 可選文件 |
|----------|----------|----------|
| 基礎設施 (IaC) | project-standards.md, git-workflow.md | security-guidelines.md |
| 前端應用 | project-standards.md, frontend-standards.md | testing-strategy.md |
| 後端 API | project-standards.md, api-design.md | database-standards.md |
| 雲端運維 | project-standards.md, security-guidelines.md | monitoring-guidelines.md |

**Step 2：選擇 Front-matter 機制**

```yaml
# 每次對話都載入（強制規則、精簡內容）
---
inclusion: always
---

# 特定檔案時載入（框架專屬規範）
---
inclusion: fileMatch
fileMatchPattern: '*.tf|*.tfvars'
---

# 手動引用（大型參考文件）
---
inclusion: manual
---
```

**Step 3：生成文件**
```shell
mkdir -p .kiro/steering
# 依專案類型生成對應的 steering 文件
```

**Step 4：品質檢查**
- [ ] 所有文件有適當的 front-matter
- [ ] 指引內容具體可執行，非通用廢話
- [ ] 無衝突規範
- [ ] 包含安全與效能考量
- [ ] 總大小 < 15KB（避免 token 過度消耗）

### 全域 vs 專案 Steering

| 範圍 | 路徑 | 用途 |
|------|------|------|
| 全域 | `~/.kiro/steering/` | 跨專案強制規則（如 global-rules.md） |
| 專案 | `.kiro/steering/` | 專案專屬規範（如 api-design.md） |

## 注意事項
- AmazonQ.json 修改後需重啟 chat session 才生效
- steering 檔案越多，每次對話的 token 消耗越高
- knowledges 需透過 `knowledge add/update` 索引後才可搜尋
- 移除 resource 前確認無其他 Skill 依賴該路徑
