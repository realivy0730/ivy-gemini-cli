## 配置數據 (kiro-cli config)

```yaml
meta:
  owner: Ivy
  type: skill
  skill_id: gitlab-api
  version: 2.0
  scope: global

gitlab:
  api_url: https://gitlab.com/api/v4
  token_source: "~/.zshrc → $GITLAB_PERSONAL_ACCESS_TOKEN"
  mcp_agent: "~/.kiro/agents/AmazonQ.json → mcpServers.gitlab"
  user_id: 36256896
  username: ivy-reddoor
  plan: ultimate_trial
  trial_ends_on: "2026-04-30"

  token_expires: "2027-04-01"
  token_rotate_method: "POST /personal_access_tokens/self/rotate"

  # 主要 Group
  primary_group:
    id: 128527314
    name: reddoor
    path: reddoor-group
    description: 紅門互動股份有限公司

  # 角色對應 (access_level)
  access_levels:
    guest: 10
    reporter: 20
    developer: 30
    maintainer: 40
    owner: 50
```

---

## 執行流程

### MCP 工具能力（@zereight/mcp-gitlab v2.0.35）

| Toolset | 工具數 | 涵蓋操作 |
|---------|--------|---------|
| `merge_requests` | 34 | MR CRUD、notes、discussions、conflicts、diffs |
| `pipelines` | 19 | Pipeline、job、deployment、environment、artifacts |
| `issues` | 14 | Issue CRUD、notes、links、discussions |
| `wiki` | 10 | Wiki CRUD（project + group） |
| `milestones` | 9 | Milestone CRUD、burndown |
| `projects` | 8 | Project/namespace、group projects、iterations |
| `repositories` | 7 | 搜尋、建立檔案、push、fork、tree |
| `releases` | 7 | Release CRUD、evidence |
| `labels` | 5 | Label CRUD |
| `users` | 5 | User info、events、upload |
| `branches` | 4 | Branch、commits、diffs |

MCP 工具透過 `~/.zshrc` 的 `$GITLAB_PERSONAL_ACCESS_TOKEN` 認證，由 AmazonQ.json 引用注入。

### curl REST API（備用）

僅在 MCP 工具不支援時使用，詳見 `references/curl-examples.md`。

### SSH Git 操作

```shell
git clone git@gitlab.com:reddoor-group/reddoor/{subgroup}/PROJECT.git
git push origin main
```

---
```shell
curl -s --header "PRIVATE-TOKEN: $TOKEN" \
  "https://gitlab.com/api/v4/groups/128527314" | jq '{id, name, path, description, visibility, web_url}'
```

---

## 版本歷史

### v2.2 (2026-04-06)
- SSH key (id_rsa) 已加入 GitLab，支援 git push/pull
- MCP 能力對照表更新為 @zereight/mcp-gitlab v2.0.35 完整 toolsets（~140 工具）
- 移除大量 curl 範例（MCP 已涵蓋），curl 降為極少數備用
- 新增 SSH 配置區塊（key ID、clone URL pattern）

### v2.1 (2026-04-06)
- Token 管理統一至 ~/.zshrc，SKILL.md 不再存放 token 明文
- 新增 Token 管理架構圖（~/.zshrc → AmazonQ.json $VARIABLE → MCP Server）
- curl 改用 $GITLAB_PERSONAL_ACCESS_TOKEN 環境變數
- 與 github MCP Server 對齊統一管理模式

### v2.0 (2026-04-05)
- 加入 MCP 工具優先、curl 備用的雙軌連線方式
- 更新方案資訊：Free → Ultimate Trial（到期 2026-04-30）
- 新增 token_env 配置（GITLAB_PERSONAL_ACCESS_TOKEN）
- 新增 MCP 工具對照表
- username 修正：ivy1 → ivy-reddoor

### v1.1 (2026-04-01)
- Token rotate 至 2027-04-01（Free 方案最長 365 天）
- 補充 token_expires 和 token_rotate_method 配置
- 更新 Token 安全說明，加入 API rotate 方式

### v1.0 (2026-03-31)
- 初版建立
- 支援 Group/Project/Member/Issue/MR/Pipeline 操作
- Token 內嵌於 Skill 配置中，取代 ~/.zshrc 環境變數

---

**建立日期**: 2026-03-31
**最後更新**: 2026-04-06
**維護者**: Ivy
**版本**: 2.2
