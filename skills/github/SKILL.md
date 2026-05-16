---
name: github
description: "GitHub CLI 整合，管理 Issues、Pull Requests、Repos 與 Workflow。用於操作 GitHub 儲存庫。 Use when interacting with GitHub APIs, issues, or PRs."
---

# GitHub CLI Integration

## 架構描述
使用 gh CLI 整合 GitHub 操作，包含 issues、PRs、repos、workflows 管理。

## 觸發方式
- "建立 GitHub issue [標題]"
- "列出 PR"
- "合併 PR [編號]"
- "查看 workflow 狀態"

## 執行流程
1. 驗證 gh CLI 已安裝並登入
2. 執行對應的 gh 命令
3. 解析輸出結果
4. 記錄操作歷史

## 配置數據 (kiro-cli config)
```yaml
meta:
  owner: Ivy
  type: skill
  skill_id: github
  version: 1.0
  scope: global

trigger:
  keywords: ["github", "gh", "issue", "pr", "pull request", "workflow"]

prerequisites:
  - gh CLI 已安裝
  - gh auth login 已完成

workflow:
  issues:
    - name: 列出 issues
      command: gh issue list
      
    - name: 建立 issue
      command: gh issue create --title "${title}" --body "${body}"
      
    - name: 關閉 issue
      command: gh issue close ${issue_number}
      
  pull_requests:
    - name: 列出 PRs
      command: gh pr list
      
    - name: 建立 PR
      command: gh pr create --title "${title}" --body "${body}" --base main
      
    - name: 合併 PR
      command: gh pr merge ${pr_number} --squash
      
    - name: 審查 PR
      command: gh pr review ${pr_number} --approve
      
  repos:
    - name: 列出 repos
      command: gh repo list
      
    - name: Clone repo
      command: gh repo clone ${owner}/${repo}
      
    - name: 建立 repo
      command: gh repo create ${name} --public
      
  workflows:
    - name: 列出 workflows
      command: gh workflow list
      
    - name: 查看 workflow runs
      command: gh run list --workflow=${workflow_name}
      
    - name: 觸發 workflow
      command: gh workflow run ${workflow_name}
```

## 常用命令

### Issues
```shell
gh issue list
gh issue create --title "Bug: 登入失敗" --body "描述..."
gh issue view 123
gh issue close 123
```

### Pull Requests
```shell
gh pr list
gh pr create --title "Feature: 新增登入功能" --body "描述..."
gh pr view 456
gh pr merge 456 --squash
gh pr review 456 --approve
```

### Repos
```shell
gh repo list
gh repo clone owner/repo
gh repo create my-project --public
gh repo view
```

### Workflows
```shell
gh workflow list
gh run list
gh run view 789
gh workflow run deploy.yml
```

### API 呼叫
```shell
gh api repos/:owner/:repo/issues
gh api -X POST repos/:owner/:repo/issues -f title="標題"
```

## 驗收標準
- [ ] gh CLI 已安裝
- [ ] gh auth 已完成
- [ ] 命令執行成功
- [ ] 輸出結果正確
- [ ] 操作已記錄

## 使用範例
```
使用者: "建立 GitHub issue: 修復 CloudFront 502 錯誤"
Kiro:
1. 檢查 gh CLI 狀態
2. gh issue create --title "修復 CloudFront 502 錯誤" --body "..."
3. 回傳 issue URL
4. 記錄到 knowledge
```

## 注意事項
- 確認 gh CLI 已安裝：`brew install gh`
- 首次使用需登入：`gh auth login`
- 注意 repo 權限
- PR 合併前確認 CI 通過
- 敏感操作需二次確認
