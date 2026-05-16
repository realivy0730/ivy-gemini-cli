---
name: gitlab-repo-ops
description: Manage GitLab repository operations via SSH including clone, branch, commit, push, and merge request creation. Use when pushing code to GitLab, creating branches, or managing repository content.
---

# GitLab Repo 操作 Skill（全域）

## 架構描述

全域 Skill，使用 ivy 的 SSH 身份（id_rsa）對 GitLab reddoor-group 下的 Repo 進行 git 操作，搭配 MCP 工具建立 Merge Request。

### 身份與認證

```yaml
ssh_identity: ~/.ssh/id_rsa
gitlab_user: ivy-reddoor
git_config:
  user.name: Ivy
  user.email: ivy@reddoor.com.tw
base_url: git@gitlab.com:reddoor-group
```

### 適用場景
- Clone GitLab Repo 到本機
- 建立 feature branch 並推送變更
- 更新 README、文件、設定檔
- 透過 MCP 建立 Merge Request
- Repo 初始化與內容管理

## 觸發方式

- "幫我 clone XXX repo"
- "推送變更到 GitLab"
- "建立 feature branch 並提交"
- "更新 XXX repo 的 README"
- "建立 MR 合併到 main"

## 執行流程

### 1. Clone Repo

```shell
# 預設 clone 到 /tmp/{project-name}（避免污染工作目錄）
git clone git@gitlab.com:reddoor-group/{company}/{subgroup}/{project}.git /tmp/{project}
cd /tmp/{project}
```

company 對照：reddoor / dotmore / justar

### 2. 建立 Feature Branch

```shell
git checkout -b feature/{描述}
```

命名規範：
- `feature/{描述}` — 新功能或變更
- `hotfix/{描述}` — 緊急修復
- `docs/{描述}` — 文件更新

### 3. 修改、Commit、Push

```shell
git add .
git commit -m "type: 說明"
git push -u origin feature/{描述}
```

Commit message 規範：
- `feat: 新增功能描述`
- `fix: 修復問題描述`
- `docs: 文件更新描述`
- `chore: 維護性變更`
- 禁止空白或無意義的 commit message

### 4. 建立 Merge Request（透過 MCP）

使用 `create_merge_request` MCP 工具：
- source_branch: feature/{描述}
- target_branch: main
- title: 與 commit message 一致
- remove_source_branch: true

### 5. 清理本機

```shell
rm -rf /tmp/{project}
```

## 注意事項

- 所有 Repo 必須為 Private
- 禁止直接 push 到 main（使用 feature branch + MR）
- Clone 路徑預設 /tmp/，完成後清理
- 若 Repo 採用 Gitflow，遵循 Gitflow 分支保護規則
